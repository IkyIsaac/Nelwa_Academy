const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios").default;

// Same interim single-admin gate as payouts.js. Without it any signed-in
// app user could run up the project's Cloud Translation bill.
const ADMIN_EMAIL = "isaackitomari33@gmail.com";

const TRANSLATE_URL =
  "https://translation.googleapis.com/language/translate/v2";

/**
 * Machine-translates course/lesson text so the admin portal can prefill the
 * Swahili fields. The result is only a draft: the admin reviews and edits
 * it before saving, nothing is written to Firestore here.
 *
 * Needs the Cloud Translation API enabled on the Firebase project; it
 * authenticates with the functions' default service account.
 */
exports.translateText = functions.https.onCall(async (data, context) => {
  if (!context.auth || context.auth.token.email !== ADMIN_EMAIL) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Admin access required."
    );
  }

  const texts = data && data.texts;
  const target = (data && data.target) || "sw";
  if (
    !Array.isArray(texts) ||
    texts.length === 0 ||
    texts.length > 50 ||
    !texts.every((t) => typeof t === "string")
  ) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "texts must be a non-empty array of up to 50 strings."
    );
  }

  const { access_token: accessToken } = await admin
    .app()
    .options.credential.getAccessToken();

  try {
    const response = await axios.post(
      TRANSLATE_URL,
      { q: texts, source: "en", target, format: "text" },
      { headers: { Authorization: `Bearer ${accessToken}` } }
    );
    return {
      translations: response.data.data.translations.map(
        (t) => t.translatedText
      ),
    };
  } catch (e) {
    const message =
      (e.response && e.response.data && e.response.data.error &&
        e.response.data.error.message) ||
      e.message;
    console.error("translateText failed", message);
    throw new functions.https.HttpsError("internal", message);
  }
});
