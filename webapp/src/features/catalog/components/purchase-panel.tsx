"use client"

import { Check, Play, PlayCircle, Share2 } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { ViewTransition, useState } from "react"
import { toast } from "sonner"
import { CoverImage } from "@/components/cover-image"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"
import { recordPreviewView } from "../api"
import { formatPrice } from "../format"
import { type Course, courseTitle } from "../types"
import { WishlistButton } from "./wishlist-button"

export type Plan = "monthly" | "yearly"

/**
 * Where "Enroll" goes: checkout for paid courses, the free lessons for free
 * ones (there's nothing to buy, as on mobile), via sign-in for visitors.
 */
export function useEnrollHref(course: Course) {
  const { status } = useAuth()
  const target = course.price > 0 ? routes.checkout(course.id) : `${routes.course(course.id)}#lessons`
  return status === "signed-in" ? target : `${routes.signIn}?next=${encodeURIComponent(target)}`
}

/** Cover image that turns into the preview video when played. */
export function CoursePreview({ course }: { course: Course }) {
  const t = useTranslations("catalog.course")
  const locale = useLocale()
  const { user } = useAuth()
  const [playing, setPlaying] = useState(false)

  const play = () => {
    setPlaying(true)
    // An admin statistic; failure doesn't matter to the learner.
    if (user) recordPreviewView(course.id, user.uid).catch(() => {})
  }

  return (
    <div className="relative aspect-video overflow-hidden rounded-2xl bg-maroon-dark">
      {playing ? (
        <video
          src={course.previewVideo}
          poster={course.image}
          controls
          autoPlay
          playsInline
          className="size-full"
        />
      ) : (
        <>
          <ViewTransition name={`course-cover-${course.id}`} share="morph">
            <CoverImage src={course.image} alt={courseTitle(course, locale)} priority className="size-full" />
          </ViewTransition>
          {course.previewVideo && (
            <button
              type="button"
              onClick={play}
              className="group absolute inset-0 grid place-items-center bg-maroon-dark/25 transition-colors hover:bg-maroon-dark/40"
            >
              <span className="flex flex-col items-center gap-2 text-white">
                <span className="relative grid size-16 place-items-center rounded-full bg-white text-primary shadow-lift transition-transform group-hover:scale-110">
                  <span className="absolute inset-0 animate-ping rounded-full bg-white/40 [animation-duration:2s]" />
                  <Play className="relative ml-1 size-6" fill="currentColor" />
                </span>
                <span className="text-sm font-semibold drop-shadow">{t("watchPreview")}</span>
              </span>
            </button>
          )}
        </>
      )}
    </div>
  )
}

async function share(title: string, copied: string) {
  const url = window.location.href
  if (navigator.share) {
    await navigator.share({ title, url }).catch(() => {})
  } else {
    await navigator.clipboard.writeText(url)
    toast.success(copied)
  }
}

/** Price options and the call to action. Shown in the sidebar on desktop. */
export function PurchasePanel({ course, owned }: { course: Course; owned: boolean }) {
  const t = useTranslations("catalog.course")
  const locale = useLocale()
  const [plan, setPlan] = useState<Plan>("monthly")
  const enrollHref = useEnrollHref(course)
  // Checkout charges the monthly price only (createOrder has no yearly
  // pricing yet, same as the mobile app), so yearly is shown but disabled.
  const plans = (
    [
      { id: "monthly", price: course.price, label: t("monthly"), suffix: t("perMonth"), soon: false },
      { id: "yearly", price: course.yearPrice, label: t("yearly"), suffix: t("perYear"), soon: true },
    ] as const
  ).filter((p) => p.price > 0)

  const yearlySaving =
    course.price > 0 && course.yearPrice > 0
      ? Math.round((1 - course.yearPrice / (course.price * 12)) * 100)
      : 0

  return (
    <div className="rounded-3xl border border-border bg-white p-4 shadow-lift sm:p-5">
      <CoursePreview course={course} />

      <div className="mt-5">
        {owned ? (
          <div className="space-y-3">
            <p className="flex items-center gap-2 rounded-2xl bg-success-tint px-4 py-3 text-sm font-semibold text-success">
              <Check className="size-4" />
              {t("youOwnThis")}
            </p>
            <Button size="lg" className="w-full" render={<Link href={routes.learnCourse(course.id)} />}>
              <PlayCircle />
              {t("continueLearning")}
            </Button>
          </div>
        ) : plans.length === 0 ? (
          <Button size="lg" className="w-full" render={<Link href={enrollHref} />}>
            {t("enrollFree")}
          </Button>
        ) : (
          <>
            <p className="mb-3 text-sm font-bold">{t("selectPackage")}</p>
            <div role="radiogroup" aria-label={t("selectPackage")} className="space-y-2.5">
              {plans.map((p) => (
                <button
                  key={p.id}
                  type="button"
                  role="radio"
                  aria-checked={plan === p.id}
                  disabled={p.soon}
                  onClick={() => setPlan(p.id)}
                  className={cn(
                    "relative flex w-full items-center gap-3 rounded-2xl border-[1.5px] px-4 py-3.5 text-left transition-all",
                    plan === p.id ? "border-primary bg-maroon-tint" : "border-border hover:border-primary/40",
                    p.soon && "cursor-not-allowed opacity-60 hover:border-border",
                  )}
                >
                  <span
                    className={cn(
                      "grid size-5 shrink-0 place-items-center rounded-full border-2",
                      plan === p.id ? "border-primary" : "border-border",
                    )}
                  >
                    <AnimatePresence>
                      {plan === p.id && (
                        <motion.span
                          initial={{ scale: 0 }}
                          animate={{ scale: 1 }}
                          exit={{ scale: 0 }}
                          className="size-2.5 rounded-full bg-primary"
                        />
                      )}
                    </AnimatePresence>
                  </span>
                  <span className="flex-1">
                    <span className="block text-sm font-semibold">
                      {p.label}
                      {p.soon && (
                        <span className="ml-1.5 text-xs font-medium text-muted-foreground">
                          · {t("comingSoon")}
                        </span>
                      )}
                    </span>
                    <span className="text-lg font-extrabold text-primary">
                      {formatPrice(p.price)}
                      <span className="text-xs font-medium text-muted-foreground">{p.suffix}</span>
                    </span>
                  </span>
                  {p.id === "yearly" && yearlySaving > 0 && (
                    <span className="rounded-full bg-gold px-2.5 py-1 text-[11px] font-bold text-white">
                      {t("save", { percent: yearlySaving })}
                    </span>
                  )}
                </button>
              ))}
            </div>
            <Button size="lg" className="mt-4 w-full" render={<Link href={enrollHref} />}>
              {t("enrollNow")}
            </Button>
          </>
        )}

        <div className="mt-3 flex gap-2">
          <Button
            variant="outline"
            className="flex-1"
            onClick={() => share(courseTitle(course, locale), t("linkCopied"))}
          >
            <Share2 />
            {t("share")}
          </Button>
          <WishlistButton
            courseId={course.id}
            className="size-11 border border-border bg-white shadow-none"
          />
        </div>
      </div>
    </div>
  )
}

/** Phones: price and Enroll pinned to the bottom of the screen. */
export function MobilePurchaseBar({ course, owned }: { course: Course; owned: boolean }) {
  const t = useTranslations("catalog.course")
  const enrollHref = useEnrollHref(course)
  const { status } = useAuth()

  return (
    <motion.div
      initial={{ y: 100 }}
      animate={{ y: 0 }}
      transition={{ delay: 0.4, type: "spring", damping: 26 }}
      className={cn(
        "fixed inset-x-0 z-40 border-t border-border bg-white/95 px-4 py-3 backdrop-blur-xl lg:hidden",
        // Learners also have the bottom tab bar on phones.
        status === "signed-in"
          ? "bottom-[5.5rem] md:bottom-0"
          : "bottom-0 pb-[max(0.75rem,env(safe-area-inset-bottom))]",
      )}
    >
      <div className="flex items-center gap-3">
        {owned ? (
          <Button className="flex-1" render={<Link href={routes.learnCourse(course.id)} />}>
            <PlayCircle />
            {t("continueLearning")}
          </Button>
        ) : (
          <>
            <div className="min-w-0 flex-1">
              <p className="text-xs text-muted-foreground">{course.price ? t("from") : ""}</p>
              <p className="truncate text-lg font-extrabold text-primary">
                {course.price ? formatPrice(course.price) : t("free")}
                {course.price > 0 && (
                  <span className="text-xs font-medium text-muted-foreground">{t("perMonth")}</span>
                )}
              </p>
            </div>
            <Button render={<Link href={enrollHref} />}>
              {course.price ? t("enrollNow") : t("enrollFree")}
            </Button>
          </>
        )}
      </div>
    </motion.div>
  )
}
