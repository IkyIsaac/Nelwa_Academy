# Account, support and help on the website (Phase 5)

Everything under the Profile tab, plus notifications, support chat,
consultation booking and the help/legal pages. As with earlier phases,
each screen reads and writes the same Firestore fields as the mobile app.

## Pages

| Route | What it does | Data |
|---|---|---|
| `/account` | Profile header and menu: Learning, Account, Help & info; sign out | `users/{uid}` (live) |
| `/account/personal-info` | Photo, name, about, specialty, phone, date of birth, country, education. Email is read-only | `users/{uid}` fields as mobile; also updates the Firebase Auth name/photo |
| `/account/security` | Change password (email accounts); delete account | Firebase Auth |
| `/account/language` | English / Kiswahili / Français | `NEXT_LOCALE` cookie |
| `/account/wishlist` | Saved courses | Browser storage (as on mobile, where it's on the device) |
| `/account/purchases` | Receipts: course, date, method, amount, Paid/Refunded | `users/{uid}/purchase_history` |
| `/account/reviews` | Courses waiting for a review (with the review dialog), then posted reviews | `purchased_courses.reviwed`, `users/{uid}/user_reviews` |
| `/account/subscriptions` | Instructors the learner follows | `users.subscriptions` → instructor profiles |
| `/account/support` | Chat with the academy, with image attachments | `support/{id}` + `support_message` (live) |
| `/notifications` | New followers, reviews of your courses; mark read | `users/{uid}/notification` (live) |
| `/consult` | Consultation booking form (also for visitors) | `consultation` |
| `/help` | FAQ and contact channels | Messages files |
| `/terms`, `/privacy` | Draft legal text | `features/help/legal.ts` |

All `/account/*` pages and `/notifications` need sign-in and are excluded
from search engines. The header bell shows a live unread count.

Code: `webapp/src/features/account/`, `webapp/src/features/help/`.

## Behaviour notes

### Security

- **Change password** asks for the current password: Firebase requires a
  recent sign-in, so the page re-authenticates first. Google-only accounts
  see a note instead.
- **Delete account** re-authenticates (password, or a Google popup), then
  deletes the Firebase Auth user. The existing `onUserDeleted` Cloud
  Function removes `users/{uid}`, the same as deleting from the app.
  Subcollections (purchases, history, reviews) are left behind, as
  before.
- The mobile Security screen's toggles (biometrics, Face ID, SMS and
  Google Authenticator, device management) aren't wired to anything in
  the app, so they weren't ported.

### Support chat

The first message creates `support/{auto}` with `user` = the learner,
stores the reference in `users.support`, then writes the message. The
order matters: the security rules check the thread's owner before
allowing messages in it. Images go to `users/{uid}/uploads/support_*.jpg`.
`user_message: true` marks learner messages; anything else is shown as
from the academy.

> ⚠️ **Nobody can currently reply from a proper tool.** The admin portal
> has no Support page; replies can only be written by hand in the Firebase
> console (`support/{id}/support_message`, `user_message: false`). This
> was already true for the mobile app. An admin Support inbox is the
> obvious next admin feature.

### Notifications

Listed newest first and grouped Today / Earlier. Opening one marks it
read, and "Mark all as read" updates every unread one in a batch. Types
come from mobile: `subscribed` (new follower) and `comment` (new review
of the instructor's course).

The mobile Notification Settings screen only toggles switches that
nothing reads, so it wasn't ported.

### Consultation booking

- Same fields as the mobile form (`display_name`, `email`,
  `phone_number`, `selected_department`, `reason_for_visit`,
  `appointment_time`, `uid`, timestamps). The department is stored with
  the same strings as mobile (including its spellings, e.g.
  `"Nelway's Consultaion"`), so the instructor app's list stays
  consistent. The web shows friendlier labels.
- Visitors can book (`uid` is empty). Signed-in learners get their name,
  phone and email filled in.
- The day picker starts tomorrow. The academy confirms the exact time and
  fee.
- The mobile form's copy came from a healthcare template ("describe your
  symptoms", "bring medical documents"). The web copy is written for the
  academy; the mobile text should be fixed in FlutterFlow too.

**New Cloud Function `emailOnConsultationBooked`** (commit `198d3c4`):
on every new `consultation` doc, from web or app, it emails the academy
inbox with the details, with reply-to set to the person's email when one
is valid. Before this, bookings sat in Firestore with no alert. **Not
deployed yet.**

### Help, Terms, Privacy

- FAQ answers are written for how the platform works today (mobile money
  via Snippe, web/app sync, refund requests, no offline on web) and are
  translated.
- The mobile app's Terms page is empty, and its Privacy page is template
  text for another product ("SkillBase"). The website has
  **plain-language drafts** in `features/help/legal.ts`. They describe
  the real data flows: Firebase, Snippe, Resend, the web host, the
  language cookie, wishlist storage, public reviews, and deletion. They
  are **English only**, with a note on other languages.
- ⚠️ **The academy must review these before launch**, ideally with
  legal advice, especially access duration, refunds, governing law and
  the reference to Tanzania's Personal Data Protection Act.

## Not ported (and why)

| Mobile screen | Reason |
|---|---|
| Activity Statistics | Shows hard-coded numbers ("10 hours"); nothing is tracked |
| Analytics, Sales reports | Instructor features, Phase 6 |
| Dark Mode | The website follows the brand's light theme |
| Notification Settings, Security toggles | Not connected to anything in the app |
| My payment methods | Stored raw card numbers; Snippe replaced it (see [snippe-integration.md](snippe-integration.md)) |

## Testing

- Typecheck, lint and production build pass; all 14 routes compile.
- Checked logged out in the browser: the consultation form renders,
  jumps to `#book` from the hero, and validates. Help and Privacy render.
  `/account/*` redirects to sign-in and back.
- Nothing was submitted to production.

Still to check with a signed-in account:

1. Edit personal info, then check it shows in the mobile app.
2. Change password, then sign in with the new one.
3. Send a support message with an image, reply from the Firebase console,
   and confirm it appears live.
4. Follow an instructor from another account, and check the notification
   and unread badge.
5. After deploying functions, book a consultation and confirm the email
   arrives.
6. Delete a test account and confirm `users/{uid}` is removed.
