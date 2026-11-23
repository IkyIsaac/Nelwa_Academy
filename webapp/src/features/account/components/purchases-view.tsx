"use client"

import { Receipt } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { LoadError } from "@/features/catalog/components/discover-views"
import { cn } from "@/lib/utils"
import { usePurchaseHistory } from "../hooks"

export function PurchasesView() {
  const t = useTranslations("account.purchases")
  const locale = useLocale()
  const history = usePurchaseHistory()
  const fmt = new Intl.DateTimeFormat(locale, { dateStyle: "medium" })

  if (history.isError) return <LoadError onRetry={() => history.refetch()} />
  if (history.isPending) {
    return (
      <div className="space-y-3">
        {Array.from({ length: 3 }, (_, i) => (
          <Skeleton key={i} className="h-20 rounded-2xl" />
        ))}
      </div>
    )
  }
  if (!history.data.length) {
    return (
      <EmptyState
        icon={Receipt}
        title={t("emptyTitle")}
        body={t("emptyBody")}
        action={<Button render={<Link href={routes.explore} />}>{t("browse")}</Button>}
      />
    )
  }
  return (
    <ul className="divide-y divide-border overflow-hidden rounded-3xl border border-border bg-white">
      {history.data.map((p) => {
        const refunded = p.status.toLowerCase() === "refunded"
        return (
          <li key={p.id} className="flex items-center gap-4 px-5 py-4">
            <span className="grid size-10 shrink-0 place-items-center rounded-xl bg-maroon-tint text-primary">
              <Receipt className="size-4.5" />
            </span>
            <div className="min-w-0 flex-1">
              {p.courseId ? (
                <Link
                  href={routes.learnCourse(p.courseId)}
                  className="line-clamp-1 font-semibold hover:text-primary"
                >
                  {p.courseName || t("course")}
                </Link>
              ) : (
                <p className="line-clamp-1 font-semibold">{p.courseName || t("course")}</p>
              )}
              <p className="text-xs text-muted-foreground">
                {[p.at && fmt.format(p.at), p.method].filter(Boolean).join(" · ")}
              </p>
            </div>
            <div className="text-right">
              <p className="font-bold">
                {p.currency} {p.amount.toLocaleString("en-US")}
              </p>
              <span
                className={cn(
                  "text-[11px] font-bold uppercase",
                  refunded ? "text-muted-foreground" : "text-success",
                )}
              >
                {refunded ? t("refunded") : t("paid")}
              </span>
            </div>
          </li>
        )
      })}
    </ul>
  )
}
