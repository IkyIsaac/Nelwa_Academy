"use client"

import {
  BadgeCheck,
  Bell,
  BookOpen,
  CalendarClock,
  ChevronRight,
  CircleHelp,
  FileText,
  Heart,
  Languages,
  LogOut,
  MessagesSquare,
  Presentation,
  Receipt,
  Shield,
  ShieldCheck,
  Star,
  User,
  Users,
  type LucideIcon,
} from "lucide-react"
import { motion } from "motion/react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { signOut } from "@/features/auth/api"
import { useAuth } from "@/features/auth/components/auth-provider"
import { initials } from "@/lib/utils"
import { useUnreadCount } from "../hooks"

type Item = { href: string; icon: LucideIcon; label: string; badge?: number }

/** The Profile tab: who you are, then everything about your account. */
export function AccountHub() {
  const t = useTranslations("account")
  const router = useRouter()
  const { user, profile } = useAuth()
  const unread = useUnreadCount()
  const name = profile?.displayName || user?.displayName || ""
  const photo = profile?.photoUrl || user?.photoURL || undefined

  const groups: { title: string; items: Item[] }[] = [
    // Approved instructors (the same flag the mobile app's instructor mode uses).
    ...(profile?.instructor
      ? [
          {
            title: t("groups.teaching"),
            items: [{ href: routes.studio, icon: Presentation, label: t("menu.studio") }],
          },
        ]
      : []),
    {
      title: t("groups.learning"),
      items: [
        { href: routes.learn, icon: BookOpen, label: t("menu.myCourses") },
        { href: routes.wishlist, icon: Heart, label: t("menu.wishlist") },
        { href: routes.myReviews, icon: Star, label: t("menu.reviews") },
        { href: routes.subscriptions, icon: Users, label: t("menu.following") },
        { href: routes.purchases, icon: Receipt, label: t("menu.purchases") },
      ],
    },
    {
      title: t("groups.account"),
      items: [
        { href: routes.personalInfo, icon: User, label: t("menu.personalInfo") },
        { href: routes.security, icon: Shield, label: t("menu.security") },
        { href: routes.notifications, icon: Bell, label: t("menu.notifications"), badge: unread },
        { href: routes.language, icon: Languages, label: t("menu.language") },
      ],
    },
    {
      title: t("groups.help"),
      items: [
        { href: routes.support, icon: MessagesSquare, label: t("menu.support") },
        { href: routes.consult, icon: CalendarClock, label: t("menu.consult") },
        { href: routes.help, icon: CircleHelp, label: t("menu.help") },
        { href: routes.terms, icon: FileText, label: t("menu.terms") },
        { href: routes.privacy, icon: ShieldCheck, label: t("menu.privacy") },
      ],
    },
  ]

  const logout = async () => {
    await signOut()
    router.replace(routes.signIn)
  }

  return (
    <>
      <div className="relative overflow-hidden bg-maroon pt-28 pb-12 text-white sm:pt-32">
        <div className="pointer-events-none absolute -top-24 -right-24 size-96 rounded-full bg-maroon-light/40 blur-3xl" />
        <div className="container-page relative flex flex-col items-center gap-4 text-center sm:flex-row sm:text-left">
          <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }}>
            <Avatar className="size-24 ring-4 ring-white/20">
              <AvatarImage src={photo} alt="" />
              <AvatarFallback className="bg-maroon-light text-2xl font-bold text-white">
                {initials(name)}
              </AvatarFallback>
            </Avatar>
          </motion.div>
          <div className="min-w-0">
            <h1 className="flex items-center justify-center gap-2 text-2xl font-extrabold sm:justify-start sm:text-3xl">
              {name || t("noName")}
              {profile?.instructor && (
                <BadgeCheck className="size-6 text-gold" aria-label={t("instructor")} />
              )}
            </h1>
            <p className="mt-1 truncate text-white/70">{user?.email}</p>
          </div>
          <Button variant="cream" className="sm:ml-auto" render={<Link href={routes.personalInfo} />}>
            {t("editProfile")}
          </Button>
        </div>
      </div>

      <div className="container-page grid gap-6 py-10 lg:grid-cols-3">
        {groups.map((group, gi) => (
          <motion.section
            key={group.title}
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: gi * 0.06 }}
            className="rounded-3xl border border-border bg-white p-2"
          >
            <h2 className="px-4 pt-3 pb-2 text-xs font-bold tracking-[0.15em] text-gold uppercase">
              {group.title}
            </h2>
            <ul>
              {group.items.map((item) => (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    className="group flex items-center gap-3 rounded-2xl px-4 py-3 transition-colors hover:bg-cream"
                  >
                    <span className="grid size-9 place-items-center rounded-xl bg-maroon-tint text-primary transition-transform group-hover:scale-105">
                      <item.icon className="size-4.5" />
                    </span>
                    <span className="flex-1 text-sm font-semibold">{item.label}</span>
                    {!!item.badge && (
                      <span className="rounded-full bg-primary px-2 py-0.5 text-[11px] font-bold text-white">
                        {item.badge}
                      </span>
                    )}
                    <ChevronRight className="size-4 text-muted-foreground transition-transform group-hover:translate-x-0.5" />
                  </Link>
                </li>
              ))}
            </ul>
          </motion.section>
        ))}

        <div className="lg:col-span-3">
          <Button variant="outline" className="w-full text-destructive sm:w-auto" onClick={logout}>
            <LogOut />
            {t("signOut")}
          </Button>
        </div>
      </div>
    </>
  )
}
