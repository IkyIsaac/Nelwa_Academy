"use client"

import { Check, ExternalLink, Loader2, Mail, SearchX, Smartphone, X } from "lucide-react"
import { motion } from "motion/react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { EmptyState } from "@/components/empty-state"
import { PageHeader } from "@/components/layout/page-header"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { LoadError } from "@/features/catalog/components/discover-views"
import { useOrder } from "../hooks"
import type { Order } from "../types"
import { OrderSummary } from "./order-summary"

export function OrderStatusView({ orderId }: { orderId: string }) {
  const t = useTranslations("checkout")
  const state = useOrder(orderId)

  if (state.status === "loading") {
    return (
      <div className="grid min-h-[70dvh] place-items-center">
        <Loader2 className="size-7 animate-spin text-primary" aria-label={t("loading")} />
      </div>
    )
  }
  if (state.status === "error") {
    return (
      <div className="container-page pt-32 pb-16">
        <LoadError onRetry={() => window.location.reload()} />
      </div>
    )
  }
  if (state.status === "missing") {
    return (
      <div className="container-page pt-32 pb-16">
        <EmptyState
          icon={SearchX}
          title={t("orderNotFound")}
          body={t("orderNotFoundBody")}
          action={<Button render={<Link href={routes.explore} />}>{t("browse")}</Button>}
        />
      </div>
    )
  }

  const { order } = state
  return (
    <>
      <PageHeader
        title={t("orderTitle")}
        eyebrow={t("orderRef", { id: order.id.slice(0, 8).toUpperCase() })}
      />
      <div className="container-page grid items-start gap-8 py-10 lg:grid-cols-[1fr_380px]">
        <motion.section
          key={order.status}
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          className="rounded-3xl border border-border bg-white p-6 text-center sm:p-10"
          aria-live="polite"
        >
          {order.status === "pending" ? (
            <Pending order={order} />
          ) : order.status === "completed" ? (
            <Completed order={order} />
          ) : (
            <Failed order={order} />
          )}
        </motion.section>
        <OrderSummary
          lines={order.items.map((i) => ({ title: i.title, price: i.price }))}
          total={order.amount}
        />
      </div>
    </>
  )
}

function StatusIcon({ children, className }: { children: React.ReactNode; className: string }) {
  return (
    <motion.span
      initial={{ scale: 0.4, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ type: "spring", damping: 12, stiffness: 180 }}
      className={`relative mx-auto mb-6 grid size-20 place-items-center rounded-full ${className}`}
    >
      {children}
    </motion.span>
  )
}

function Pending({ order }: { order: Order }) {
  const t = useTranslations("checkout")
  return (
    <>
      <StatusIcon className="bg-maroon-tint text-primary">
        <span className="absolute inset-0 animate-ping rounded-full bg-maroon-tint [animation-duration:2.2s]" />
        <Smartphone className="relative size-8" />
      </StatusIcon>
      <h2 className="font-sans text-2xl font-extrabold">{t("pendingTitle")}</h2>
      <p className="mx-auto mt-2 max-w-md text-sm leading-relaxed text-muted-foreground">
        {t("pendingBody")}
      </p>
      <p className="mt-6 inline-flex items-center gap-2 text-xs font-semibold text-muted-foreground">
        <Loader2 className="size-3.5 animate-spin" />
        {t("pendingWatching")}
      </p>
      <div className="mt-8 flex flex-col justify-center gap-3 sm:flex-row">
        {order.checkoutUrl && (
          <Button render={<a href={order.checkoutUrl} target="_blank" rel="noopener noreferrer" />}>
            <ExternalLink />
            {t("openPayment")}
          </Button>
        )}
        {order.items[0] && (
          <Button variant="outline" render={<Link href={routes.course(order.items[0].courseId)} />}>
            {t("backToCourse")}
          </Button>
        )}
      </div>
    </>
  )
}

function Completed({ order }: { order: Order }) {
  const t = useTranslations("checkout")
  const first = order.items[0]
  return (
    <>
      <StatusIcon className="bg-success-tint text-success">
        <Check className="size-9" strokeWidth={3} />
      </StatusIcon>
      <h2 className="font-sans text-2xl font-extrabold">{t("successTitle")}</h2>
      <p className="mx-auto mt-2 max-w-md text-sm leading-relaxed text-muted-foreground">
        {t("successBody", { course: first?.title ?? "" })}
      </p>
      <p className="mt-4 inline-flex items-center gap-2 text-xs text-muted-foreground">
        <Mail className="size-3.5" />
        {t("receiptSent")}
      </p>
      <div className="mt-8 flex flex-col justify-center gap-3 sm:flex-row">
        {first && (
          <Button render={<Link href={routes.learnCourse(first.courseId)} />}>{t("startLearning")}</Button>
        )}
        <Button variant="outline" render={<Link href={routes.explore} />}>
          {t("browse")}
        </Button>
      </div>
    </>
  )
}

function Failed({ order }: { order: Order }) {
  const t = useTranslations("checkout")
  const first = order.items[0]
  const reason = order.status === "expired" ? "expired" : order.status === "voided" ? "cancelled" : "failed"
  return (
    <>
      <StatusIcon className="bg-maroon-tint text-primary">
        <X className="size-9" strokeWidth={3} />
      </StatusIcon>
      <h2 className="font-sans text-2xl font-extrabold">{t(`${reason}Title`)}</h2>
      <p className="mx-auto mt-2 max-w-md text-sm leading-relaxed text-muted-foreground">
        {t("notChargedBody")}
      </p>
      <div className="mt-8 flex flex-col justify-center gap-3 sm:flex-row">
        {first && <Button render={<Link href={routes.checkout(first.courseId)} />}>{t("tryAgain")}</Button>}
        {first && (
          <Button variant="outline" render={<Link href={routes.course(first.courseId)} />}>
            {t("backToCourse")}
          </Button>
        )}
      </div>
    </>
  )
}
