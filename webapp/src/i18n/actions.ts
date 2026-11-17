"use server"

import { cookies } from "next/headers"
import { isLocale, LOCALE_COOKIE } from "./config"

/** Saves the learner's language for a year. Call `router.refresh()` afterwards. */
export async function setLocale(locale: string) {
  if (!isLocale(locale)) return
  ;(await cookies()).set(LOCALE_COOKIE, locale, {
    path: "/",
    maxAge: 60 * 60 * 24 * 365,
    sameSite: "lax",
  })
}
