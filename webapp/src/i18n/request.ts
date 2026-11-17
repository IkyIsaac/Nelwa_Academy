import { getRequestConfig } from "next-intl/server"
import { cookies, headers } from "next/headers"
import { defaultLocale, isLocale, LOCALE_COOKIE, type Locale } from "./config"

/**
 * Picks the language for each request: the saved cookie first, then the
 * browser's preferred language, then English.
 */
export default getRequestConfig(async () => {
  const saved = (await cookies()).get(LOCALE_COOKIE)?.value
  let locale: Locale = defaultLocale

  if (isLocale(saved)) {
    locale = saved
  } else {
    const preferred = (await headers()).get("accept-language") ?? ""
    const match = preferred
      .split(",")
      .map((part) => part.split(";")[0].trim().slice(0, 2).toLowerCase())
      .find(isLocale)
    if (match) locale = match
  }

  return {
    locale,
    messages: (await import(`../../messages/${locale}.json`)).default,
  }
})
