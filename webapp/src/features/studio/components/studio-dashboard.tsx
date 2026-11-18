"use client"

import { BookOpen, GraduationCap, Plus, Star, Users, Wallet } from "lucide-react"
import { useFormatter, useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { useMemo } from "react"
import { CoverImage } from "@/components/cover-image"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { formatPrice } from "@/features/catalog/format"
import { courseTitle } from "@/features/catalog/types"
import { useMyCourses, useMyInstructorProfile, usePaymentAccount } from "../hooks"
import type { Sale } from "../types"
import { StatTile, StudioSection } from "./studio-shell"

/** Sales per calendar month, oldest first, for the last `months` months. */
function monthlyTotals(sales: Sale[], months: number) {
  const now = new Date()
  return Array.from({ length: months }, (_, i) => {
    const start = new Date(now.getFullYear(), now.getMonth() - (months - 1 - i), 1)
    const end = new Date(start.getFullYear(), start.getMonth() + 1, 1)
    const inMonth = sales.filter((s) => s.date && s.date >= start && s.date < end)
    return { start, total: inMonth.reduce((sum, s) => sum + s.amount, 0), count: inMonth.length }
  })
}

export function StudioDashboard() {
  const t = useTranslations("studio.dashboard")
  const format = useFormatter()
  const locale = useLocale()
  const courses = useMyCourses()
  const account = usePaymentAccount()
  const me = useMyInstructorProfile()

  const sales = useMemo(() => account.data?.sales ?? [], [account.data])
  const months = useMemo(() => monthlyTotals(sales, 6), [sales])
  const peak = Math.max(1, ...months.map((m) => m.total))
  const list = courses.data ?? []
  const students = new Set(list.flatMap((c) => c.studentIds)).size
  const rated = list.filter((c) => c.reviewsCount > 0)
  const rating = rated.length
    ? rated.reduce((sum, c) => sum + c.rating * c.reviewsCount, 0) /
      rated.reduce((sum, c) => sum + c.reviewsCount, 0)
    : 0
  const salesTotal = sales.reduce((sum, s) => sum + s.amount, 0)
  const loading = courses.isPending || account.isPending

  if (loading) {
    return (
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {Array.from({ length: 4 }, (_, i) => (
          <Skeleton key={i} className="h-40 rounded-3xl" />
        ))}
      </div>
    )
  }

  return (
    <div className="space-y-12">
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatTile
          icon={Wallet}
          label={t("balance")}
          value={formatPrice(account.data?.balance ?? 0)}
          hint={t("balanceHint")}
        />
        <StatTile
          icon={GraduationCap}
          label={t("sales")}
          value={formatPrice(salesTotal)}
          hint={t("salesCount", { count: sales.length })}
        />
        <StatTile
          icon={Users}
          label={t("students")}
          value={students}
          hint={t("followers", { count: me.data?.followerIds.length ?? 0 })}
        />
        <StatTile
          icon={Star}
          label={t("rating")}
          value={rating ? rating.toFixed(1) : "—"}
          hint={t("reviews", { count: list.reduce((sum, c) => sum + c.reviewsCount, 0) })}
        />
      </div>

      <div className="grid gap-10 lg:grid-cols-[1fr_380px]">
        <StudioSection title={t("salesByMonth")}>
          <div className="rounded-3xl border border-border bg-white p-5 sm:p-6">
            <ol className="flex h-56 items-end gap-3" aria-label={t("salesByMonth")}>
              {months.map((m) => (
                <li
                  key={m.start.toISOString()}
                  className="flex h-full flex-1 flex-col items-center justify-end gap-2"
                >
                  <span className="text-[11px] font-semibold text-muted-foreground tabular-nums">
                    {m.total ? format.number(m.total, { notation: "compact" }) : ""}
                  </span>
                  <span
                    className="w-full max-w-12 rounded-t-xl bg-primary/85 transition-all"
                    style={{ height: `${Math.max(m.total ? 6 : 2, (m.total / peak) * 100)}%` }}
                    title={`${formatPrice(m.total)} · ${t("salesCount", { count: m.count })}`}
                  />
                  <span className="text-xs text-muted-foreground">
                    {format.dateTime(m.start, { month: "short" })}
                  </span>
                </li>
              ))}
            </ol>
          </div>
        </StudioSection>

        <StudioSection
          title={t("recentSales")}
          action={
            <Link href={routes.studioSales} className="text-sm font-semibold text-primary hover:underline">
              {t("seeAll")}
            </Link>
          }
        >
          {sales.length === 0 ? (
            <p className="rounded-3xl border border-dashed border-border bg-white p-6 text-sm text-muted-foreground">
              {t("noSales")}
            </p>
          ) : (
            <ul className="divide-y divide-border rounded-3xl border border-border bg-white">
              {sales.slice(0, 5).map((s, i) => (
                <li key={i} className="flex items-center justify-between gap-3 px-5 py-3.5">
                  <span className="min-w-0">
                    <span className="block truncate text-sm font-semibold">{s.courseName || "—"}</span>
                    <span className="text-xs text-muted-foreground">
                      {s.date ? format.dateTime(s.date, { dateStyle: "medium" }) : ""}
                    </span>
                  </span>
                  <span className="text-sm font-bold text-success tabular-nums">{formatPrice(s.amount)}</span>
                </li>
              ))}
            </ul>
          )}
        </StudioSection>
      </div>

      <StudioSection
        title={t("yourCourses", { count: list.length })}
        action={
          <Button size="sm" render={<Link href={routes.studioNewCourse} />}>
            <Plus /> {t("newCourse")}
          </Button>
        }
      >
        {list.length === 0 ? (
          <p className="rounded-3xl border border-dashed border-border bg-white p-6 text-sm text-muted-foreground">
            {t("noCourses")}
          </p>
        ) : (
          <ul className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {[...list]
              .sort((a, b) => b.studentIds.length - a.studentIds.length)
              .slice(0, 6)
              .map((c) => (
                <li key={c.id}>
                  <Link
                    href={routes.studioCourse(c.id)}
                    className="flex items-center gap-3 rounded-2xl border border-border bg-white p-3 transition-all hover:border-primary/20 hover:shadow-soft"
                  >
                    <CoverImage src={c.image} alt="" className="aspect-video w-24 shrink-0 rounded-xl" />
                    <span className="min-w-0">
                      <span className="line-clamp-1 text-sm font-semibold">{courseTitle(c, locale)}</span>
                      <span className="mt-0.5 flex items-center gap-1 text-xs text-muted-foreground">
                        <BookOpen className="size-3.5" /> {t("lessons", { count: c.totalLessons })} ·{" "}
                        {t("studentsCount", { count: c.studentIds.length })}
                      </span>
                    </span>
                  </Link>
                </li>
              ))}
          </ul>
        )}
      </StudioSection>
    </div>
  )
}
