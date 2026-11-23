"use client"

import {
  BarChart3,
  BookOpen,
  CalendarClock,
  GraduationCap,
  LayoutDashboard,
  Users,
  Wallet,
} from "lucide-react"
import { motion } from "motion/react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { EmptyState } from "@/components/empty-state"
import { PageHeader } from "@/components/layout/page-header"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { RequireAuth } from "@/features/auth/components/guards"
import { cn } from "@/lib/utils"
import { useIsInstructor } from "../hooks"

const TABS = [
  { href: routes.studio, key: "dashboard", icon: LayoutDashboard, exact: true },
  { href: routes.studioCourses, key: "courses", icon: BookOpen },
  { href: routes.studioSales, key: "sales", icon: Wallet },
  { href: routes.studioFollowers, key: "followers", icon: Users },
  { href: routes.studioConsultations, key: "consultations", icon: CalendarClock },
] as const

/**
 * Frame for every studio page: sign-in, the approved-instructor check (the
 * same `instructor` flag the mobile app uses to show instructor mode), the
 * header and the section tabs.
 */
export function StudioShell({ children }: { children: React.ReactNode }) {
  return (
    <RequireAuth>
      <StudioGate>{children}</StudioGate>
    </RequireAuth>
  )
}

function StudioGate({ children }: { children: React.ReactNode }) {
  const t = useTranslations("studio")
  const { loading, allowed } = useIsInstructor()
  const pathname = usePathname()

  if (loading) {
    return (
      <div className="container-page pt-32 pb-16">
        <Skeleton className="h-10 w-64" />
        <Skeleton className="mt-8 h-64 rounded-3xl" />
      </div>
    )
  }
  if (!allowed) {
    return (
      <div className="container-page pt-32 pb-16">
        <EmptyState
          icon={GraduationCap}
          title={t("notInstructorTitle")}
          body={t("notInstructorBody")}
          action={<Button render={<Link href={routes.support} />}>{t("contactAcademy")}</Button>}
        />
      </div>
    )
  }

  return (
    <>
      <PageHeader eyebrow={t("eyebrow")} title={t("title")} description={t("description")}>
        <nav aria-label={t("title")} className="-mx-4 overflow-x-auto px-4 pb-1 sm:mx-0 sm:px-0">
          <ul className="inline-flex gap-1 rounded-full border border-border bg-white p-1">
            {TABS.map((tab) => {
              const active = "exact" in tab ? pathname === tab.href : pathname.startsWith(tab.href)
              return (
                <li key={tab.key}>
                  <Link
                    href={tab.href}
                    aria-current={active ? "page" : undefined}
                    className={cn(
                      "relative flex items-center gap-2 rounded-full px-4 py-2 text-sm font-semibold whitespace-nowrap transition-colors",
                      active ? "text-white" : "text-muted-foreground hover:text-foreground",
                    )}
                  >
                    {active && (
                      <motion.span
                        layoutId="studio-tab"
                        className="absolute inset-0 rounded-full bg-primary"
                      />
                    )}
                    <tab.icon className="relative size-4" />
                    <span className="relative">{t(`tabs.${tab.key}`)}</span>
                  </Link>
                </li>
              )
            })}
          </ul>
        </nav>
      </PageHeader>
      <div className="container-page py-10">{children}</div>
    </>
  )
}

/** Section heading used inside studio pages. */
export function StudioSection({
  title,
  action,
  children,
  className,
}: {
  title: string
  action?: React.ReactNode
  children: React.ReactNode
  className?: string
}) {
  return (
    <section className={cn("space-y-4", className)}>
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h2 className="font-sans text-xl font-bold">{title}</h2>
        {action}
      </div>
      {children}
    </section>
  )
}

export function StatTile({
  icon: Icon,
  label,
  value,
  hint,
}: {
  icon: typeof BarChart3
  label: string
  value: React.ReactNode
  hint?: string
}) {
  return (
    <div className="rounded-3xl border border-border bg-white p-5">
      <span className="grid size-10 place-items-center rounded-xl bg-maroon-tint text-primary">
        <Icon className="size-5" />
      </span>
      <p className="mt-4 text-sm text-muted-foreground">{label}</p>
      <p className="mt-1 font-sans text-2xl font-extrabold tabular-nums">{value}</p>
      {hint && <p className="mt-1 text-xs text-muted-foreground">{hint}</p>}
    </div>
  )
}

/** Native select styled like the Input component (reliable on phones). */
export function NativeSelect({ className, ...props }: React.ComponentProps<"select">) {
  return (
    <select
      className={cn(
        "h-12 w-full rounded-xl border-[1.5px] border-input bg-white px-3 text-[15px] transition-[border-color,box-shadow] outline-none hover:border-primary/30 focus-visible:border-primary focus-visible:ring-4 focus-visible:ring-primary/8 aria-invalid:border-destructive",
        className,
      )}
      {...props}
    />
  )
}
