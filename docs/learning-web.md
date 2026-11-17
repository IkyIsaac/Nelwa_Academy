# Learning on the website (Phase 4)

My Courses, the course player, progress, reviews and refund requests on
the website. Everything reads and writes the same Firestore fields as the
mobile app, so progress, reviews and requests carry over between phone
and web.

## Pages

| Route | What it does |
|---|---|
| `/learn` | **My courses**: everything bought, plus free courses the learner started. Filter by All / In progress / Completed; progress bar and "Continue" on each |
| `/learn/[id]?lesson=` | **Player**: video, lesson title, duration and description, previous/next, auto-advance at the end of a video. Sidebar with progress and every lesson (done ✓, locked 🔒, free badge). Review and refund actions for bought courses |
| `/learn/[id]/refund` | **Refund request**: reason (same five as mobile), optional screenshot (≤ 5 MB, resized), optional comment. Shows the request's status if one already exists |

All three need sign-in. If a visitor opens a lesson link, they're sent to
sign-in and returned to the same lesson (`RequireAuth` now keeps the query
string). After paying, the checkout's "Start learning" opens the player.

Code: `webapp/src/features/learning/`

## Who can watch what

`useCourseAccess(course)` decides, and the course page and player both use
it:

| Learner | Can watch |
|---|---|
| Has a `purchased_courses` entry for the course, or is in its `downloaders` | Every lesson |
| Is the course's instructor | Every lesson (not tracked as progress) |
| Course price is 0 | Every lesson |
| Anyone signed in | Lessons marked `is_free` |

Other lessons show a locked panel with "Unlock the course", which goes to
checkout. The `purchased_courses` check matters because people who bought
before Snippe aren't always in `downloaders`.

> Lesson video URLs are readable by any signed-in user (Firestore rules
> can't hide one field). Hiding the player is a convenience, not
> protection. Signed URLs were deferred; see [web-app.md](web-app.md).

## Progress

Opening a lesson counts as watching it, the same as mobile. Two fields are
updated:

| Field | Written how | Used by |
|---|---|---|
| `users/{uid}/purchased_courses/{id}.watched_lessons` | `arrayUnion(lessonRef)` (bought courses only) | Mobile "Overall progress", web My courses |
| `users/{uid}.continue_watching` `[{courses, completed_lessons}]` | Transaction: the course's entry is updated and moved to the end | "Continue watching" on Home (both apps), web My courses for free courses |

Mobile adds and removes whole struct entries. The web uses a transaction
instead, so two tabs can't create duplicate entries. Each lesson is
recorded once per page visit and skipped if it's already recorded.

Percentages use the number of lessons the course has **now**, not the
count stored when it was bought, so adding lessons doesn't push anyone
over 100%.

## Reviews

"Rate this course" appears in the player for bought courses until the
learner reviews. One transaction writes:

1. `courses/{id}/courses_review/{new}`: name, photo, rating, comment, date
   (same shape as mobile).
2. `users/{uid}/user_reviews/{new}`: the learner's own copy.
3. `courses/{id}`: `rating` (true running mean) and `reviews_count + 1`.
   The security rules allow exactly this change; see
   [firestore-security-rules.md](firestore-security-rules.md).
4. `purchased_courses/{id}.reviwed = true`.

Then, best-effort, a `comment` notification goes to the instructor. A
star rating is required; the comment is optional, as on mobile.

**Mobile rating bug fixed** (`e7f1cda`): mobile computed
`(new + oldAverage) / (count + 1)`, which drags every course toward zero.
For example, after ten 4-star reviews and one 5-star, the course showed
about 0.8. It now uses the running mean. Ratings already stored that
way stay wrong until recomputed. A one-off script, or a Cloud Function
that recalculates from `courses_review`, would fix them.

## Refund requests

The web saves one document and moves no money:

```
requesta_refund/{new}
  amount, coureses_ref, user_ref, reason, comment, screenshot_url,
  status: "pending", created_at
```

- `reason` stores the same English text as mobile, so the admin portal's
  Refunds page groups them the same way. The page shows the reason in the
  learner's language.
- `comment` is new. Mobile asked for comments but never saved them. The
  admin Refunds page doesn't show it yet.
- Screenshots go to `users/{uid}/uploads/refund_*.jpg`, the same Storage
  location as mobile uploads.
- Only bought, paid courses can be refunded. One request per course: if
  one exists, the page shows its status instead of the form.

**Mobile refund screen fixed** (`0089563`): after saving, it tried to
debit the instructor's balance and write refund history from the phone.
The new rules refuse that, so the screen stayed open and learners could
submit duplicates. Now it just saves the request and closes. Balances
should change only when the admin approves a refund, ideally in a Cloud
Function.

## Not ported

| Mobile feature | Why |
|---|---|
| Lesson reminders (`learn/reminder`) | Uses phone notifications. A web version would need push or email reminders |
| "Delete course" from My courses | Deletes the learner's own purchase. The new rules block client deletes of `purchased_courses`, so **this now fails on mobile too**. Decide whether to allow it (owner-only) or remove the button from the app |
| Downloads / offline | Not possible for streamed video in a browser |

## Testing

- Typecheck, lint and production build pass; `/learn`, `/learn/[id]` and
  `/learn/[id]/refund` compile.
- Logged out, the player and refund pages redirect to sign-in with the
  lesson kept.
- The course page still loads for visitors (access checks don't run until
  sign-in).
- Mobile: `flutter analyze` is clean on the refund and review screens.

Still to check with a signed-in learner who owns a course:

1. Open a lesson. It plays, and the purchase's `watched_lessons` plus
   `continue_watching` update. The same progress shows on Home and in the
   mobile app.
2. Post a review. The course average and count change correctly, and the
   instructor gets a notification.
3. Send a refund request with a screenshot. It appears in the admin
   portal's Refunds page.
