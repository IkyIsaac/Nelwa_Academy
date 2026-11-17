"use client"

import { Loader2 } from "lucide-react"
import { useTranslations } from "next-intl"
import { usePathname } from "next/navigation"
import { LanguageSwitcher } from "@/components/layout/language-switcher"
import { Logo } from "@/components/layout/logo"
import { PageEnter } from "@/components/motion/page-enter"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { RequireAuth } from "@/features/auth/components/guards"

/**
 * Cream page with a floating white card, used for the onboarding steps.
 * Waits for the learner's profile so forms can be pre-filled.
 */
export function OnboardingFrame({ children }: { children: React.ReactNode }) {
  const t = useTranslations("onboarding")
  const pathname = usePathname()
  const step = pathname.startsWith(routes.interests) ? 2 : 1

  return (
    <div className="relative min-h-dvh overflow-hidden bg-cream">
      <div className="absolute -top-40 -right-40 size-[520px] animate-blob rounded-full bg-maroon/8 blur-[90px]" />
      <div className="absolute -bottom-40 -left-40 size-[420px] animate-blob rounded-full bg-gold/10 blur-[90px] [animation-direction:reverse]" />

      <header className="container-page relative flex items-center justify-between py-5">
        <Logo />
        <div className="flex items-center gap-3">
          <span className="rounded-full bg-white px-3 py-1 text-xs font-semibold text-primary shadow-soft">
            {t("step", { step, total: 2 })}
          </span>
          <LanguageSwitcher />
        </div>
      </header>

      <main className="container-page relative flex justify-center pt-4 pb-16">
        <RequireAuth>
          <ProfileReady>
            <PageEnter className="w-full max-w-xl rounded-[2rem] border border-border bg-white p-6 shadow-[0_24px_80px_rgb(93_8_11/0.08)] sm:p-10">
              {children}
            </PageEnter>
          </ProfileReady>
        </RequireAuth>
      </main>
    </div>
  )
}

function ProfileReady({ children }: { children: React.ReactNode }) {
  const { profile } = useAuth()
  if (!profile) {
    return (
      <div className="grid min-h-[50dvh] place-items-center">
        <Loader2 className="size-7 animate-spin text-primary" />
      </div>
    )
  }
  return <>{children}</>
}
