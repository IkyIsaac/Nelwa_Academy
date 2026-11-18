# Firestore security rules

How `firebase/firestore.rules` protects the data shared by the mobile app,
the admin portal and the website. It covers what changed in November 2026,
who can read and write each collection, which app flows depend on each
rule, and how to change the rules safely.

- **Deployed:** 2026-11-17, to project `nelwasacademy-7uw9xf`.
- **Commits:** `4e3c7ea` (public catalog) and `af9b20c` (lockdown), plus
  `7cd9fad` (mobile Purchase History fix).

## Why the rules were rewritten

The earlier rules were written for "any signed-in user can do almost
anything". Anyone could create a free account and then use the Firebase
SDK (or the browser console on the website) to:

| Problem | Impact |
|---|---|
| Write any course, including price and `is_published`, or delete it | Free courses, vandalism, deleted catalog |
| Write any lesson | Swap video links on paid lessons |
| Read every user profile | Every learner's email, phone number and birthday |
| Read and write `payment_method` | Saved card numbers **and CVCs** |
| Read and write `payment_account` | Instructors' bank account numbers; edit balances |
| Read `purchase_history`, `purchased_courses`, `notification`, `support`, `user_reviews`, `requesta_refund` | Everyone's private activity |
| Read `consultation` **without signing in** | Names, emails and phones of everyone who booked, public on the internet |
| Create `ads` without signing in | Spam banners on the home screen |
| Edit `options` | Rename categories and tags for everyone |

Two Firestore behaviours made it worse than the rules looked:

1. **Rules are OR-ed.** One broad `allow write: if request.auth != null`
   also allows create *and* delete, whatever stricter `allow create: if
   false` sits next to it.
2. **Collection-group rules also cover normal reads.** A rule like
   `match /{path=**}/payment_method/{doc} { allow read: if signedIn() }`
   lets anyone read `users/<someone else>/payment_method/<id>`. Several of
   these existed for FlutterFlow's collection-group queries.

A third problem was in the mobile app itself: the Purchase History screen
queried `purchase_history` **without** `parent: currentUserReference`.
That makes it a collection-group query across every user, so each learner
was actually being shown everyone's purchases.

## Who is who

| Helper | Meaning |
|---|---|
| `signedIn()` | Any Firebase Auth user, learner or instructor |
| `isAdmin()` | The single super-admin account (email check). The admin portal only lets this account in, and it is the only account that can edit any course |
| `isOwner(uid)` | The signed-in user is `users/{uid}` |
| `myRef()` | Reference to the signed-in user's own doc, for comparing with reference fields such as `instructor_ref`, `user_ref` and `user` |
| `isInstructor()` | The caller's user doc has `instructor == true` (set by the admin) or the older `role == 'Instructor'` |
| `onlyChanges([...])` | An update touches only the listed fields |

Cloud Functions use the Admin SDK and **bypass the rules entirely**. Payment
fulfilment (`snippeWebhook`), payouts, emails and account deletion are not
affected by anything here.

## Access by collection

"Public" means readable without signing in.

### Users

| Path | Read | Create | Update | Delete |
|---|---|---|---|---|
| `users/{uid}` | Owner, admin; any signed-in user for **instructor** profiles; an instructor for the profiles of learners who follow them | Owner (can't make themselves an instructor), admin | Owner (can't set `instructor`; can only move `instructor_status` to `pending`; can only switch `role` to Instructor once approved), admin | Nobody (`onUserDeleted` cleans up) |
| `.../payment_account` | Owner, admin | Owner, admin | Owner, admin | Admin |
| `.../payment_method` | Owner, admin | Owner | Owner | Owner |
| `.../purchase_history` | Owner, admin | Owner, admin | Admin | Admin |
| `.../purchased_courses` | Owner, admin | **Nobody**, only `snippeWebhook` | Owner, except `courses_ref` (progress, `reviwed`) | Nobody |
| `.../instructor_details` | **Public** | Owner, admin | Owner, admin; any signed-in user may change only `followers` | Admin |
| `.../notification` | Owner, admin | Any signed-in user | Owner, admin | Owner, admin |
| `.../user_reviews` | Owner, admin | Owner, admin | Owner, admin | Admin |

### Courses

| Path | Read | Create | Update | Delete |
|---|---|---|---|---|
| `courses/{id}` | **Public** if `is_published == true`; drafts to signed-in users | Admin; an instructor creating a course with `instructor_ref` = themselves | Admin; the course's own instructor (can't reassign it); any signed-in user changing only `preview_views`; any signed-in user changing only `rating` + `reviews_count` with the count going up by exactly 1 and rating within 0–5 | Admin, the course's instructor |
| `.../lessons` | Signed-in users | Admin, course's instructor | Admin, course's instructor | Admin, course's instructor |
| `.../courses_review` | **Public** | Signed-in users | Admin; others may change only `liked` / `disliked` | Admin |
| `.../review_report`, `lesson_report`, `courses_report` | Admin | Signed-in users | Admin | Admin |

Lessons stay sign-in only because they hold the video URLs. The website
asks visitors to sign up to see the lesson list.

### App content

| Path | Read | Write |
|---|---|---|
| `options/{id}` | **Public** | Admin; instructors may update only `tags` and `categories` (creating a course can add new ones) |
| `ads/{id}` | Signed-in users | Admin |

### Support, refunds, consultations

| Path | Read | Create | Update | Delete |
|---|---|---|---|---|
| `support/{id}` | Admin, the learner in `user` | A learner, with `user` = themselves | Admin, that learner | Admin |
| `.../support_message` | Admin, the thread's learner | Admin, the thread's learner | Admin, the thread's learner | Admin |
| `requesta_refund/{id}` | Admin, the learner in `user_ref` | A learner, with `user_ref` = themselves | Admin | Admin |
| `consultation/{id}` | Admin, instructors, the person who booked (`uid`) | Anyone, including visitors | Nobody | Nobody |

### Server-managed

| Path | Read | Write |
|---|---|---|
| `orders/{id}` | The buyer (`userId`), admin | Cloud Functions only |
| `payouts/{id}` | The instructor (`instructorUserId`), admin | Cloud Functions only |
| `contact_messages/{id}` | Admin | Anyone may create one; shape and length are validated |
| `mail/{id}` | Admin | Cloud Functions only |

### Collection-group rules

Every `{path=**}` rule is now admin-only, except these three, which are
deliberately at least as open as the per-collection rule:

- `lessons`: signed-in users
- `instructor_details`: public
- `courses_review`: public

The admin portal's collection-group queries (all purchases, all reports and
so on) run as the admin, so they keep working.

## Flows that were checked against the rules

These are the client writes the mobile app, admin portal and website make
today, traced through the code. Each was confirmed to still pass:

| Flow | Where | Write |
|---|---|---|
| Sign up | mobile, web | Create own `users/{uid}` as a Learner |
| Edit profile, choose interests | mobile, web | Update own user doc |
| Follow / unfollow | mobile, web | `instructor_details.followers` + own `subscriptions` |
| Preview a course video | mobile, web | `courses.preview_views` |
| Write a review | mobile | Create `courses_review`; bump `rating` + `reviews_count` on the course; mark own `purchased_courses.reviwed` |
| Like / dislike a review | mobile, web | `courses_review.liked` / `disliked` |
| Notify an instructor | mobile | Create in `users/{instructor}/notification` |
| Report a course, lesson or review | mobile | Create in the `*_report` subcollection |
| Create, edit, delete own course | mobile (instructor) | `courses` with `instructor_ref` = self; `lessons`; `total_lessons`; own `instructor_details.lessons` |
| Add a new tag or category | mobile (instructor) | `options.tags` / `categories` |
| Instructor onboarding | mobile | Create own `instructor_details`; `instructor_status: pending` |
| Payout account setup | mobile (instructor) | Own `payment_account` |
| Support chat | mobile | `support` + `support_message` for own thread |
| Request a refund | mobile | Create `requesta_refund` with `user_ref` = self |
| Book a consultation | mobile, web | Create `consultation` |
| Contact form | web | Create `contact_messages` |
| Everything in the admin portal | admin | Signed in as the admin |

## Known trade-offs

1. **Refund bookkeeping moved off the phone.** After saving a refund
   request, the old mobile screen also edited the instructor's
   `payment_account` and wrote a `purchase_history` entry. The rules now
   refuse both: the first because `payment_account` holds bank details,
   the second because it was self-declared money movement. As a result,
   older app builds keep the refund screen open after the request saves.
   Fixed in the app (`0089563`): the screen now only saves the request.
   Refund money movement belongs in an admin-triggered Cloud Function.
2. **Purchase History in older app builds shows nothing.** The query fix
   (`7cd9fad`) only takes effect in a new release. Until then the old
   query asks for everyone's history, the rules refuse it, and the screen
   shows its empty state.
3. **Instructor profiles stay readable by signed-in users**, including
   email and phone if stored there, because course and instructor pages
   read them. Moving public instructor fields into `instructor_details`
   would allow closing this.
4. **Review rating updates aren't tied to a purchase.** Old purchases
   aren't always listed in `downloaders`, so the rule can't check it. The
   rule limits the damage instead: one review's worth of change (+1 count,
   rating 0–5) per write. A Cloud Function trigger on `courses_review`
   that recomputes the average would be the proper fix.
5. **Approved instructors can read all consultation bookings**, because the
   app's Consultation page (shown to instructors) lists them all. Tighten
   this once bookings are assigned to a specific instructor.
6. ~~**"Delete course" on mobile now fails.**~~ Resolved 2026-11-17: the
   academy chose archiving over deleting. Learners set
   `purchased_courses.archived`, which the existing owner-update rule
   already allows. Deletes stay blocked. See
   [learning-web.md](learning-web.md#archiving-courses).
7. **The admin is a single hard-coded email.** Adding a second admin means
   editing `isAdmin()` and redeploying. Custom claims would be better
   long-term.
8. **Instructors could edit their own payout `balance`** (found
   2026-11-18). The owner-update rule on `payment_account` allowed every
   field, and `createPayout` trusts `balance` as the limit. Fixed in
   commit `46e0763` (the owner can't set or change `balance` or
   `sales_reports`). **Not deployed yet.** See
   [studio-web.md](studio-web.md#security-fix-written-not-deployed).

## Testing

`firebase/rules-tests/rules.test.mjs` holds 24 tests built with
`@firebase/rules-unit-testing`. They cover every flow in the table above
and every leak in the first table. They run against the local Firestore
emulator, so production is never touched.

**They haven't been run yet.** The emulator needs Java 21 and the machine
these rules were written on had Java 17. To run them:

```bash
brew install openjdk@21
export JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
cd firebase/rules-tests
npm install
npm test
```

Add a test for every new rule, and run the suite before every rules deploy.

## Changing the rules

1. Edit `firebase/firestore.rules`. Keep `create`, `update` and `delete`
   separate and never add a broad `allow write`.
2. Any new `{path=**}` rule must be no looser than the per-collection rule.
3. Check compilation without releasing:
   `firebase deploy --only firestore:rules --dry-run --project nelwasacademy-7uw9xf`
4. Deploy: `firebase deploy --only firestore:rules --project nelwasacademy-7uw9xf`
   (run from `firebase/`).
5. **Roll back:** Firebase console → Firestore → Rules → history → pick the
   previous version → Publish. It takes effect within about a minute.

If a mobile screen starts failing with `permission-denied` after a rules
change, the Flutter debug console prints the exact path. Check that path
against the tables above.
