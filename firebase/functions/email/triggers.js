const functions = require("firebase-functions");
const { notifyUser, queueEmail } = require("./outbox");

// Where website contact-form messages are delivered.
const ACADEMY_INBOX = "nelwasacademy@nelwasgelato.com";

/** Welcome email, once per account, when the app creates the users doc. */
exports.emailOnUserCreated = functions.firestore
  .document("users/{uid}")
  .onCreate(async (snap, context) => {
    await notifyUser({
      userRef: snap.ref,
      id: `welcome_${context.params.uid}`,
      template: "welcome",
    });
  });

const STATUS_TEMPLATES = {
  pending: "instructor_application_received",
  approved: "instructor_approved",
  rejected: "instructor_rejected",
  revoked: "instructor_revoked",
};

/**
 * Instructor application emails. The app sets instructor_status to
 * `pending` on apply; the admin portal sets approved/rejected/revoked.
 * Keyed on the event id: a status can legitimately repeat (reject, reapply,
 * approve), but a retried delivery of the same event must not.
 */
exports.emailOnInstructorStatusChanged = functions.firestore
  .document("users/{uid}")
  .onUpdate(async (change, context) => {
    const before = change.before.get("instructor_status");
    const after = change.after.get("instructor_status");
    if (before === after || !STATUS_TEMPLATES[after]) return;

    await notifyUser({
      userRef: change.after.ref,
      id: `instructor_${after}_${context.params.uid}_${context.eventId}`,
      template: STATUS_TEMPLATES[after],
    });
  });

/** Forwards a website contact-form message to the academy inbox. */
exports.emailOnContactMessage = functions.firestore
  .document("contact_messages/{id}")
  .onCreate(async (snap, context) => {
    const { name, email, topic, message } = snap.data();
    try {
      await queueEmail({
        id: `contact_${context.params.id}`,
        to: ACADEMY_INBOX,
        template: "contact_message",
        data: { name, email, topic: topic || "", message },
        replyTo: email,
      });
    } catch (err) {
      functions.logger.error("Failed to queue contact message email", { id: context.params.id, error: err.message });
    }
  });
