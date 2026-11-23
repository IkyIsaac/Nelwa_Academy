"use client"

import { Bell, Menu, Search } from "lucide-react"
import { motion, useMotionValueEvent, useScroll } from "motion/react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Sheet, SheetContent, SheetTitle, SheetTrigger } from "@/components/ui/sheet"
import { useUnreadCount } from "@/features/account/hooks"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"
import { LanguageSwitcher } from "./language-switcher"
import { Logo } from "./logo"
import { UserMenu } from "./user-menu"

type NavLink = { href: string; label: string }

/**
 * The one header used across the site.
 * - On the landing page it starts transparent with white text over the maroon
 *   hero, then turns into a frosted white bar once the visitor scrolls.
 * - Signed-out visitors see the marketing links; learners see the app links.
 */
export function SiteHeader() {
  const t = useTranslations("nav")
  const pathname = usePathname()
  const { status } = useAuth()
  const signedIn = status === "signed-in"
  const overHero = pathname === routes.landing

  const { scrollY } = useScroll()
  const [scrolled, setScrolled] = useState(false)
  useMotionValueEvent(scrollY, "change", (y) => setScrolled(y > 40))

  const onDark = overHero && !scrolled

  const links: NavLink[] = signedIn
    ? [
        { href: routes.home, label: t("home") },
        { href: routes.explore, label: t("explore") },
        { href: routes.learn, label: t("myLearning") },
        { href: routes.consult, label: t("consult") },
      ]
    : [
        { href: routes.about, label: t("about") },
        { href: routes.explore, label: t("courses") },
        { href: routes.consult, label: t("consult") },
        { href: routes.contact, label: t("contact") },
      ]

  const isActive = (href: string) => pathname === href || pathname.startsWith(`${href}/`)

  return (
    <header
      className={cn(
        "fixed inset-x-0 top-0 z-50 transition-[background-color,box-shadow,padding] duration-400",
        scrolled || !overHero
          ? "bg-white/90 py-3 shadow-[0_4px_40px_rgb(93_8_11/0.10)] backdrop-blur-xl"
          : "bg-transparent py-5",
      )}
    >
      <div className="container-page flex items-center gap-6">
        <Logo light={onDark} />

        <nav aria-label="Main" className="ml-4 hidden items-center gap-1 md:flex">
          {links.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className={cn(
                "relative rounded-full px-4 py-2 text-sm font-medium transition-colors",
                onDark ? "text-white/85 hover:text-white" : "text-muted-foreground hover:text-primary",
                isActive(link.href) && (onDark ? "text-white" : "text-primary"),
              )}
            >
              {isActive(link.href) && (
                <motion.span
                  layoutId="nav-active-pill"
                  className={cn(
                    "absolute inset-0 -z-10 rounded-full",
                    onDark ? "bg-white/15" : "bg-maroon-tint",
                  )}
                  transition={{ type: "spring", stiffness: 380, damping: 32 }}
                />
              )}
              {link.label}
            </Link>
          ))}
        </nav>

        <div className="ml-auto flex items-center gap-1.5">
          <LanguageSwitcher onDark={onDark} />

          {signedIn ? (
            <>
              <Button
                variant="ghost"
                size="icon"
                aria-label={t("search")}
                render={<Link href={routes.search} />}
                className={cn(
                  "hidden sm:inline-flex",
                  onDark && "text-white hover:bg-white/10 hover:text-white",
                )}
              >
                <Search />
              </Button>
              <NotificationBell onDark={onDark} label={t("notifications")} />
              <div className="ml-1">
                <UserMenu />
              </div>
            </>
          ) : (
            status === "signed-out" && (
              <>
                <Link
                  href={routes.signIn}
                  className={cn(
                    "hidden px-3 text-sm font-semibold transition-colors sm:block",
                    onDark ? "text-white/90 hover:text-white" : "text-foreground hover:text-primary",
                  )}
                >
                  {t("signIn")}
                </Link>
                <Button
                  size="sm"
                  variant={onDark ? "outline-light" : "outline"}
                  render={<Link href={routes.signUp} />}
                  className="hidden sm:inline-flex"
                >
                  {t("enrollNow")}
                </Button>
              </>
            )
          )}

          {/* Phones: signed-in learners get the bottom tab bar; visitors get this menu. */}
          {!signedIn && <MobileMenu links={links} onDark={onDark} />}
        </div>
      </div>
    </header>
  )
}

function MobileMenu({ links, onDark }: { links: NavLink[]; onDark: boolean }) {
  const t = useTranslations("nav")
  const [open, setOpen] = useState(false)

  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <SheetTrigger
        render={
          <Button
            variant="ghost"
            size="icon"
            aria-label={t("openMenu")}
            className={cn("md:hidden", onDark && "text-white hover:bg-white/10 hover:text-white")}
          />
        }
      >
        <Menu />
      </SheetTrigger>
      <SheetContent side="top" className="rounded-b-3xl px-6 pt-20 pb-8">
        <SheetTitle className="sr-only">{t("openMenu")}</SheetTitle>
        <nav className="flex flex-col">
          {links.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              onClick={() => setOpen(false)}
              className="border-b border-border py-3 text-lg font-semibold"
            >
              {link.label}
            </Link>
          ))}
        </nav>
        <div className="mt-4 grid grid-cols-2 gap-3">
          <Button variant="outline" render={<Link href={routes.signIn} onClick={() => setOpen(false)} />}>
            {t("signIn")}
          </Button>
          <Button render={<Link href={routes.signUp} onClick={() => setOpen(false)} />}>
            {t("enrollNow")}
          </Button>
        </div>
      </SheetContent>
    </Sheet>
  )
}

/** Bell with a live unread count (only rendered for signed-in learners). */
function NotificationBell({ onDark, label }: { onDark: boolean; label: string }) {
  const unread = useUnreadCount()
  return (
    <Button
      variant="ghost"
      size="icon"
      aria-label={unread ? `${label} (${unread})` : label}
      render={<Link href={routes.notifications} />}
      className={cn("relative", onDark && "text-white hover:bg-white/10 hover:text-white")}
    >
      <Bell />
      {unread > 0 && (
        <span className="absolute top-1 right-1 grid min-w-4 place-items-center rounded-full bg-maroon-light px-1 text-[10px] leading-4 font-bold text-white ring-2 ring-white">
          {unread > 9 ? "9+" : unread}
        </span>
      )}
    </Button>
  )
}
