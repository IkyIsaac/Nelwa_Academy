"use client"

import { BadgeCheck, Gift, Loader2, Lock, SearchX, ShieldCheck, Smartphone } from "lucide-react"
import { motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useState } from "react"
import { EmptyState } from "@/components/empty-state"
import { PageHeader } from "@/components/layout/page-header"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { LoadError } from "@/features/catalog/components/discover-views"
import { useCourse } from "@/features/catalog/hooks"
import { courseTitle } from "@/features/catalog/types"
import { checkoutError, startCheckout } from "../api"
import { usePurchased } from "../hooks"
import type { CheckoutError } from "../types"
import { OrderSummary } from "./order-summary"

const NETWORKS = ["M-Pesa", "Airtel Money", "Mixx by Yas", "Halotel"]

export function CheckoutView({ courseId }: { courseId: string }) {
  const t = useTranslations("checkout")
  const locale = useLocale()
  const router = useRouter()
  const { user } = useAuth()
  const course = useCourse(courseId)
  const purchased = usePurchased(courseId)
  const [paying, setPaying] = useState(false)
  const [error, setError] = useState<CheckoutError | null>(null)

  const back = { href: routes.course(courseId), label: t("backToCourse") }

  if (course.isPending || purchased.isPending) {
    return (
      <>
        <PageHeader title={t("title")} back={back} />
        <div className="container-page grid gap-8 py-10 lg:grid-cols-[1fr_380px]">
          <Skeleton className="h-80 rounded-3xl" />
          <Skeleton className="h-64 rounded-3xl" />
        </div>
      </>
    )
  }
  if (course.isError) {
    return (
      <div className="container-page pt-32 pb-16">
        <LoadError onRetry={() => course.refetch()} />
      </div>
    )
  }
  if (!course.data) {
    return (
      <div className="container-page pt-32 pb-16">
        <EmptyState
          icon={SearchX}
          title={t("notFound")}
          action={<Button render={<Link href={routes.explore} />}>{t("browse")}</Button>}
        />
      </div>
    )
  }

  const c = course.data
  const title = courseTitle(c, locale)
  const owned = purchased.data || (!!user && c.studentIds.includes(user.uid)) || error === "owned"

  if (owned || c.price <= 0) {
    return (
      <>
        <PageHeader title={t("title")} back={back} />
        <div className="container-page py-10">
          {owned ? (
            <EmptyState
              icon={BadgeCheck}
              title={t("alreadyOwned")}
              body={t("alreadyOwnedBody", { course: title })}
              action={<Button render={<Link href={routes.course(c.id)} />}>{t("goToCourse")}</Button>}
            />
          ) : (
            <EmptyState
              icon={Gift}
              title={t("freeCourse")}
              body={t("freeCourseBody")}
              action={
                <Button render={<Link href={`${routes.course(c.id)}#lessons`} />}>{t("seeLessons")}</Button>
              }
            />
          )}
        </div>
      </>
    )
  }

  const pay = async () => {
    setError(null)
    setPaying(true)
    // Open the payment tab now, while we still have the click: browsers
    // block tabs opened after an `await`. It's pointed at Snippe below.
    const tab = window.open("", "_blank")
    if (tab) {
      tab.opener = null
      tab.document.title = t("openingTitle")
      tab.document.body.textContent = t("openingTitle")
      tab.document.body.style.cssText = "font:16px system-ui;padding:2rem;color:#5d0a0b"
    }
    try {
      const { orderId, checkoutUrl } = await startCheckout(c.id)
      if (tab) {
        tab.location.href = checkoutUrl
        router.push(routes.orderStatus(orderId))
      } else {
        // Popup blocked: pay in this tab. Snippe sends the buyer back to the order page.
        window.location.assign(checkoutUrl)
      }
    } catch (e) {
      tab?.close()
      setError(checkoutError(e))
      setPaying(false)
    }
  }

  return (
    <>
      <PageHeader title={t("title")} description={t("subtitle")} back={back} />
      <div className="container-page grid items-start gap-8 py-10 lg:grid-cols-[1fr_380px]">
        <motion.section
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          className="order-2 rounded-3xl border border-border bg-white p-5 sm:p-8 lg:order-1"
        >
          <h2 className="flex items-center gap-2 font-sans text-lg font-bold">
            <Smartphone className="size-5 text-primary" />
            {t("method")}
          </h2>
          <p className="mt-1 text-sm text-muted-foreground">{t("methodBody")}</p>
          <ul className="mt-4 flex flex-wrap gap-2">
            {NETWORKS.map((n) => (
              <li
                key={n}
                className="rounded-full border border-border bg-cream px-3 py-1 text-xs font-semibold"
              >
                {n}
              </li>
            ))}
          </ul>

          <ol className="mt-8 space-y-4">
            {(["step1", "step2", "step3"] as const).map((step, i) => (
              <li key={step} className="flex gap-3">
                <span className="grid size-7 shrink-0 place-items-center rounded-full bg-maroon-tint text-sm font-bold text-primary">
                  {i + 1}
                </span>
                <p className="pt-0.5 text-sm leading-relaxed">{t(step)}</p>
              </li>
            ))}
          </ol>

          {error && (
            <p
              role="alert"
              className="mt-6 rounded-2xl bg-maroon-tint px-4 py-3 text-sm font-medium text-primary"
            >
              {t(`errors.${error}`)}
            </p>
          )}

          <Button size="lg" className="mt-8 w-full sm:w-auto" onClick={pay} disabled={paying}>
            {paying ? <Loader2 className="animate-spin" /> : <Lock />}
            {paying ? t("starting") : t("pay", { amount: c.price.toLocaleString("en-US") })}
          </Button>
          <p className="mt-4 flex items-center gap-1.5 text-xs text-muted-foreground">
            <ShieldCheck className="size-4 text-success" />
            {t("secure")}
          </p>
        </motion.section>

        <motion.aside
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.08 }}
          className="order-1 lg:sticky lg:top-28 lg:order-2"
        >
          <OrderSummary
            lines={[
              {
                title,
                price: c.price,
                image: c.image,
                subtitle: `${c.instructorName} · ${t("monthlyPlan")}`,
              },
            ]}
            total={c.price}
          />
          <p className="mt-3 px-2 text-xs leading-relaxed text-muted-foreground">{t("accessNote")}</p>
        </motion.aside>
      </div>
    </>
  )
}
