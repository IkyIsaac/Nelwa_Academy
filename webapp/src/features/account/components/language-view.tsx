"use client"

import { Check, Loader2 } from "lucide-react"
import { useLocale } from "next-intl"
import { useRouter } from "next/navigation"
import { useState, useTransition } from "react"
import { setLocale } from "@/i18n/actions"
import { localeNames, locales } from "@/i18n/config"
import { cn } from "@/lib/utils"

/** Pick the site language (saved in a cookie, like the header switcher). */
export function LanguageView() {
  const current = useLocale()
  const router = useRouter()
  const [pending, startTransition] = useTransition()
  const [choice, setChoice] = useState(current)

  const pick = (locale: string) => {
    setChoice(locale)
    startTransition(async () => {
      await setLocale(locale)
      router.refresh()
    })
  }

  return (
    <ul role="radiogroup" className="space-y-3">
      {locales.map((locale) => {
        const active = choice === locale
        return (
          <li key={locale}>
            <button
              type="button"
              role="radio"
              aria-checked={active}
              onClick={() => pick(locale)}
              className={cn(
                "flex w-full items-center gap-4 rounded-2xl border-[1.5px] bg-white px-5 py-4 text-left transition-all",
                active ? "border-primary bg-maroon-tint" : "border-border hover:border-primary/40",
              )}
            >
              <span className="text-2xl" aria-hidden>
                {localeNames[locale].flag}
              </span>
              <span className="flex-1 font-semibold">{localeNames[locale].label}</span>
              {active &&
                (pending ? (
                  <Loader2 className="size-5 animate-spin text-primary" />
                ) : (
                  <Check className="size-5 text-primary" />
                ))}
            </button>
          </li>
        )
      })}
    </ul>
  )
}
