# Snippe payment integration

How course purchases are paid for, how the pieces fit together, and how this
was built and verified with a real 500 TZS transaction. Written after the
integration was live and tested, as a reference for maintaining it.

## Why this exists

Before this integration, tapping "Pay" on a course did nothing more than
write `purchased_courses` / `purchase_history` directly from the Flutter
client and increment the instructor's balance — no payment gateway was
involved at all. Anyone could grant themselves a free course by tapping the
button, or by writing to Firestore directly (the security rules allowed it).

We integrated [Snippe](https://docs.snippe.sh/), a Tanzania-focused mobile
money payment API (Airtel Money, M-Pesa, Mixx by Yas, Halotel), to replace
that with real payments. Snippe:

- Only settles in **TZS**, minimum **500 TZS** per transaction.
- Has no sandbox/test mode — every test call is a real transaction.
- Has no Flutter SDK, so all calls go through our own Cloud Functions
  backend (this is also the correct shape regardless: amount authority for
  a mobile-money gateway must live server-side, never on the client).

## Architecture

```
Flutter app                Cloud Functions               Snippe
────────────               ────────────────               ──────
tap "Pay"
  ──createOrder (callable)─►  read course price from
                               Firestore (never the client's)
                               create orders/{id} = pending
                               POST /api/v1/sessions ────────► create session
                               ◄──── {data:{checkout_url}} ────
  ◄── {orderId, checkoutUrl}──
open checkout_url
(external browser)
                                                            user pays via
                                                            mobile money USSD
                                                            ◄── webhook ──────
listen to orders/{id}       verify HMAC signature
via Firestore snapshot      (X-Webhook-Signature,
                             X-Webhook-Timestamp)
                             if still pending: write
                             purchased_courses,
                             purchase_history,
                             instructor balance,
                             mark order completed
  ◄── status: completed ───
show success screen
```

The client never declares a purchase successful — only
`snippeWebhook`, acting on a signature-verified Snippe event, can grant a
course entitlement.

## What was built

### Backend — `firebase/functions/payments.js`

- **`createOrder`** (HTTPS callable, auth required): looks up each course's
  price and instructor directly from Firestore, rejects courses already
  purchased or priced under 500 TZS, snapshots everything fulfillment will
  need (course ref, price, the instructor's `payment_account` and
  `instructor_details` doc refs) into a new `orders/{id}` document, then
  calls Snippe's `POST /api/v1/sessions` and returns `{orderId, checkoutUrl}`
  to the client.
- **`snippeWebhook`** (public HTTPS endpoint): verifies
  `X-Webhook-Signature` / `X-Webhook-Timestamp` via HMAC-SHA256 with a
  constant-time comparison and a 5-minute freshness window. On
  `payment.completed`, runs a Firestore transaction that's a no-op if the
  order is already `completed` (so retried/duplicate webhooks are safe),
  and otherwise writes `purchased_courses`, `purchase_history`, credits the
  instructor's `payment_account.balance`, and adds the student to the
  course/instructor rosters. `payment.failed` / `.voided` / `.expired` just
  mark the order accordingly.
- Secrets (`SNIPPE_API_KEY`, `SNIPPE_WEBHOOK_SECRET`, `SNIPPE_WEBHOOK_URL`)
  come from a gitignored `.env` in `firebase/functions/` — see
  `.env.example` for what's required. `SNIPPE_WEBHOOK_URL` is the deployed
  URL of `snippeWebhook` itself; Gen-1 functions with no explicit region
  default to `us-central1`, so it's predictable ahead of the first deploy:
  `https://us-central1-<project-id>.cloudfunctions.net/snippeWebhook`.

### Firestore rules — `firebase/firestore.rules`

- New `orders/{id}`: readable only by its owner (so the app can watch
  payment status via a snapshot listener), writable by no one client-side.
- `users/{uid}/purchased_courses/{id}`: `create` is now blocked entirely —
  only `snippeWebhook`'s Admin SDK access can grant a course. `update` is
  still allowed, since students legitimately update `watched_lessons` and
  `reviwed` on their own existing purchases from elsewhere in the app.
- **Deliberately not touched**: `purchase_history` and `payment_account`
  still allow broad client writes, because the refund flow
  (`lib/learn/requesta_refund/requesta_refund_widget.dart`) and instructor
  payout setup (`lib/payment_method/payment_setup/payment_setup_widget.dart`)
  depend on writing there client-side. The refund flow has the *same* kind
  of trust problem the old purchase flow had (self-declared refund,
  self-adjusted balance) — that's a known follow-up, not yet fixed.

### Flutter client

- Added the `cloud_functions` dependency (`pubspec.yaml`).
- Three screens call `createOrder` and open the Snippe checkout, then listen
  to `orders/{id}` for completion:
  - `lib/courses/payment_method/payment_method_widget.dart` — the original
    rewire target.
  - `lib/courses/checkout/checkout_widget.dart`
  - `lib/courses/checkout_copy/checkout_copy_widget.dart` — a FlutterFlow
    duplicate of the above that turned out to be the screen actually
    reachable from course browsing (`CoursesPageCopyCopyWidget` → "Enroll
    Now" → this). **All three needed the same fix independently** — none of
    them share the checkout logic, it's duplicated per FlutterFlow's
    generated-code style.
- All three previously routed to `PaymentMethodWidget` for the user to
  select/add a saved payment method first. That step was removed entirely:
  Snippe's hosted checkout page collects the phone number itself, so there
  was nothing left for the app to ask about. The "My Payment Methods"
  profile screens still exist and still link to `PaymentMethodWidget`, but
  are now vestigial under a Snippe-only setup — not removed, just no longer
  part of the purchase path.
- `checkout_copy_widget.dart`'s "yearly" package option has no server-side
  pricing support (`createOrder` only reads `course.price`, not
  `course.year_price`), so selecting it shows a "not available yet" message
  instead of silently charging the wrong amount.

## One-time environment setup

### Service account (for non-interactive deploys)

`firebase login` needs a real interactive browser session, which isn't
available in every environment (e.g. a headless sandbox). The alternative:

1. Firebase console → Project Settings → Service Accounts → **Generate new
   private key**. This downloads a JSON key for
   `firebase-adminsdk-fbsvc@<project-id>.iam.gserviceaccount.com`.
2. Save it somewhere outside the repo (e.g. `~/.firebase-keys/`), and
   `chmod 600` it. Never commit it.
3. `GOOGLE_APPLICATION_CREDENTIALS=<path> firebase deploy ...` — firebase-tools
   picks it up automatically, no `--token` needed.

That default key only has *runtime* permissions (Firestore/Auth access from
inside a function), not *deploy* permissions. Deploying Cloud Functions
needs these additional IAM roles granted (Google Cloud Console → IAM) to
**two different principals**:

| Principal | Roles needed | Why |
|---|---|---|
| `firebase-adminsdk-fbsvc@<project-id>.iam.gserviceaccount.com` | Editor | Broad deploy/manage access — covers Cloud Functions, Firestore rules, and log reading in one grant, rather than chasing individual missing permissions (`cloudfunctions.functions.list`, `cloudfunctions.operations.get`, `logging.logEntries.list`, ... each showed up as a separate error) |
| `<project-number>-compute@developer.gserviceaccount.com` (the default Compute Engine service account — hidden by default in the IAM console unless you check **"Include Google-provided role grants"**) | Editor | This is who Cloud Build actually runs as when building a function's container. Without it: `Build failed: Access to bucket gcf-sources-... denied` and (once that's fixed) build logs silently fail to write, which is why the CLI reports "Build error details not available" with no further information |

IAM changes can take a minute or two to propagate — a failed deploy right
after granting a role usually just needs a retry.

### Reading real build failures

When `firebase deploy` reports "Build error details not available," the
Cloud Build API has the actual failure even when the CLI doesn't show it:

```js
const { GoogleAuth } = require("google-auth-library"); // already a
                                                          // transitive dep
                                                          // via firebase-admin
const auth = new GoogleAuth({ scopes: ["https://www.googleapis.com/auth/cloud-platform"] });
const token = (await (await auth.getClient()).getAccessToken()).token;
const res = await fetch(
  `https://cloudbuild.googleapis.com/v1/projects/<project-number>/locations/us-central1/builds/${buildId}`,
  { headers: { Authorization: `Bearer ${token}` } }
);
```

(The build ID is in the `Build failed:` line's log URL.) The `v1/projects/...`
path without `locations/...` 404s — Cloud Functions Gen-1 builds are
regional and need the `locations/us-central1` segment.

`firebase functions:log` also turned out to be unreliable during testing —
repeated calls returned different, sometimes stale, windows of the same
logs. Querying `https://logging.googleapis.com/v2/entries:list` directly
(same `GoogleAuth` token, filter on `resource.type="cloud_function"` and
`resource.labels.function_name`) was consistently accurate and is the more
trustworthy option when debugging live.

## Real bugs found during testing (and fixed)

1. **`checkout_url` parsing.** Snippe wraps its actual session data in an
   envelope: `{code, status, data: {checkout_url, reference, ...}}`.
   `createOrder` was reading `response.data.checkout_url` when it needed
   `response.data.data.checkout_url`. This surfaced as "Snippe response did
   not include a checkout_url" on every attempt, with the order created
   but stuck unable to proceed — only visible by logging the full raw
   response body and comparing it against what the code expected.
2. **Duplicate checkout screens.** See "Flutter client" above —
   `CheckoutCopyWidget`, not `CheckoutWidget`, is the one actually reachable
   from the app's course browsing flow. Fixing only `CheckoutWidget` first
   left the real path unpatched.

## Known follow-ups (not yet done)

- **`launchUrl(..., mode: LaunchMode.externalApplication)` gets silently
  popup-blocked on web.** The `await` on the `createOrder` call before it
  breaks the browser's "user gesture" chain that popup blockers require, so
  Chrome blocks the new tab with no visible error. This blocked the actual
  live test too — the checkout URL had to be opened manually. Needs a fix
  (e.g. opening a placeholder tab synchronously on tap and navigating it
  once the URL is known, or an in-page redirect) before this works
  end-to-end for a real user on web.
- **Refund flow has the old trust problem.** `requesta_refund_widget.dart`
  still self-declares refunds and adjusts instructor balances client-side,
  same as the pre-Snippe purchase flow did. Not addressed here.
- **No confirmed Snippe refund API.** The public docs cover Payments,
  Sessions, Disbursements, and Webhooks — no refund/void endpoint. Would
  need checking the dashboard/Postman collection, or falling back to a
  manual disbursement, before wiring up the admin portal's Refunds page.
- **Yearly/subscription pricing** (`course.year_price`) has no server-side
  support — `checkout_copy_widget.dart` blocks that path with a message
  rather than mischarging.
- **`GoError: There is nothing to pop`** on the back button in
  `checkout_copy_widget.dart` — a pre-existing GoRouter navigation quirk,
  unrelated to payments, found while debugging why a test attempt never
  reached the server (the user had tapped back instead of "Pay").
- Deploys currently warn about Node.js 20 (deprecated 2026-04-30,
  decommissioned 2026-10-30) and an outdated `firebase-functions` SDK
  (4.9.0, breaking changes on upgrade) — not urgent yet, but will need
  addressing before the runtime is retired.

## Testing again

There's no sandbox — any live test is a real transaction, minimum 500 TZS.
A disposable "Sample Test Course" (id `xfKmn8wCruUPh0smXyY4` at the time of
writing) exists for this: priced at exactly 500 TZS, reusing a real
instructor's existing images/video and Firestore setup (so
`payment_account` / `instructor_details` resolve correctly), with lesson
titles marked "Sample" for visibility. Delete it (and its `lessons`
subcollection) via the Firebase console or Admin SDK once no longer needed.
