/** Languages the app is offered in — the same three as the mobile app. */
export const locales = ["en", "sw", "fr"] as const
export type Locale = (typeof locales)[number]

export const defaultLocale: Locale = "en"

/** Cookie that remembers the learner's chosen language. */
export const LOCALE_COOKIE = "NEXT_LOCALE"

export const localeNames: Record<Locale, { label: string; flag: string }> = {
  en: { label: "English", flag: "🇬🇧" },
  sw: { label: "Kiswahili", flag: "🇹🇿" },
  fr: { label: "Français", flag: "🇫🇷" },
}

export const isLocale = (value: unknown): value is Locale =>
  typeof value === "string" && (locales as readonly string[]).includes(value)
