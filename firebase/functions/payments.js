const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios").default;
const crypto = require("crypto");
const { handlePayoutEvent } = require("./payouts");

const SNIPPE_BASE_URL = process.env.SNIPPE_BASE_URL || "https://api.snippe.sh";
const SNIPPE_API_KEY = process.env.SNIPPE_API_KEY;
const SNIPPE_WEBHOOK_SECRET = process.env.SNIPPE_WEBHOOK_SECRET;
const SNIPPE_WEBHOOK_URL = process.env.SNIPPE_WEBHOOK_URL;

const MIN_AMOUNT_TZS = 500;
const WEBHOOK_MAX_AGE_SECONDS = 300;

function snippeClient() {
  return axios.create({
    baseURL: SNIPPE_BASE_URL,
    headers: { Authorization: `Bearer ${SNIPPE_API_KEY}` },
  });
}

/**
 * Starts a Snippe hosted checkout session for one or more courses.
 * Price is always read from Firestore here, never trusted from the client.
 */
exports.createOrder = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "You must be signed in to buy a course."
    );
  }
  const userId = context.auth.uid;
  const courseIds = Array.isArray(data && data.courseIds)
    ? [...new Set(data.courseIds)]
    : [];
  if (courseIds.length === 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "courseIds must be a non-empty array."
    );
  }

  const db = admin.firestore();
  const userRef = db.collection("users").doc(userId);
  const userSnap = await userRef.get();
  if (!userSnap.exists) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "User profile not found."
    );
  }
  const user = userSnap.data();

  const lineItems = [];
  let amount = 0;

  for (const courseId of courseIds) {
    const courseRef = db.collection("courses").doc(courseId);
    const courseSnap = await courseRef.get();
    if (!courseSnap.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        `Course ${courseId} not found.`
      );
    }
    const course = courseSnap.data();
    const price = Number(course.price) || 0;
    if (price <= 0) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        `Course ${courseId} does not have a price set.`
      );
    }

    const alreadyPurchased = await userRef
      .collection("purchased_courses")
      .where("courses_ref", "==", courseRef)
      .limit(1)
      .get();
    if (!alreadyPurchased.empty) {
      throw new functions.https.HttpsError(
        "already-exists",
        `Course ${courseId} is already purchased.`
      );
    }

    const instructorRef = course.instructor_ref || null;
    let paymentAccountRef = null;
    let instructorDetailsRef = null;
    if (instructorRef) {
      const [paymentAccountSnap, instructorDetailsSnap] = await Promise.all([
        instructorRef.collection("payment_account").limit(1).get(),
        instructorRef.collection("instructor_details").limit(1).get(),
      ]);
      if (!paymentAccountSnap.empty) {
        paymentAccountRef = paymentAccountSnap.docs[0].ref;
      }
      if (!instructorDetailsSnap.empty) {
        instructorDetailsRef = instructorDetailsSnap.docs[0].ref;
      }
    }

    amount += price;
    lineItems.push({
      courseId,
      courseRef,
      title: course.title || "",
      price,
      totalLessons: course.total_lessons || 0,
      instructorName: course.instructor_name || "",
      paymentAccountRef,
      instructorDetailsRef,
    });
  }

  if (amount < MIN_AMOUNT_TZS) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      `Order total must be at least ${MIN_AMOUNT_TZS} TZS.`
    );
  }

  const orderRef = db.collection("orders").doc();
  await orderRef.set({
    userId,
    userRef,
    amount,
    currency: "TZS",
    status: "pending",
    lineItems,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const nameParts = (user.display_name || "").trim().split(/\s+/).filter(Boolean);
  const firstName = nameParts[0] || undefined;
  const lastName = nameParts.slice(1).join(" ") || undefined;

  try {
    const response = await snippeClient().post(
      "/api/v1/sessions",
      {
        amount,
        currency: "TZS",
        allowed_methods: ["mobile_money"],
        customer: {
          email: user.email || undefined,
          first_name: firstName,
          last_name: lastName,
          phone: user.phone_number || undefined,
        },
        webhook_url: SNIPPE_WEBHOOK_URL,
        metadata: { orderId: orderRef.id, userId },
      },
      { headers: { "Idempotency-Key": orderRef.id } }
    );

    functions.logger.info("Snippe session response", {
      orderId: orderRef.id,
      status: response.status,
      body: response.data,
    });

    // Snippe wraps the actual session fields in an envelope: {code, status, data: {...}}.
    const { checkout_url: checkoutUrl, reference } = response.data?.data || {};
    if (!checkoutUrl) {
      throw new Error("Snippe response did not include a checkout_url.");
    }

    await orderRef.update({
      checkoutUrl,
      snippeReference: reference || null,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { orderId: orderRef.id, checkoutUrl };
  } catch (err) {
    functions.logger.error("Snippe session creation failed", {
      orderId: orderRef.id,
      error: err.response ? err.response.data : err.message,
    });
    await orderRef.update({
      status: "failed",
      error: err.response ? JSON.stringify(err.response.data) : err.message,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    throw new functions.https.HttpsError(
      "internal",
      "Could not start the payment session. Please try again."
    );
  }
});

function isValidSignature(rawBody, timestamp, signature) {
  if (!timestamp || !signature || !SNIPPE_WEBHOOK_SECRET) return false;

  const ageSeconds = Math.abs(Date.now() / 1000 - Number(timestamp));
  if (!Number.isFinite(ageSeconds) || ageSeconds > WEBHOOK_MAX_AGE_SECONDS) {
    return false;
  }

  const expected = crypto
    .createHmac("sha256", SNIPPE_WEBHOOK_SECRET)
    .update(`${timestamp}.${rawBody}`)
    .digest("hex");

  const expectedBuf = Buffer.from(expected, "utf8");
  const signatureBuf = Buffer.from(signature, "utf8");
  if (expectedBuf.length !== signatureBuf.length) return false;
  return crypto.timingSafeEqual(expectedBuf, signatureBuf);
}

/**
 * Grants course access exactly once, on a confirmed `payment.completed` event.
 * Uses a transaction keyed on order.status so retried/duplicate webhooks are no-ops.
 */
async function fulfillOrder(db, orderRef, event) {
  const fulfilled = await db.runTransaction(async (tx) => {
    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists) return false;
    const order = orderSnap.data();
    if (order.status === "completed") return false;

    const now = admin.firestore.FieldValue.serverTimestamp();

    for (const item of order.lineItems || []) {
      const purchasedRef = order.userRef.collection("purchased_courses").doc();
      tx.set(purchasedRef, {
        courses_ref: item.courseRef,
        instructor_name: item.instructorName,
        purchase_date: now,
        reviwed: false,
        lessons: item.totalLessons || 0,
      });

      const historyRef = order.userRef.collection("purchase_history").doc();
      tx.set(historyRef, {
        user_ref: order.userRef,
        amount: item.price,
        currency: order.currency || "TZS",
        status: "Paid",
        transaction_type: "Snippe Mobile Money",
        date: now,
        courses_ref: item.courseRef,
        courses_name: item.title,
      });

      tx.update(item.courseRef, {
        downloaders: admin.firestore.FieldValue.arrayUnion(order.userRef),
      });

      if (item.instructorDetailsRef) {
        tx.update(item.instructorDetailsRef, {
          students: admin.firestore.FieldValue.arrayUnion(order.userRef),
        });
      }

      if (item.paymentAccountRef) {
        tx.update(item.paymentAccountRef, {
          balance: admin.firestore.FieldValue.increment(item.price),
          sales_reports: admin.firestore.FieldValue.arrayUnion({
            user_ref: order.userRef,
            amount: item.price,
            currency: order.currency || "TZS",
            status: "Paid",
            transaction_type: "Snippe Mobile Money",
            date: new Date(),
            courseRef: item.courseRef,
            course_name: item.title,
          }),
        });
      }
    }

    tx.update(orderRef, {
      status: "completed",
      completedAt: now,
      updatedAt: now,
      snippeEventId: event.id || null,
    });
    return true;
  });

  if (!fulfilled) {
    functions.logger.info("Order webhook ignored (already handled or missing order)", {
      orderId: orderRef.id,
      eventId: event.id,
    });
  }
}

const TERMINAL_FAILURE_EVENTS = ["payment.failed", "payment.voided", "payment.expired"];

exports.snippeWebhook = functions.https.onRequest(async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).send("Method not allowed");
    return;
  }

  const signature = req.get("X-Webhook-Signature");
  const timestamp = req.get("X-Webhook-Timestamp");
  const rawBody = req.rawBody ? req.rawBody.toString("utf8") : JSON.stringify(req.body);

  if (!isValidSignature(rawBody, timestamp, signature)) {
    functions.logger.warn("Snippe webhook signature verification failed", {
      hasSignature: !!signature,
      hasTimestamp: !!timestamp,
      timestamp,
      // Body logged raw here (not just parsed) because a bad signature can
      // also mean our parsing of the envelope shape is wrong, not just a
      // bad secret - this is a one-time debugging aid for the first live test.
      rawBody,
    });
    res.status(401).send("Invalid signature");
    return;
  }

  const event = req.body || {};
  functions.logger.info("Snippe webhook received", {
    type: event.type,
    id: event.id,
    // Full event logged until the payload shape is confirmed against a real
    // test payment - trim this back down once verified.
    event,
  });

  const metadata = (event.data && event.data.metadata) || {};
  const db = admin.firestore();

  if (typeof event.type === "string" && event.type.startsWith("payout.")) {
    const payoutId = metadata.payoutId;
    if (!payoutId) {
      functions.logger.warn("Snippe payout webhook has no data.metadata.payoutId - ignoring", {
        type: event.type,
        metadata,
      });
      res.status(200).send("ignored");
      return;
    }
    try {
      await handlePayoutEvent(db, db.collection("payouts").doc(payoutId), event);
      res.status(200).send("ok");
    } catch (err) {
      functions.logger.error("Snippe payout webhook processing failed", {
        payoutId,
        eventType: event.type,
        error: err.message,
      });
      res.status(500).send("processing error");
    }
    return;
  }

  const orderId = metadata.orderId;
  if (!orderId) {
    functions.logger.warn("Snippe webhook has no data.metadata.orderId - ignoring", {
      type: event.type,
      dataKeys: event.data ? Object.keys(event.data) : null,
      metadata,
    });
    // Not tied to one of our orders (or an unrecognized event) - ack so it isn't retried.
    res.status(200).send("ignored");
    return;
  }

  const orderRef = db.collection("orders").doc(orderId);

  try {
    if (event.type === "payment.completed") {
      await fulfillOrder(db, orderRef, event);
    } else if (TERMINAL_FAILURE_EVENTS.includes(event.type)) {
      await orderRef.update({
        status: event.type.split(".")[1],
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
    res.status(200).send("ok");
  } catch (err) {
    functions.logger.error("Snippe webhook processing failed", {
      orderId,
      eventType: event.type,
      error: err.message,
    });
    // 5xx so Snippe retries with backoff - this is a transient/internal failure, not a bad request.
    res.status(500).send("processing error");
  }
});
