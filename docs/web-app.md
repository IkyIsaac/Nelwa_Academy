# Nelwa Academy website (`webapp/`)

The learner website that replaces the old nelwasacademy.com landing page.
It runs on the **same Firebase project** as the mobile app, so accounts,
courses, purchases and progress are shared between phone and web. The
goal is full feature parity with the mobile learner app. The instructor
studio comes later.

This doc records the decisions, how the code is organised and where each
phase stands. For running the app day to day, see `webapp/README.md`.

## Decisions

| Topic | Decision |
|---|---|
| Domain | Replaces nelwasacademy.com; hosted on Netlify or Vercel (to be chosen at launch) |
| Visitors | The catalog (explore, search, categories, course pages, reviews, instructor pages) is public, so courses can be shared and indexed. Lessons, learning and purchase need an account |
| Instructors | Instructor studio is a later phase (6). Instructors use the mobile app until then |
| Paid video URLs | Lesson video links are readable by any signed-in user (a Firestore limitation of the current data model). Signed URLs were discussed and deferred ("not now") |
| Design | Layout from the nelwasacademy.com template; colours and type from the brand guidelines: Deep Earth Red `#5d0a0b`, brand red `#9d1c20`, Montserrat everywhere |
| Languages | English, Kiswahili, French, matching the mobile app, chosen by a cookie |
| Commits | Small, one concern each, on the `web-app` branch |

## Stack

Next.js 16 (App Router), React 19, TypeScript, Tailwind CSS v4, shadcn/ui
on Base UI, TanStack Query, React Hook Form + Zod, Zustand, nuqs (filter
state in the URL), next-intl, Motion and React `<ViewTransition>`, and the
Firebase JS SDK.

> Next.js 16 has breaking changes from older versions (`params` are
> Promises, `middleware` is `proxy`, ...). `webapp/AGENTS.md` says to read
> `node_modules/next/dist/docs/` before using an unfamiliar API.

## How the code is organised

```
webapp/src/
  app/(site)/          public + signed-in pages with the site header/footer
  app/(auth)/          sign-in, sign-up, password reset, email actions
  app/(onboarding)/    profile + interests after sign-up
  components/          ui/ (shadcn), layout/, motion/, shared pieces
  features/<area>/     api.ts → hooks.ts → components/, types.ts converters
  config/site.ts       contact details and every route path
  lib/firebase/        client + safe field readers (fields.ts)
messages/              en.json (source), sw.json, fr.json
```

Rules the code follows:

- **Firestore field names** are snake_case from FlutterFlow and may be
  missing on old documents. Only `features/*/types.ts` reads raw fields;
  everything else uses camelCase types with safe defaults.
- **Data** goes `api.ts` (Firestore calls) → `hooks.ts` (TanStack Query)
  → components. Queries wait for Firebase Auth to restore the session, so
  nothing is fetched twice. `permission-denied` is never retried.
- **Catalog** loads every published course once
  (`where is_published == true`). Search, filters, sorting and shelves run
  in the browser; with a catalog this size, that's faster than many
  queries.
- **Routes** come from `routes` in `config/site.ts`, never hard-coded.
- **Redirects** after sign-in only allow local paths (`safeNext`).

## Phases

| # | Phase | Status |
|---|---|---|
| 0 | Scaffold, design system, translations | Done |
| 1 | Landing, about, contact, consult; auth; onboarding | Done |
| 2 | Catalog: explore, search, categories, tags, groups, course page, reviews, instructor, signed-in home | Done |
| 3 | Checkout with Snippe ([checkout-web.md](checkout-web.md)) | Built and deployed; awaiting a live 500 TZS test |
| 4 | Learning: My courses, player, progress, reviews, refund requests ([learning-web.md](learning-web.md)) | Built; awaiting a signed-in test |
| 5 | Account: profile, security, notifications, purchases, reviews, following, wishlist, support chat, consultation booking, help/terms/privacy ([account-web.md](account-web.md)) | Built; consultation email function not deployed; legal drafts need review |
| 6 | Instructor studio | Later |
| 7 | Polish, SEO, performance, launch | Planned |

### Phase 0: foundation

- Design tokens in `src/app/globals.css` (`bg-maroon`, `text-cream`, ...).
- shadcn components restyled for the brand.
- `pnpm i18n:sync` fills Swahili and French from the mobile app's existing
  translations where the English matches, and lists what's left.
  `scripts/same-in-all-languages.json` lists keys that are allowed to stay
  identical (brand names, numbers).

### Phase 1: public pages, accounts and onboarding

- Landing, About, Contact and Consult pages, rebuilt from the template.
- The contact form writes `contact_messages`. The
  `emailOnContactMessage` Cloud Function emails each message to the
  academy inbox through the Resend outbox.
- Sign in / sign up with email or Google, password reset, and email
  action links.
- Onboarding (name, country, phone, avatar, then interests) writes the
  same user fields as the mobile app, so either app can finish what the
  other started.

### Phase 2: catalog

| Page | Route | Notes |
|---|---|---|
| Explore | `/explore` | Categories, the three shelves, all courses with filters |
| Search | `/search?q=` | Accent-insensitive, matches title, description, tags, category, instructor; trending chips from `options` |
| Categories | `/categories`, `/categories/[name]` | |
| Tag, group lists | `/tags/[tag]`, `/groups/[group]` | "See all" from a shelf |
| Course | `/courses/[id]` | Preview video, monthly/yearly plan, lessons (signed-in), instructor, reviews, tags; metadata for link previews is rendered on the server |
| Reviews | `/courses/[id]/reviews` | Rating summary, helpful votes |
| Instructor | `/instructors/[id]` | Stats, follow, their courses |
| Home | `/home` (signed in) | Greeting, continue watching, shelves, ad banner |

Matches the mobile app: same filter buckets (rating, duration, price,
language), Swahili titles when the site is in Swahili, the same shelves
("New Courses", "We Recommend", most popular), follow/unfollow, and
like/dislike on reviews. The wishlist is stored in the browser, as on
mobile (where it's stored on the device).

To make the public catalog possible, published courses, reviews,
instructor stats and `options` were made readable without signing in.
See [firestore-security-rules.md](firestore-security-rules.md).

## Changes outside `webapp/` made during this work

| Change | Doc |
|---|---|
| Firestore rules: public catalog, then a full lockdown | [firestore-security-rules.md](firestore-security-rules.md) |
| Rules test suite in `firebase/rules-tests/` | [firestore-security-rules.md](firestore-security-rules.md#testing) |
| Mobile Purchase History showed every user's purchases | [firestore-security-rules.md](firestore-security-rules.md#why-the-rules-were-rewritten) |
| Course duration shown as minutes when it's seconds (mobile, admin, web) | [duration-units.md](duration-units.md) |
| `emailOnContactMessage` Cloud Function: queues each contact message to the academy inbox (reply-to = sender) | Code in `firebase/functions/email/triggers.js` |

All of this was deployed to production on 2026-11-17 (rules and functions).
The mobile code changes need a new app release to reach users.
