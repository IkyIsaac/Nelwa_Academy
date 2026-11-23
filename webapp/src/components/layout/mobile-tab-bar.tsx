"use client"

import { BookOpen, Compass, House, User } from "lucide-react"
import { motion } from "motion/react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"

/** Bottom tabs on phones for signed-in learners — the same four as the mobile app. */
export function MobileTabBar() {
  const t = useTranslations("nav")
  const pathname = usePathname()
  const { status } = useAuth()
  if (status !== "signed-in") return null

  const tabs = [
    { href: routes.home, label: t("home"), icon: House },
    { href: routes.explore, label: t("explore"), icon: Compass },
    { href: routes.learn, label: t("learn"), icon: BookOpen },
    { href: routes.account, label: t("profile"), icon: User },
  ]

  return (
    <nav
      aria-label="Tabs"
      className="fixed inset-x-3 bottom-3 z-50 rounded-3xl border border-border bg-white/95 px-2 pb-[env(safe-area-inset-bottom)] shadow-[0_12px_40px_rgb(93_8_11/0.16)] backdrop-blur-xl md:hidden"
    >
      <ul className="grid grid-cols-4">
        {tabs.map(({ href, label, icon: Icon }) => {
          const active = pathname === href || pathname.startsWith(`${href}/`)
          return (
            <li key={href}>
              <Link
                href={href}
                aria-current={active ? "page" : undefined}
                className={cn(
                  "relative flex flex-col items-center gap-1 py-2.5 text-[11px] font-medium transition-colors",
                  active ? "text-primary" : "text-muted-foreground",
                )}
              >
                {active && (
                  <motion.span
                    layoutId="tab-active"
                    className="absolute inset-x-3 inset-y-1.5 -z-10 rounded-2xl bg-maroon-tint"
                    transition={{ type: "spring", stiffness: 420, damping: 34 }}
                  />
                )}
                <Icon className="size-5" strokeWidth={active ? 2.4 : 1.8} />
                {label}
              </Link>
            </li>
          )
        })}
      </ul>
    </nav>
  )
}
