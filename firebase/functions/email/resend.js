const axios = require("axios").default;

const RESEND_URL = "https://api.resend.com/emails";

function config() {
  return {
    apiKey: process.env.RESEND_API_KEY,
    from: process.env.EMAIL_FROM || "Nelwa Academy <hello@nelwasacademy.com>",
    replyTo: process.env.EMAIL_REPLY_TO || undefined,
  };
}

/**
 * Sends one email through Resend. `idempotencyKey` makes Resend drop a
 * repeat of the same send (for 24h), so a retried function can't double-send.
 *
 * Throws an error with `retryable: true` for rate limits, 5xx responses and
 * network failures; any other error is permanent (bad address, bad payload).
 */
async function sendEmail({ to, subject, html, text, idempotencyKey, tags }) {
  const { apiKey, from, replyTo } = config();
  try {
    const response = await axios.post(
      RESEND_URL,
      { from, to: [to], subject, html, text, reply_to: replyTo, tags },
      {
        headers: {
          "Authorization": `Bearer ${apiKey}`,
          "Idempotency-Key": idempotencyKey,
        },
        timeout: 15000,
      }
    );
    return response.data && response.data.id;
  } catch (err) {
    const status = err.response && err.response.status;
    const error = new Error(
      err.response ? JSON.stringify(err.response.data) : err.message
    );
    error.retryable = !status || status === 429 || status >= 500;
    throw error;
  }
}

module.exports = { sendEmail, isConfigured: () => !!config().apiKey };
