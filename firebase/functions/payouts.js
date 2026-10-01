const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios").default;

const SNIPPE_BASE_URL = process.env.SNIPPE_BASE_URL || "https://api.snippe.sh";
const SNIPPE_API_KEY = process.env.SNIPPE_API_KEY;

// Same interim single-admin gate as lib/admin/admin_constants.dart
// (kAdminEmail) and the isAdmin() function in firestore.rules. Unlike
// those two, this one is load-bearing: it's the only thing stopping any
// signed-in app user from calling createPayout directly and draining an
// instructor's balance - the Flutter admin UI's email check is
// client-side only and enforces nothing on its own.
const ADMIN_EMAIL = "isaackitomari33@gmail.com";

function snippeClient() {
  return axios.create({
    baseURL: SNIPPE_BASE_URL,
    headers: { Authorization: `Bearer ${SNIPPE_API_KEY}` },
  });
}

/**
 * Sends a real mobile-money payout to an instructor via Snippe's
 * Disbursements API. Admin-only. Balance is read from Firestore here, never
 * trusted from the client, and is only actually decremented once the
 * webhook confirms payout.completed - not at request time - so a
 * failed/reversed payout never touches it.
 */
exports.createPayout = functions.https.onCall(async (data, context) => {
  if (!context.auth || context.auth.token.email !== ADMIN_EMAIL) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Admin access required."
    );
  }

  const instructorUserId = data && data.instructorUserId;
  const amount = Number(data && data.amount);
  if (!instructorUserId || !Number.isFinite(amount) || amount <= 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "instructorUserId and a positive amount are required."
    );
  }

  const db = admin.firestore();
  const instructorRef = db.collection("users").doc(instructorUserId);
  const [instructorSnap, paymentAccountSnap] = await Promise.all([
    instructorRef.get(),
    instructorRef.collection("payment_account").limit(1).get(),
  ]);

  if (!instructorSnap.exists) {
    throw new functions.https.HttpsError("not-found", "Instructor not found.");
  }
  if (paymentAccountSnap.empty) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Instructor has no payment account on file."
    );
  }

  const instructor = instructorSnap.data();
  const paymentAccountRef = paymentAccountSnap.docs[0].ref;
  const balance = Number(paymentAccountSnap.docs[0].data().balance) || 0;

  if (amount > balance) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      `Requested amount (${amount}) exceeds the instructor's balance (${balance}).`
    );
  }

  const phone = instructor.phone_number;
  if (!phone) {
    // v1 is mobile-money-only, matching how course payments already work.
    // Bank transfer (the account/bank_code/branch_code fields already on
    // payment_account) is a documented future extension, not built here.
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Instructor has no phone number on file for a mobile money payout."
    );
  }

  const payoutRef = db.collection("payouts").doc();
  await payoutRef.set({
    instructorUserId,
    instructorRef,
    paymentAccountRef,
    amount,
    currency: "TZS",
    status: "pending",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  try {
    // NOTE: these request body field names are inferred from Snippe's docs,
    // not confirmed against a real response - the same situation
    // createOrder's checkout_url was in before its first live test revealed
    // the real envelope shape. Expect to need at least one more iteration
    // here; the full response is logged below specifically for that.
    const response = await snippeClient().post(
      "/v1/payouts/send",
      {
        amount,
        currency: "TZS",
        channel: { type: "mobile_money" },
        recipient: {
          name: instructor.display_name || instructor.email || "Instructor",
          phone,
        },
        narration: "Nelwa Academy instructor payout",
        metadata: { payoutId: payoutRef.id, instructorUserId },
      },
      { headers: { "Idempotency-Key": payoutRef.id } }
    );

    functions.logger.info("Snippe payout response", {
      payoutId: payoutRef.id,
      status: response.status,
      body: response.data,
    });

    const payoutData = (response.data && response.data.data) || response.data || {};
    const reference = payoutData.reference || payoutData.id || null;

    await payoutRef.update({
      snippeReference: reference,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { payoutId: payoutRef.id, status: "pending" };
  } catch (err) {
    functions.logger.error("Snippe payout creation failed", {
      payoutId: payoutRef.id,
      error: err.response ? err.response.data : err.message,
    });
    await payoutRef.update({
      status: "failed",
      error: err.response ? JSON.stringify(err.response.data) : err.message,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    throw new functions.https.HttpsError(
      "internal",
      "Could not start the payout. Please try again."
    );
  }
});

const PAYOUT_EVENT_STATUS = {
  "payout.completed": "completed",
  "payout.failed": "failed",
  "payout.reversed": "reversed",
};

/**
 * Called from payments.js's snippeWebhook for any payout.* event - kept as
 * one webhook endpoint rather than two. Balance is decremented here, on
 * confirmed completion, never at createPayout request time.
 */
async function handlePayoutEvent(db, payoutRef, event) {
  const newStatus = PAYOUT_EVENT_STATUS[event.type];
  if (!newStatus) return;

  const handled = await db.runTransaction(async (tx) => {
    const payoutSnap = await tx.get(payoutRef);
    if (!payoutSnap.exists) return false;
    const payout = payoutSnap.data();
    if (payout.status !== "pending") return false;

    const now = admin.firestore.FieldValue.serverTimestamp();
    tx.update(payoutRef, {
      status: newStatus,
      updatedAt: now,
      completedAt: newStatus === "completed" ? now : null,
      snippeEventId: event.id || null,
    });

    if (newStatus === "completed" && payout.paymentAccountRef) {
      tx.update(payout.paymentAccountRef, {
        balance: admin.firestore.FieldValue.increment(-payout.amount),
      });
    }

    return true;
  });

  if (!handled) {
    functions.logger.info(
      "Payout webhook ignored (already handled or missing payout)",
      { payoutId: payoutRef.id, eventId: event.id }
    );
  }
}

exports.handlePayoutEvent = handlePayoutEvent;
