"use client"

import { Banknote, Info, Receipt, Wallet } from "lucide-react"
import { useFormatter, useTranslations } from "next-intl"
import Link from "next/link"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { formatPrice } from "@/features/catalog/format"
import { cn } from "@/lib/utils"
import { usePaymentAccount, usePayouts } from "../hooks"
import { StatTile, StudioSection } from "./studio-shell"

/**
 * Balance and sales come from `payment_account`, which only the payment
 * webhook credits. Payouts are sent by the academy from the admin portal
 * to the mobile-money number on the instructor's profile.
 */
export function SalesView() {
  const t = useTranslations("studio.sales")
  const format = useFormatter()
  const { profile } = useAuth()
  const account = usePaymentAccount()
  const payouts = usePayouts()

  if (account.isPending) return <Skeleton className="h-64 rounded-3xl" />

  const sales = account.data?.sales ?? []
  const paidOut = (payouts.data ?? [])
    .filter((p) => p.status === "completed")
    .reduce((s, p) => s + p.amount, 0)

  return (
    <div className="space-y-12">
      <div className="grid gap-4 sm:grid-cols-3">
        <StatTile icon={Wallet} label={t("balance")} value={formatPrice(account.data?.balance ?? 0)} />
        <StatTile
          icon={Receipt}
          label={t("totalSales")}
          value={formatPrice(sales.reduce((s, x) => s + x.amount, 0))}
          hint={t("count", { count: sales.length })}
        />
        <StatTile icon={Banknote} label={t("paidOut")} value={formatPrice(paidOut)} />
      </div>

      <p className="flex gap-3 rounded-2xl bg-cream px-4 py-3 text-sm text-muted-foreground">
        <Info className="mt-0.5 size-4 shrink-0 text-primary" />
        <span>
          {t("payoutNote", { phone: profile?.phoneNumber || t("noPhone") })}{" "}
          <Link href={routes.personalInfo} className="font-semibold text-primary hover:underline">
            {t("updatePhone")}
          </Link>
        </span>
      </p>

      {!account.data && <p className="text-sm text-muted-foreground">{t("noAccount")}</p>}

      <StudioSection title={t("salesTitle")}>
        {sales.length === 0 ? (
          <p className="rounded-3xl border border-dashed border-border bg-white p-6 text-sm text-muted-foreground">
            {t("noSales")}
          </p>
        ) : (
          <div className="overflow-x-auto rounded-3xl border border-border bg-white">
            <table className="w-full min-w-[520px] text-sm">
              <thead className="border-b border-border text-left text-xs text-muted-foreground">
                <tr>
                  <th className="px-5 py-3 font-semibold">{t("date")}</th>
                  <th className="px-5 py-3 font-semibold">{t("course")}</th>
                  <th className="px-5 py-3 font-semibold">{t("method")}</th>
                  <th className="px-5 py-3 text-right font-semibold">{t("amount")}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {sales.map((s, i) => (
                  <tr key={i}>
                    <td className="px-5 py-3 whitespace-nowrap text-muted-foreground">
                      {s.date ? format.dateTime(s.date, { dateStyle: "medium" }) : "—"}
                    </td>
                    <td className="px-5 py-3 font-medium">{s.courseName || "—"}</td>
                    <td className="px-5 py-3 text-muted-foreground">{t("mobileMoney")}</td>
                    <td className="px-5 py-3 text-right font-bold text-success tabular-nums">
                      {formatPrice(s.amount)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </StudioSection>

      <StudioSection title={t("payoutsTitle")}>
        {(payouts.data ?? []).length === 0 ? (
          <p className="rounded-3xl border border-dashed border-border bg-white p-6 text-sm text-muted-foreground">
            {t("noPayouts")}
          </p>
        ) : (
          <ul className="divide-y divide-border rounded-3xl border border-border bg-white">
            {payouts.data!.map((p) => (
              <li key={p.id} className="flex items-center justify-between gap-3 px-5 py-3.5 text-sm">
                <span className="text-muted-foreground">
                  {p.createdAt ? format.dateTime(p.createdAt, { dateStyle: "medium" }) : "—"}
                </span>
                <span className="flex items-center gap-3">
                  <span
                    className={cn(
                      "rounded-full px-2.5 py-0.5 text-[11px] font-bold",
                      p.status === "completed" && "bg-success-tint text-success",
                      p.status === "failed" && "bg-destructive/10 text-destructive",
                      p.status !== "completed" && p.status !== "failed" && "bg-muted text-muted-foreground",
                    )}
                  >
                    {t(`status.${["completed", "failed"].includes(p.status) ? p.status : "pending"}`)}
                  </span>
                  <span className="font-bold tabular-nums">{formatPrice(p.amount)}</span>
                </span>
              </li>
            ))}
          </ul>
        )}
      </StudioSection>
    </div>
  )
}
