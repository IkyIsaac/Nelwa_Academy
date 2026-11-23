# Launching the website (Phase 7)

Phase 7 makes the web app ready to go live at nelwasacademy.com. This page
lists what was done in code, what was checked, and the steps that only the
academy can take (hosting, domain, Firebase console, real-account tests).

## Done in code

| Area | What | Where |
|---|---|---|
| Error pages | Branded 404 (unknown URLs and missing courses) with the normal header and footer; a "Try again" screen when a page crashes; a plain English/Swahili fallback if the whole layout fails | `src/app/not-found.tsx`, `src/app/(site)/error.tsx`, `src/app/global-error.tsx` |
| Search engines | `robots.txt` lets crawlers into the public site and keeps them out of pages that need an account. `sitemap.xml` lists the public pages, categories and every published course with its reviews, refreshed hourly | `src/app/robots.ts`, `src/app/sitemap.ts` |
| Site address | One setting, `NEXT_PUBLIC_SITE_URL` (default `https://nelwasacademy.com`), used by the sitemap, robots and share links | `src/config/site.ts` |
| Icons | The academy mark replaces Next.js's default favicon; home-screen icons for iPhone and Android | `src/app/favicon.ico`, `icon.png`, `apple-icon.png`, `public/icons/` |
| Install | Web manifest: name, colour and icons for "Add to home screen" | `src/app/manifest.ts` |
| Link previews | Default share image (logo beside the classroom photo) for pages without their own; course pages still use the course cover | `src/app/opengraph-image.jpg` |
| Security headers | No framing by other sites, no MIME sniffing, shorter referrer, camera/microphone/location off, HTTPS remembered for two years, no `X-Powered-By` | `next.config.ts` |
| Accessibility | "Skip to content" as the first Tab stop on every page; every page has a `main` landmark. A scan found no images without alt text and no unlabelled icon buttons | `src/app/layout.tsx` |
| Speed | Firebase Storage and Functions load only on pages that upload or pay; the landing page's contact form loads when it scrolls into view | `src/lib/firebase/`, `contact-form-lazy.tsx` |

### Page weight

Compressed JavaScript per page, measured on the production build:

| Page | Before | After |
|---|---|---|
| Landing `/` | 732 KB | 618 KB |
| Explore | 633 KB | 622 KB |
| Course page | 641 KB | 630 KB |

The rest is mostly shared: React, the Firebase Auth and Firestore SDKs
(about 200 KB, needed on every page because the header shows who is signed
in), and the animation library. Further savings would mean loading Firebase
only after the first screen appears, a larger change left for after launch.

### Not done on purpose

- **Full Content-Security-Policy.** Google sign-in, Storage videos and the
  Snippe checkout would each need allow-listing and testing on the live
  domain first. Only `frame-ancestors` is set.
- **Offline mode / service worker.** Lessons are streamed videos, so
  offline viewing isn't possible without a download feature.

## Checked

On a production build (`pnpm build && pnpm start`):

- `robots.txt`, `sitemap.xml` (3 published courses, 1 category), the
  manifest and the icons are served.
- Every response carries the security headers.
- Unknown URLs and `/learn/x/refund` return 404 with the new page.
- The landing page's contact form appears when scrolled to.
- A course page has the course title and cover as its share preview.
- Typecheck, lint and build pass.

## Steps for the academy

### 1. Choose the host

Both run Next.js 16. Set the project's base directory to `webapp`.

**Netlify** is configured in `webapp/netlify.toml`, so only the base
directory needs setting when the site is created (Add new site → Import
from GitHub → this repo, branch `flutterflow`, Base directory `webapp`).
The file:

- builds with `pnpm build` on Node 22 and pnpm 10.30;
- skips a build when nothing in `webapp/` changed, so mobile-only pushes
  don't use build minutes;
- gives deploy previews and branch deploys their own address in the
  sitemap and share links, and robots.txt closes them to search engines.

The repo-root `netlify.toml` is the admin portal's and isn't affected:
Netlify reads the config from each site's base directory. The admin
site's config likewise skips builds when a push only changes `webapp/` or
`docs/`.

| | Netlify | Vercel |
|---|---|---|
| Pros | The admin portal is already there (one account, one bill) | Made by the Next.js team; every feature works first |
| Cons | Next.js support comes through an adapter, so new Next features can lag | A second hosting account |
| Free plan | Enough to start | Enough to start; commercial use needs the Pro plan |

Recommendation: **Vercel Pro** if the budget allows, since the free plan
doesn't allow commercial sites; otherwise Netlify.

### 2. Preview before switching the domain

1. Deploy the `web-app` branch. The host gives a preview address
   (for example `nelwa-academy.vercel.app`).
2. Set `NEXT_PUBLIC_SITE_URL` to that address so its links point at itself.
3. In the **Firebase console → Authentication → Settings → Authorized
   domains**, add the preview address, or sign-in with Google fails there.
4. Checkout returns buyers only to `WEB_APP_ORIGINS` in
   `firebase/functions/.env` (now `nelwasacademy.com` and `www`). To test a
   payment on the preview, add its address there and redeploy the
   functions; otherwise payment still works but the buyer isn't sent back
   to the site.
5. Run the real-account tests below on the preview.

### 3. Real-account tests (not done yet)

The checklists are in each phase's doc:

- One real 500 TZS purchase: [checkout-web.md](checkout-web.md)
- Learner: My courses, player, progress, review: [learning-web.md](learning-web.md)
- Account pages, support chat, consultation booking: [account-web.md](account-web.md)
- An approved instructor: [studio-web.md](studio-web.md#testing)
- On a phone over mobile data: landing, sign-up, buying, watching a lesson.

### 4. Switch the domain

1. Add `nelwasacademy.com` and `www.nelwasacademy.com` to the host, and
   update the DNS records at Hostinger as the host instructs. Keep the
   existing email (MX) and Resend records unchanged.
2. Remove `NEXT_PUBLIC_SITE_URL` (or set it to `https://nelwasacademy.com`).
3. Add `nelwasacademy.com` and `www.nelwasacademy.com` to Firebase's
   authorized domains, if they aren't there yet.
4. Submit `https://nelwasacademy.com/sitemap.xml` in Google Search Console.

### 5. After launch

- Watch the host's error logs for the first week.
- Replace the placeholder legal pages with the academy's final terms and
  privacy policy (`webapp/src/features/help/legal.ts`).
- The landing and share images use `public/brand/hero.jpg`, which has an
  AI-image sparkle mark in its corner (cropped out of the share image).
  Replace it with a real photo of the academy when one is available.
