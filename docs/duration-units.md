# Course and lesson durations are in seconds

Both duration fields in Firestore store **seconds**:

| Field | Example | Shown as |
|---|---|---|
| `courses/{id}.total_duration` | `583` | "10 minutes" (mobile), "10 min" (web) |
| `courses/{id}/lessons/{id}.duration` | `245` | "4:05" |

## What was wrong

Lesson `duration` was always written and shown as seconds. Course
`total_duration` was also **written** as seconds, but every screen
**formatted** it as minutes. A course of 583 seconds (about 10 minutes)
therefore showed as "9 hours and 43 minutes". The admin portal had the
opposite problem: its lesson editor labelled `duration` as "minutes" and
the lesson list printed "245 min".

The duration filters were also written in minutes ("under 1 hour" meant
`0–60`), so filtering compared seconds against minute thresholds and put
almost every course in the wrong bucket.

Fixed on 2026-11-17 (`7b1fa98`, `690d220`, `edbdc53`). **No data was
changed**: the stored numbers were already right. Only the display and the
filters were wrong.

## Where durations are handled

### Mobile app (Flutter)

- `lib/flutter_flow/custom_functions.dart`
  - `totalDuration(int courseSeconds)`: rounds to minutes, then
    "2 hours and 1 minute".
  - `lessonDuration(int seconds)`: unchanged.
- Duration filter buckets, all in seconds:

  | Bucket | Range (seconds) |
  |---|---|
  | Under 1 h | 0 – 3,600 |
  | 1–3 h | 3,600 – 10,800 |
  | 3–10 h | 10,800 – 36,000 |
  | Any (default) | 0 – 360,000 |

  These live in `lib/home/components/filter/filter_widget.dart` (values
  and the "selected" checks), the default filter in `lib/app_state.dart`,
  and the reset values in the `courses_by_*` and `instructor_courses`
  screens.
- Create-course screen: the field is now labelled "Total duration
  (seconds)" in English, Swahili and French
  (`lib/flutter_flow/internationalization.dart`, keys `luh4t121` and
  `xhb7y55e`).

> FlutterFlow note: these are edits to generated code. If the project is
> re-exported from FlutterFlow, make the same changes there (custom
> function `totalDuration`, the filter component's values and the field
> label), or they will be overwritten.

### Admin portal

- `lib/admin/courses/lesson_editor_dialog.dart`: field labelled
  "Duration (seconds)".
- `lib/admin/courses/lessons_section.dart`: shows `m:ss` / `h:mm:ss`.

### Website

- `webapp/src/features/catalog/types.ts`: `Course.totalSeconds` (was
  `totalMinutes`); `Lesson.seconds`.
- `webapp/src/features/catalog/format.ts`: `formatCourseLength(seconds)`
  gives "45 min" or "3 h 20 min"; `formatSeconds(seconds)` gives "4:05".
- `webapp/src/features/catalog/filters.ts`: the same buckets as mobile,
  in seconds.

## Rules for new code

- Store durations as whole **seconds**. Never store minutes.
- Name variables after the unit (`totalSeconds`, `durationSeconds`) so the
  unit can't be mistaken.
- Any form that asks for a duration must say "seconds", or accept
  `mm:ss` and convert it.

## Possible follow-up

`total_duration` is typed by the instructor and can drift from the real
total. It could be computed instead, as the sum of the course's lesson
`duration`s, by a Cloud Function on lesson write, or by the admin portal
when it saves a lesson.
