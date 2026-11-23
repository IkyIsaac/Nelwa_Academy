# Buying a course on the website (Phase 3)

How a learner pays for a course on the website. It uses the same Snippe
backend as the mobile app (see [snippe-integration.md](snippe-integration.md)),
so an order paid on the web unlocks the course on the phone too, and vice
versa.

## The flow

```
Course page ──Enroll──► /checkout/{courseId}          (sign-in required)
                         │  Pay
                         │  1. open a blank tab (still inside the click)
                         │  2. createOrder({courseIds, returnOrigin})
                         │  3. point the new tab at Snippe's checkout_url
                         ▼
                        /checkout/status/{orderId}     (this tab)
                         │  live onSnapshot on orders/{orderId}
                         │
  Snippe tab: learner enters phone, approves the PIN prompt
       │
       ├──► webhook → snippeWebhook → order "completed", course granted
       └──► Snippe redirects that tab to /checkout/status/{orderId}

  Both tabs flip to "Payment received" on their own.
```

The website never decides that a payment succeeded. Only the
signature-verified webhook can mark an order `completed` and create the
`purchased_courses` entry. The status page only *displays* the order,
which the security rules let only its buyer read.

### Why a new tab

Snippe's checkout is a hosted page. A new tab keeps our order page open,
so it can show progress the moment the webhook lands. Browsers block tabs
opened after an `await`, which is the bug that broke the mobile web build
(see the follow-ups in [snippe-integration.md](snippe-integration.md)). So
the tab is opened synchronously in the click handler, shows "Opening
secure checkout…", and is pointed at Snippe once `createOrder` returns.
If the browser still blocks it, the page goes to Snippe in the same tab,
and Snippe's `redirect_url` brings the learner back to the order page.

## Pages

| Route | What it shows |
|---|---|
| `/checkout/[id]` | Mobile-money networks, three steps, the Pay button; order summary with cover, instructor, plan and total. Shows "already own this" or "this course is free" instead when relevant |
| `/checkout/status/[orderId]` | **Waiting** (pulsing phone, "open payment page" link), **Paid** (receipt emailed, start learning), or **Failed / Expired / Cancelled** (not charged, try again) |

Both pages need sign-in and are excluded from search engines.

Code: `webapp/src/features/checkout/`

- `api.ts`: `startCheckout`, `checkoutError` (maps function error codes),
  `watchOrder`, `hasPurchased`.
- `hooks.ts`: `useOrder` (live, and refreshes cached course data on
  completion) and `usePurchased`.
- `components/`: `checkout-view.tsx`, `order-status-view.tsx`,
  `order-summary.tsx`.

## Backend change

`createOrder` (`firebase/functions/payments.js`) takes an optional
`returnOrigin`:

- If it is in `WEB_APP_ORIGINS` (in `firebase/functions/.env`), or is
  `http://localhost` / `127.0.0.1` on any port, the Snippe session gets
  `redirect_url = {origin}/checkout/status/{orderId}`.
- Anything else (other domains, `http://` on a real domain, `javascript:`)
  is ignored, so the checkout can't be used to send people to another
  site.
- The mobile app sends no origin and works exactly as before.
- Orders now record `source: "web" | "app"`, and the session has a
  `description` listing the course titles.

`WEB_APP_ORIGINS` is currently `https://nelwasacademy.com,https://www.nelwasacademy.com`.
**Add the Netlify/Vercel URL (and any preview domain you'll test on) there
before testing on a deployed site**, then redeploy functions.

## Decisions and limits

| Topic | Behaviour | Why |
|---|---|---|
| Yearly plan | Shown on the course page, disabled, "coming soon" | `createOrder` only charges `price`, and nothing expires access. The mobile app blocks yearly the same way. Adding it needs `year_price` support on the server **and** a decision on what access expiry means |
| Monthly price | Charged once; access doesn't expire | Existing behaviour on mobile and in fulfilment. The "/month" label comes from the course data |
| Free courses (`price` 0) | "Start learning free" opens the course's lessons; no checkout | Mobile has no free-enroll step either: free lessons are simply open. `createOrder` rejects price 0 |
| Old purchases | Checkout also checks `users/{uid}/purchased_courses` | Pre-Snippe buyers aren't always in the course's `downloaders` |
| One course per order | The web sends one course | `createOrder` supports several, ready for a cart later |
| After paying | "Start learning" goes to the course page (shows "You're enrolled") | The player at `/learn/[id]` arrives in Phase 4; switch the link then |

## Testing

There is no Snippe sandbox. Every real test costs at least 500 TZS. Use
the disposable "Sample Test Course" described in
[snippe-integration.md](snippe-integration.md#testing-again).

Checked so far:

- Typecheck, lint and production build pass; both routes compile.
- Logged out, `/checkout/...` and `/checkout/status/...` redirect to sign-in
  and come back afterwards.
- The `returnOrigin` allowlist was unit-checked against allowed, lookalike,
  `http://` and `javascript:` origins.

Still to do (needs a signed-in account and a real 500 TZS payment):

1. ~~Deploy functions~~: `createOrder` with `redirect_url` was deployed
   on 2026-11-17. An anonymous call is correctly refused.
2. Sign in on the site, open the sample course, Pay.
3. Approve on the phone. Confirm the order page flips to "Payment
   received", the receipt email arrives, and the course shows as owned on
   web and mobile.
4. Start another payment and cancel it. Confirm "Payment cancelled".
