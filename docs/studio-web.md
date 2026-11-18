# Instructor studio on the website (Phase 6)

Approved instructors run their teaching from `/studio`: courses, lessons,
sales, payouts, followers and consultation requests. It reads and writes
the same Firestore data as the mobile app's instructor mode, so a course
made on the web shows up on the phone and the other way round.

## Who can use it

Only accounts with `users.instructor == true`, the flag the admin portal
sets when it approves an instructor application. Anyone else who opens
`/studio` sees "The studio is for approved instructors" with a link to
support. Applications are switched off in the app for now, so the admin
grants access directly.

The mobile app also has a **role switch** (`users.role`: Learner /
Instructor) that changes its tabs. The website doesn't need it: approved
instructors get an **Instructor studio** link in the account hub
("Teaching") and in the user menu, and keep all learner pages.

## Pages

| Route | What it does |
|---|---|
| `/studio` | **Overview**: balance, total sales, students, followers, average rating; sales per month (last 6); recent sales; top courses |
| `/studio/courses` | Every course the instructor owns (drafts too): status, price, lessons, length, students, rating; publish switch, view, edit |
| `/studio/courses/new` | Create a course (saved as a draft) |
| `/studio/courses/[id]` | Lessons, course details, publish switch, delete |
| `/studio/sales` | Balance, sales table, payouts and their status |
| `/studio/followers` | Learners who follow the instructor |
| `/studio/consultations` | Consultation bookings, with call / WhatsApp / email links |

Code: `webapp/src/features/studio/`, routes in `webapp/src/app/(site)/studio/`.

## Courses

### Fields

These are the same fields the mobile "Create new course" screen writes,
plus the Swahili fields the admin portal already supports:

| Form | Firestore (`courses/{id}`) |
|---|---|
| Title / description | `title`, `description` |
| Swahili title / description (optional) | `title_sw`, `description_sw` |
| Category (from `options.categories`) | `category` |
| Language taught in | `language: {language, lang_code, flag}` (mobile's list: English, Swahili, Français, Italiano) |
| Home page shelf | `group`: `New Courses` or `We Recommend` |
| Cover image (required) | `image` |
| Preview video (optional) | `video_preview` |
| Price (TZS) | `price` (0 = free; paid courses at least 500, Snippe's minimum) |
| Yearly price (optional) | `year_price`, shown "coming soon" (see [checkout-web.md](checkout-web.md)) |
| Tags, audience | `tags`, `audience` (suggestions from `options`, tags can be new) |

When a course is created, the studio also sets `instructor_ref`,
`instructor_name`, `published_date`, `courses_id` (the course's own
reference, as mobile does), and zero values for counts, rating and
discount. It adds the course and category to the instructor's
`instructor_details` (`courses`, `categories`), like mobile.

### Differences from mobile (on purpose)

| Topic | Mobile | Web |
|---|---|---|
| New course | Published immediately, often with no lessons | Saved as a **draft** (`is_published: false`); the Published switch turns on once it has a lesson |
| Lesson count, total length | Typed in by hand | **Calculated** from the lessons after every add, edit or delete (`total_lessons`, `total_duration` in seconds) |
| Lesson length | Typed in (and often wrong: minutes vs seconds) | **Read from the video file** when it's uploaded |
| Editing a course or lesson | Not possible | Edit everything; reorder lessons; delete lessons |
| Deleting a course | Not possible | Only while **nobody has bought it**. A sold course can only be unpublished |

Unpublishing hides a course from the catalog. Learners who bought it keep
access: the rules let any signed-in user read a course document, and My
Courses and the player work as before.

### Lessons

The fields are `title`, `title_sw`, `description`, `description_sw`,
`video_url`, `image` (thumbnail), `duration` (seconds), `is_free` and
`order`. Reordering renumbers `order` from 1 to n. Adding a lesson adds 1
to `instructor_details.lessons`, and deleting one subtracts 1, as mobile
does on add.

### Uploads

Files go to the instructor's own Storage folder,
`users/{uid}/uploads/{course|lesson|preview}_{time}.{ext}`. This is the
same place the mobile app uploads to, so **no Storage rules change was
needed**.

- Images are resized in the browser (max 1600 px).
- Videos upload with a progress bar and can be cancelled. The page warns
  to stay open until the upload finishes.
- Limits are checked in the browser: images 10 MB, videos 1 GB. The
  Storage rules for `users/{uid}/` don't limit size or type.
- Replacing or deleting media leaves the old file in Storage. It's
  harmless but uses space; a cleanup job could remove unused uploads
  later.

## Money

- **Balance and sales** come from `users/{uid}/payment_account` (the
  first document, the same one the server picks). The payment webhook
  credits `balance` and appends to `sales_reports` when an order is paid.
- **Payouts** are listed from `payouts` where `instructorUserId` = the
  instructor. The admin sends them from the portal (`createPayout`) by
  mobile money to the **phone number on the instructor's profile**. The
  Sales page shows that number and links to Personal info to change it.
- The mobile **Payment Setup** screen (bank account / PayPal) wasn't
  ported: payouts don't use those details. See the fixed bugs below.

### Security fix (written, not deployed)

The deployed rules let an instructor **edit their own `payment_account`,
including `balance`**. `createPayout` only checks that the amount
requested is no more than that balance, so an inflated balance could
mislead a payout.

Commit `46e0763` changes `firestore.rules` so the owner:
- can create a payout account only with `balance` 0 and no
  `sales_reports`;
- can never change `balance` or `sales_reports`.

The admin and the Cloud Functions still can. The mobile setup screen
creates accounts with `balance: 0`, so it keeps working. A test was added
to `rules-tests/`, and the rules compile (dry run). **Deploy with:**

```
cd firebase && firebase deploy --only firestore:rules
```

### Mobile bugs found and fixed

- **Payment Setup created a new `payment_account` every time it was
  submitted**, so sales could be credited to any one of several docs and
  the balance could end up split. It also stored `currency: "USD"` while
  every sale is in TZS. Now (`payment_setup_widget.dart`,
  `savePayoutDetails`) it updates the first account, the same one the
  payment webhook and `createPayout` use (`limit(1)`), and creates one only
  if none exists. It changes only the payout details (switching between
  bank and PayPal clears the other type's fields), never `balance` or
  `sales_reports`, and sets the currency to TZS.
  - **Existing data isn't fixed by this.** Instructors who submitted the
    form more than once already have extra docs. These need a one-off
    merge (sum the balances and sales into the first doc, delete the
    rest), which hasn't been run.
- **The admin portal's lesson editor didn't update the course totals.**
  It now recalculates `total_lessons` and `total_duration` (seconds) from
  the lessons after every save or delete (`recountCourseTotals` in
  `lib/admin/courses/lesson_editor_dialog.dart`), as the studio does.
  Courses edited before this keep their old totals until a lesson is next
  saved.

### Still open

- **Analytics** is mostly a mock-up: "Top downloading countries" (Germany,
  Portugal, Russia), weekly visits and the sales chart are hard-coded.
  Only the balance is real. The web overview shows real figures instead.
  Real statistics are in the [pipeline](pipeline.md#2-activity-statistics).

## Testing

- Typecheck, lint and production build pass; all 7 studio routes
  compile.
- Logged out, `/studio/...` redirects to sign-in and back.
- Nothing was written to production.

Still to check with an approved instructor account:

1. A non-instructor sees the "approved instructors" message.
2. Create a draft course with a cover. It isn't in the catalog.
3. Add two lessons with videos. Lengths fill in, and the course's lesson
   count and length match.
4. Reorder and edit a lesson; publish. It appears in the catalog and in
   the mobile app.
5. Unpublish; delete the draft. Then confirm a sold course can't be
   deleted.
6. Sales, payouts, followers and consultations list correctly.
