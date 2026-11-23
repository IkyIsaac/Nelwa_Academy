# Pipeline: committed work not yet built

Features the academy has decided to build in full. Each entry gives what
exists today, what "done" means and the open questions. The web app's
phases are tracked separately in [web-app.md](web-app.md).

| # | Feature | Where | Status |
|---|---|---|---|
| 1 | [Admin support inbox](#1-admin-support-inbox) | Admin portal (+ Cloud Functions) | Planned (added 2026-11-17) |
| 2 | [Activity statistics](#2-activity-statistics) | Mobile app, web, Firestore | Planned (added 2026-11-17) |

---

## 1. Admin support inbox

### Today

- Learners chat with the academy from the mobile Support screen and the
  website (`/account/support`). See [account-web.md](account-web.md#support-chat).
- Data: one `support/{id}` per learner (`user` → their user doc, `start_date`).
  Messages are in `support/{id}/support_message`: `text`, `image`,
  `user_message` (true = learner), `time_stamp`.
- **The academy has no tool to read or answer these.** Replies can only be
  typed by hand in the Firebase console, and nobody is told when a
  message arrives.

### Done means

1. **Inbox page** (`/support` in the admin portal):
   - One row per thread: learner name, photo, last message preview and
     time, and an unread/"needs reply" marker.
   - Newest activity first. Search by learner name or email.
   - Filters: Needs reply, All, Closed.
2. **Thread view**:
   - The full conversation, live, with images.
   - The learner's details on the side: email, phone, courses owned, and
     recent orders, linked to the existing user page.
3. **Reply** with text and an optional image. Writes a `support_message`
   with `user_message: false`. It shows instantly in the app and on the
   web, because both already listen live.
4. **Thread state**:
   - `status` (`open` / `closed`) and `last_message_at`,
     `last_message_from`, `unread_by_admin` on `support/{id}`. These
     drive the inbox sort and badges without reading every message.
   - Close and reopen a thread. A learner's new message reopens it.
5. **Alerts**:
   - A Cloud Function on new learner messages updates the thread fields
     above and emails the academy inbox through the existing Resend
     outbox (`firebase/functions/email/`).
   - It sends at most one email per thread every 15 minutes.
6. **Learner notification of replies**:
   - A `notification` doc for the learner, so the web bell and the app
     notification list show it.
   - Optionally an email when the learner hasn't opened the chat within
     an hour.
7. **Nav badge**: the admin nav shows the count of threads needing a
   reply.
8. **Canned replies** (optional): a few saved answers, for example about
   payment problems and course access.

### Changes this needs

- **Firestore rules:**
  - The admin may create `support_message` with `user_message: false`.
    `isAdmin()` already allows this; check it when building.
  - Learners must not be able to write the new thread fields except
    through their own messages. Have the Cloud Function maintain them.
- **Indexes:** `support` ordered by `last_message_at`, with an optional
  `status` filter.
- **Backfill** for existing threads: a one-off script sets
  `last_message_at` and `status: open` from each thread's latest message.
- Web and mobile learners need no changes beyond reading reply
  notifications.

### Open questions

- Who answers: only the super-admin email, or more staff? This affects
  `isAdmin()`, which is currently a single email.
- Expected reply time to show learners, e.g. "We usually reply within a
  day".

---

## 2. Activity statistics

### Today

The mobile **Activity Statistics** screen
(`lib/profile/activity_statistics/`) shows hard-coded
numbers such as "10 hours". Nothing records learning time, so it was not
ported to the web.

### Done means

Learners see real numbers on mobile and web:

| Statistic | Definition |
|---|---|
| Time learned | Seconds of lesson video actually played, per day / week / all time |
| Lessons completed | Lessons watched to at least 90% (not just opened) |
| Courses completed | Bought courses with every lesson completed |
| Streak | Consecutive days with at least 5 minutes of learning |
| This week chart | Minutes learned per day, last 7 days |
| Per-course progress | Completed lessons / total, time spent per course |

### Recording (both apps)

- **While a lesson plays**, send heartbeats about every 30 seconds of
  playing time, plus one on pause, end or leaving the page:
  - Only playing time counts: paused, buffering and background tabs are
    excluded.
  - Each heartbeat adds the seconds since the previous one, capped at the
    interval.
- **Storage**, kept small:
  - `users/{uid}/activity_days/{yyyy-mm-dd}`: `seconds`,
    `lessons_completed`, `courses: {courseId: seconds}`.
  - Each heartbeat is one `increment()` write.
  - `users/{uid}/lesson_progress/{lessonId}`: `position_seconds`,
    `watched_seconds`, `completed`, `updated_at`. This also lets both
    apps **resume a lesson where the learner stopped**.
  - Totals on the user doc (`stats.total_seconds`,
    `stats.lessons_completed`, `stats.current_streak`,
    `stats.longest_streak`, `stats.last_active_day`) are kept by a
    Cloud Function on `activity_days` writes. Clients can't inflate them.
- **"Completed"** moves from "opened" to "watched 90%". The existing
  `watched_lessons` and `continue_watching` fields keep working for
  progress bars; decide whether they switch to the new rule (recommended)
  or stay as "opened".

### Screens

- **Mobile:** rebuild Activity Statistics on the real data (summary
  tiles, 7-day chart, streak, per-course list), keeping the current
  layout where it fits.
- **Web:** a new `/account/activity` page and a small summary on the
  account hub.
- **Instructor and admin (later):** total watch time per course and
  per-lesson drop-off, built from the same data.

### Changes this needs

- **Firestore rules:**
  - The owner may only `increment` their own `activity_days` and
    `lesson_progress`, with bounded per-write deltas (≤ 60 s).
  - `stats` is server-only.
- **Cloud Function** for totals and streaks, plus a daily job to reset
  broken streaks.
- **Timezone:** days are counted in East Africa Time (UTC+3) for
  everyone, unless the academy wants per-learner time zones.

### Open questions

- Should reaching 90% count as completed, and should the existing
  progress bars switch to it?
- Show statistics to learners only, or also to instructors per course?
