/// Interim admin gate for Pass 1.
///
/// There is no Firebase Auth custom claim or hardened Firestore rule for
/// admin access yet (tracked separately as Phase 0). Until that lands, the
/// admin app itself is gated by this single allow-listed email. This does
/// not reduce current security: under the existing Firestore rules, any
/// authenticated user already has full read/write access to every
/// collection. This check only keeps the admin UI from appearing for a
/// non-admin who happens to open the admin URL.
const String kAdminEmail = 'isaackitomari33@gmail.com';
