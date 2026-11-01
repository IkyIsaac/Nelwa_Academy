const BRAND = "#5D0A0B";
const INK = "#242424";
const MUTED = "#6B6B6B";
const HAIRLINE = "#E8E4E0";

const FOOTER = {
  en: "You're receiving this email because you have an account on Nelwa Academy.",
  sw: "Unapokea barua pepe hii kwa sababu una akaunti kwenye Nelwa Academy.",
};

function escapeHtml(value) {
  return String(value == null ? "" : value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

/**
 * Renders a template's content blocks into the shared branded layout.
 * Every string in `content` is plain text and is escaped here, so templates
 * can pass user-supplied names and course titles straight through.
 *
 * content: { subject, preheader?, heading, paragraphs[], rows?[[label, value]],
 *            cta?{label, url}, footnote? }
 */
function render(content, language) {
  const { subject, preheader, heading, paragraphs = [], rows, cta, footnote } = content;

  const paragraphHtml = paragraphs
    .map((p) => `<p style="margin:0 0 16px;font-size:15px;line-height:1.6;color:${INK};">${escapeHtml(p)}</p>`)
    .join("");

  const rowsHtml = rows && rows.length
    ? `<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="margin:8px 0 24px;border-top:1px solid ${HAIRLINE};">${rows
      .map(([label, value]) => `<tr>
          <td style="padding:10px 0;border-bottom:1px solid ${HAIRLINE};font-size:14px;color:${MUTED};">${escapeHtml(label)}</td>
          <td align="right" style="padding:10px 0;border-bottom:1px solid ${HAIRLINE};font-size:14px;color:${INK};font-weight:600;">${escapeHtml(value)}</td>
        </tr>`)
      .join("")}</table>`
    : "";

  const ctaHtml = cta
    ? `<table role="presentation" cellpadding="0" cellspacing="0" style="margin:8px 0 24px;"><tr><td style="border-radius:6px;background:${BRAND};">
        <a href="${escapeHtml(cta.url)}" style="display:inline-block;padding:12px 24px;font-size:15px;font-weight:600;color:#FFFFFF;text-decoration:none;">${escapeHtml(cta.label)}</a>
      </td></tr></table>`
    : "";

  const footnoteHtml = footnote
    ? `<p style="margin:0;font-size:13px;line-height:1.5;color:${MUTED};">${escapeHtml(footnote)}</p>`
    : "";

  const html = `<!doctype html>
<html lang="${language}">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>${escapeHtml(subject)}</title></head>
<body style="margin:0;padding:0;background:#F6F3F0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;">
<span style="display:none;max-height:0;overflow:hidden;opacity:0;">${escapeHtml(preheader || "")}</span>
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#F6F3F0;padding:24px 12px;">
<tr><td align="center">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:560px;">
    <tr><td style="padding:8px 4px 16px;font-size:18px;font-weight:700;letter-spacing:0.5px;color:${BRAND};">NELWA ACADEMY</td></tr>
    <tr><td style="background:#FFFFFF;border-radius:10px;border:1px solid ${HAIRLINE};padding:32px 28px;">
      <h1 style="margin:0 0 20px;font-size:22px;line-height:1.3;color:${INK};">${escapeHtml(heading)}</h1>
      ${paragraphHtml}${rowsHtml}${ctaHtml}${footnoteHtml}
    </td></tr>
    <tr><td style="padding:16px 4px;font-size:12px;line-height:1.5;color:${MUTED};">${escapeHtml(FOOTER[language])}</td></tr>
  </table>
</td></tr>
</table>
</body>
</html>`;

  const text = [
    heading,
    "",
    ...paragraphs.flatMap((p) => [p, ""]),
    ...(rows || []).map(([label, value]) => `${label}: ${value}`),
    rows && rows.length ? "" : null,
    cta ? `${cta.label}: ${cta.url}` : null,
    cta ? "" : null,
    footnote || null,
    "",
    "--",
    FOOTER[language],
  ].filter((line) => line !== null).join("\n");

  return { subject, html, text };
}

module.exports = { render };
