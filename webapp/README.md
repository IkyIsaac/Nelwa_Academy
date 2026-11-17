# Nelwa Academy — web app

The learner website for Nelwa's Academy (nelwasacademy.com). It talks to the
**same Firebase project as the mobile app**, so accounts, courses, purchases
and progress are shared between web and phone.

## Run it

```bash
cd webapp
pnpm install
pnpm dev            # http://localhost:3000
```

Other scripts: `pnpm build`, `pnpm lint`, `pnpm typecheck`, `pnpm format`.

## Stack

| Concern            | Tool                                                   |
| ------------------ | ------------------------------------------------------ |
| Framework          | Next.js 16 (App Router) + React 19 + TypeScript        |
| Styling            | Tailwind CSS v4, shadcn/ui on Base UI                   |
| Data               | Firebase JS SDK (Auth, Firestore, Storage, Functions)  |
| Server state       | TanStack Query                                         |
| Forms              | React Hook Form + Zod                                  |
| Small client state | Zustand                                                |
| Translations       | next-intl (English, Kiswahili, Français)               |
| Animation          | Motion + React `<ViewTransition>`                      |

> Next.js 16 differs from older versions (e.g. `middleware` is now `proxy`).
> Check `node_modules/next/dist/docs/` before using an unfamiliar API.

## Where things live

```
src/
  app/                 routes (folders in brackets like (site) are groups, not URLs)
  components/
    ui/                shadcn building blocks (button, dialog, …), restyled for the brand
    layout/            header, footer, bottom tab bar, logo
    motion/            <Reveal>, <Stagger> scroll animations
  features/<feature>/  one folder per area of the app:
    api.ts             Firestore / Cloud Function calls
    hooks.ts           TanStack Query hooks that wrap api.ts
    types.ts           document types + converters from Firestore
    components/        UI used only by this feature
  config/site.ts       contact details and every route path
  i18n/                language detection and switching
  lib/firebase/        Firebase client + safe field readers
messages/              en.json (source) → sw.json, fr.json
scripts/               translation helpers
```

## Design

Colours, fonts and shapes come from the original landing page template:
maroon `#5D080B`, cream `#FFF8F0`, Montserrat headings, Poppins body text,
pill buttons. They are defined once as tokens in `src/app/globals.css` and
used through Tailwind classes such as `bg-maroon`, `text-cream`,
`bg-primary`.

## Translations

Write new text in `messages/en.json` with a readable key, then run:

```bash
pnpm i18n:sync
```

This fills `sw.json` and `fr.json` using the mobile app's existing
translations where the English matches, and lists anything still needing a
translator. `pnpm i18n:glossary` refreshes that list from the Flutter app.

## Firestore field names

The mobile app (FlutterFlow) stores fields in `snake_case` and may leave them
out on old documents. Each feature's `types.ts` converts a raw document into a
clean camelCase type with safe defaults, using helpers in
`src/lib/firebase/fields.ts`. Components never read raw Firestore data.
