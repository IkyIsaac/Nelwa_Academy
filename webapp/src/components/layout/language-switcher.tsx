"use client"

import { Check, Globe } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import { useRouter } from "next/navigation"
import { useTransition } from "react"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { setLocale } from "@/i18n/actions"
import { localeNames, locales } from "@/i18n/config"
import { cn } from "@/lib/utils"

/** Globe button that switches between English, Kiswahili and Français. */
export function LanguageSwitcher({ onDark = false }: { onDark?: boolean }) {
  const t = useTranslations("language")
  const current = useLocale()
  const router = useRouter()
  const [pending, startTransition] = useTransition()

  const choose = (locale: string) =>
    startTransition(async () => {
      await setLocale(locale)
      router.refresh()
    })

  return (
    <DropdownMenu>
      <DropdownMenuTrigger
        render={
          <Button
            variant="ghost"
            size="icon"
            aria-label={t("title")}
            disabled={pending}
            className={cn(onDark &&
                "text-white hover:bg-white/10 hover:text-white aria-expanded:bg-white/15 aria-expanded:text-white")}
          />
        }
      >
        <Globe />
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-44">
        <DropdownMenuGroup>
          <DropdownMenuLabel>{t("title")}</DropdownMenuLabel>
          {locales.map((locale) => (
            <DropdownMenuItem key={locale} onClick={() => choose(locale)}>
              <span aria-hidden>{localeNames[locale].flag}</span>
              {localeNames[locale].label}
              {locale === current && <Check className="ml-auto text-primary" />}
            </DropdownMenuItem>
          ))}
        </DropdownMenuGroup>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
