# Nelwa Academy docs

Reference notes for maintaining the mobile app, admin portal, website and
Firebase backend. They cover how things work and why, not how to use the
apps.

| Doc | What it covers |
|---|---|
| [web-app.md](web-app.md) | The Next.js website in `webapp/`: decisions, code layout, phase status |
| [checkout-web.md](checkout-web.md) | Buying a course on the website with Snippe (Phase 3) |
| [learning-web.md](learning-web.md) | My courses, the player, progress, reviews and refund requests (Phase 4) |
| [account-web.md](account-web.md) | Account pages, notifications, support chat, consultations, help and legal (Phase 5) |
| [pipeline.md](pipeline.md) | Decided features still to build: admin support inbox, activity statistics |
| [snippe-integration.md](snippe-integration.md) | Snippe mobile-money payments: Cloud Functions, webhook, mobile checkout |
| [firestore-security-rules.md](firestore-security-rules.md) | Who can read and write each collection, why, and how to change the rules safely |
| [duration-units.md](duration-units.md) | Course and lesson durations are stored in seconds |

## Project facts

- **Firebase project:** `nelwasacademy-7uw9xf`. Cloud Functions in
  `firebase/functions/` (Gen-1, `us-central1`).
- **Apps:** Flutter mobile app and admin portal (`lib/`, admin under
  `lib/admin/`), website in `webapp/`. All three share one Firestore.
- **Deploy rules / functions** (from `firebase/`):
  `firebase deploy --only firestore:rules --project nelwasacademy-7uw9xf`
  and `--only functions`.
