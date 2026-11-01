const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { render } = require("./layout");
const { templates, inAppTemplates } = require("./templates");
const resend = require("./resend");

const MAIL_COLLECTION = "mail";
// Retries stop after this long, so a send that keeps failing doesn't retry
// for the full 7 days Cloud Functions allows.
const MAX_RETRY_AGE_MS = 60 * 60 * 1000;
const ALREADY_EXISTS = 6;

// Same interim single-admin gate as payouts.js / translations.js.
const ADMIN_EMAIL = "isaackitomari33@gmail.com";

function languageOf(user) {
  return user.language === "sw" ? "sw" : "en";
}

/**
 * Tells a user about an event: an in-app notification (users/{uid}/notification,
 * shown by the app's bell and notifications screen) when the template has
 * in-app copy, plus an email queued in `mail/{id}` for sendQueuedEmail.
 *
 * `id` must be deterministic for the event (e.g. `receipt_<orderId>`): both
 * docs are created with that id, so a retried webhook or trigger is a no-op.
 *
 * Users without an email address still get the in-app notification; the
 * email is skipped quietly. Never throws: notifying is a side effect and
 * must not fail the caller.
 */
async function notifyUser({ userRef, id, template, data = {} }) {
  try {
    if (!templates[template]) throw new Error(`Unknown email template "${template}"`);

    const db = admin.firestore();
    const ref = typeof userRef === "string" ? db.collection("users").doc(userRef) : userRef;
    const userSnap = await ref.get();
    const user = userSnap.exists ? userSnap.data() : {};
    const language = languageOf(user);
    const fullData = { name: user.display_name || "", ...data };

    if (inAppTemplates[template] && userSnap.exists) {
      const { type, title, description } = inAppTemplates[template](fullData, language);
      await createOnce(ref.collection("notification").doc(id), {
        type,
        title,
        description,
        time_stamp: admin.firestore.FieldValue.serverTimestamp(),
        seen: false,
      });
    }

    const to = (user.email || "").trim();
    if (!to) {
      functions.logger.info("Email skipped: user has no email address", { id, template, userId: ref.id });
      return;
    }

    await createOnce(db.collection(MAIL_COLLECTION).doc(id), {
      template,
      to,
      language,
      data: fullData,
      userId: ref.id,
      status: "queued",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (err) {
    functions.logger.error("Failed to notify user", { id, template, error: err.message });
  }
}

async function createOnce(docRef, data) {
  try {
    await docRef.create(data);
  } catch (err) {
    if (err.code !== ALREADY_EXISTS) throw err;
  }
}

/**
 * Renders and sends one outbox doc, recording the outcome on it.
 * Returns the error (with `.retryable`) on a failed send, null otherwise.
 */
async function deliver(ref, idempotencyKey) {
  const mail = (await ref.get()).data();
  if (!mail) return null;

  if (!resend.isConfigured()) {
    functions.logger.warn("RESEND_API_KEY not set; email not sent", { id: ref.id });
    await ref.update({ status: "skipped", error: "RESEND_API_KEY not configured" });
    return null;
  }

  let rendered;
  try {
    rendered = render(templates[mail.template](mail.data || {}, mail.language), mail.language);
  } catch (err) {
    functions.logger.error("Email render failed", { id: ref.id, template: mail.template, error: err.message });
    await ref.update({ status: "failed", error: `render: ${err.message}` });
    return err;
  }

  try {
    const resendId = await resend.sendEmail({
      to: mail.to,
      ...rendered,
      idempotencyKey,
      tags: [{ name: "template", value: mail.template }],
    });
    await ref.update({
      status: "sent",
      resendId: resendId || null,
      subject: rendered.subject,
      sentAt: admin.firestore.FieldValue.serverTimestamp(),
      error: admin.firestore.FieldValue.delete(),
    });
    return null;
  } catch (err) {
    await ref.update({
      status: "failed",
      subject: rendered.subject,
      error: err.message,
      attempts: admin.firestore.FieldValue.increment(1),
    });
    return err;
  }
}

/**
 * Sends each queued email through Resend. Retries (failurePolicy) on rate
 * limits, Resend 5xx and network errors; Resend's idempotency key (the
 * outbox doc id) keeps a retry from sending twice.
 */
const sendQueuedEmail = functions
  .runWith({ failurePolicy: true })
  .firestore.document(`${MAIL_COLLECTION}/{id}`)
  .onCreate(async (snap, context) => {
    const current = (await snap.ref.get()).data();
    if (!current || current.status === "sent") return;

    const err = await deliver(snap.ref, snap.ref.id);
    if (!err) return;

    const age = Date.now() - Date.parse(context.timestamp);
    const willRetry = err.retryable && age < MAX_RETRY_AGE_MS;
    functions.logger.error("Email send failed", { id: snap.ref.id, willRetry, error: err.message });
    if (willRetry) {
      await snap.ref.update({ status: "retrying" });
      throw err;
    }
  });

/**
 * Admin portal "Resend" button for a failed or skipped email. Uses a fresh
 * idempotency key per attempt so Resend doesn't drop it as a duplicate.
 */
const resendEmail = functions.https.onCall(async (data, context) => {
  if (!context.auth || context.auth.token.email !== ADMIN_EMAIL) {
    throw new functions.https.HttpsError("permission-denied", "Admin access required.");
  }
  const id = data && data.id;
  if (typeof id !== "string" || !id) {
    throw new functions.https.HttpsError("invalid-argument", "Missing email id.");
  }

  const ref = admin.firestore().collection(MAIL_COLLECTION).doc(id);
  const snap = await ref.get();
  if (!snap.exists) throw new functions.https.HttpsError("not-found", "Email not found.");
  if (snap.get("status") === "sent") {
    throw new functions.https.HttpsError("failed-precondition", "This email was already sent.");
  }

  if (!resend.isConfigured()) {
    throw new functions.https.HttpsError("failed-precondition", "RESEND_API_KEY is not configured.");
  }

  const err = await deliver(ref, `${id}_manual_${Date.now()}`);
  if (err) throw new functions.https.HttpsError("internal", `Send failed: ${err.message}`);
  return { status: "sent" };
});

module.exports = { notifyUser, sendQueuedEmail, resendEmail };
