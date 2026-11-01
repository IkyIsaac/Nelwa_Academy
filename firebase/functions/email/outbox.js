const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { render } = require("./layout");
const { templates } = require("./templates");
const resend = require("./resend");

const MAIL_COLLECTION = "mail";
// Retries stop after this long, so a send that keeps failing doesn't retry
// for the full 7 days Cloud Functions allows.
const MAX_RETRY_AGE_MS = 60 * 60 * 1000;
const ALREADY_EXISTS = 6;

function languageOf(user) {
  return user.language === "sw" ? "sw" : "en";
}

/**
 * Queues one email to a user by writing `mail/{id}`. sendQueuedEmail picks
 * it up. `id` must be deterministic for the event (e.g. `receipt_<orderId>`):
 * a second queue with the same id is a no-op, which is what makes retried
 * webhooks and triggers safe.
 *
 * Users without an email address (e.g. phone sign-ups) are skipped quietly.
 * Never throws: email is a side effect and must not fail the caller.
 */
async function queueUserEmail({ userRef, id, template, data = {} }) {
  try {
    if (!templates[template]) throw new Error(`Unknown email template "${template}"`);

    const db = admin.firestore();
    const ref = typeof userRef === "string" ? db.collection("users").doc(userRef) : userRef;
    const userSnap = await ref.get();
    const user = userSnap.exists ? userSnap.data() : {};
    const to = (user.email || "").trim();
    if (!to) {
      functions.logger.info("Email skipped: user has no email address", { id, template, userId: ref.id });
      return;
    }

    await db.collection(MAIL_COLLECTION).doc(id).create({
      template,
      to,
      language: languageOf(user),
      data: { name: user.display_name || "", ...data },
      userId: ref.id,
      status: "queued",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (err) {
    if (err.code === ALREADY_EXISTS) return;
    functions.logger.error("Failed to queue email", { id, template, error: err.message });
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
    const ref = snap.ref;
    const fresh = await ref.get();
    const mail = fresh.data();
    if (!mail || mail.status === "sent") return;

    if (!resend.isConfigured()) {
      functions.logger.warn("RESEND_API_KEY not set; email not sent", { id: ref.id });
      await ref.update({ status: "skipped", error: "RESEND_API_KEY not configured" });
      return;
    }

    let rendered;
    try {
      rendered = render(templates[mail.template](mail.data || {}, mail.language), mail.language);
    } catch (err) {
      functions.logger.error("Email render failed", { id: ref.id, template: mail.template, error: err.message });
      await ref.update({ status: "failed", error: `render: ${err.message}` });
      return;
    }

    try {
      const resendId = await resend.sendEmail({
        to: mail.to,
        ...rendered,
        idempotencyKey: ref.id,
        tags: [{ name: "template", value: mail.template }],
      });
      await ref.update({
        status: "sent",
        resendId: resendId || null,
        subject: rendered.subject,
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
        error: admin.firestore.FieldValue.delete(),
      });
    } catch (err) {
      const age = Date.now() - Date.parse(context.timestamp);
      const willRetry = err.retryable && age < MAX_RETRY_AGE_MS;
      functions.logger.error("Email send failed", { id: ref.id, template: mail.template, willRetry, error: err.message });
      await ref.update({
        status: willRetry ? "retrying" : "failed",
        error: err.message,
        attempts: admin.firestore.FieldValue.increment(1),
      });
      if (willRetry) throw err;
    }
  });

module.exports = { queueUserEmail, sendQueuedEmail };
