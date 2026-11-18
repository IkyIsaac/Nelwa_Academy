"use client"

import { CalendarClock, Mail, MessageCircle, Phone } from "lucide-react"
import { useFormatter, useTranslations } from "next-intl"
import { EmptyState } from "@/components/empty-state"
import { Skeleton } from "@/components/ui/skeleton"
import { LoadError } from "@/features/catalog/components/discover-views"
import { DEPARTMENTS } from "@/features/account/types"
import { useConsultations } from "../hooks"
import { StudioSection } from "./studio-shell"

/** Booking requests, as the mobile app's instructor Consultations screen lists them. */
export function ConsultationsView() {
  const t = useTranslations("studio.consultations")
  const tDept = useTranslations("account.consult.departments")
  const format = useFormatter()
  const consultations = useConsultations()

  if (consultations.isError) return <LoadError onRetry={() => consultations.refetch()} />
  if (consultations.isPending) return <Skeleton className="h-48 rounded-3xl" />
  const list = consultations.data
  if (list.length === 0)
    return <EmptyState icon={CalendarClock} title={t("emptyTitle")} body={t("emptyBody")} />

  const today = new Date()
  today.setHours(0, 0, 0, 0)

  return (
    <StudioSection title={t("title", { count: list.length })}>
      <ul className="grid gap-4 lg:grid-cols-2">
        {list.map((c) => {
          const dept = DEPARTMENTS.find((d) => d.stored === c.department)
          const upcoming = !!c.preferredDay && c.preferredDay >= today
          const phone = c.phone.replace(/[^0-9+]/g, "")
          return (
            <li key={c.id} className="flex flex-col rounded-3xl border border-border bg-white p-5">
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0">
                  <p className="truncate font-bold">{c.name || "—"}</p>
                  <p className="text-xs text-muted-foreground">{dept ? tDept(dept.id) : c.department}</p>
                </div>
                <span
                  className={
                    upcoming
                      ? "shrink-0 rounded-full bg-gold/15 px-2.5 py-0.5 text-[11px] font-bold text-gold"
                      : "shrink-0 rounded-full bg-muted px-2.5 py-0.5 text-[11px] font-bold text-muted-foreground"
                  }
                >
                  {upcoming ? t("upcoming") : t("past")}
                </span>
              </div>
              <p className="mt-3 text-sm">
                <span className="text-muted-foreground">{t("preferredDay")}: </span>
                <span className="font-semibold">
                  {c.preferredDay ? format.dateTime(c.preferredDay, { dateStyle: "full" }) : "—"}
                </span>
              </p>
              {c.reason && <p className="mt-2 line-clamp-4 text-sm text-muted-foreground">{c.reason}</p>}
              <div className="mt-auto flex flex-wrap gap-x-4 gap-y-2 pt-4 text-sm font-semibold text-primary">
                {phone && (
                  <a href={`tel:${phone}`} className="inline-flex items-center gap-1.5 hover:underline">
                    <Phone className="size-4" /> {c.phone}
                  </a>
                )}
                {phone && (
                  <a
                    href={`https://wa.me/${phone.replace("+", "")}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1.5 hover:underline"
                  >
                    <MessageCircle className="size-4" /> WhatsApp
                  </a>
                )}
                {c.email && (
                  <a href={`mailto:${c.email}`} className="inline-flex items-center gap-1.5 hover:underline">
                    <Mail className="size-4" /> {c.email}
                  </a>
                )}
              </div>
            </li>
          )
        })}
      </ul>
    </StudioSection>
  )
}
