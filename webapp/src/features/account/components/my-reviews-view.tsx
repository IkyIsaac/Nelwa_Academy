"use client"

import { useQueries } from "@tanstack/react-query"
import { MessageSquareText } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { CoverImage } from "@/components/cover-image"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { fetchCourse } from "@/features/catalog/api"
import { LoadError } from "@/features/catalog/components/discover-views"
import { Stars } from "@/features/catalog/components/rating"
import { catalogKeys } from "@/features/catalog/hooks"
import { courseTitle } from "@/features/catalog/types"
import { ReviewDialog } from "@/features/learning/components/review-dialog"
import { usePurchases } from "@/features/learning/hooks"
import { useMyReviews } from "../hooks"

/** Courses waiting for a review, then the reviews already posted (as on mobile). */
export function MyReviewsView() {
  const t = useTranslations("account.reviews")
  const locale = useLocale()
  const reviews = useMyReviews()
  const purchases = usePurchases()
  const pending = purchases.data?.filter((p) => !p.reviewed) ?? []
  const pendingCourses = useQueries({
    queries: pending.map((p) => ({
      queryKey: catalogKeys.course(p.courseId),
      queryFn: () => fetchCourse(p.courseId),
      staleTime: 5 * 60 * 1000,
    })),
  })
  const fmt = new Intl.DateTimeFormat(locale, { dateStyle: "medium" })

  if (reviews.isError || purchases.isError)
    return <LoadError onRetry={() => (reviews.refetch(), purchases.refetch())} />
  if (reviews.isPending || purchases.isPending) return <Skeleton className="h-64 rounded-3xl" />

  const toReview = pending
    .map((p, i) => ({ purchase: p, course: pendingCourses[i]?.data }))
    .filter((x) => x.course)

  if (!toReview.length && !reviews.data.length) {
    return (
      <EmptyState
        icon={MessageSquareText}
        title={t("emptyTitle")}
        body={t("emptyBody")}
        action={<Button render={<Link href={routes.learn} />}>{t("myCourses")}</Button>}
      />
    )
  }

  return (
    <div className="space-y-10">
      {toReview.length > 0 && (
        <section>
          <h2 className="mb-4 font-sans text-lg font-bold">{t("pending", { count: toReview.length })}</h2>
          <ul className="space-y-3">
            {toReview.map(({ purchase, course }) => (
              <li
                key={purchase.id}
                className="flex flex-col gap-4 rounded-3xl border border-border bg-white p-4 sm:flex-row sm:items-center"
              >
                <CoverImage src={course!.image} alt="" className="aspect-video w-full rounded-2xl sm:w-32" />
                <div className="min-w-0 flex-1">
                  <p className="line-clamp-2 font-bold">{courseTitle(course!, locale)}</p>
                  <p className="text-xs text-muted-foreground">{course!.instructorName}</p>
                </div>
                <div className="sm:w-48">
                  <ReviewDialog course={course!} purchaseId={purchase.id} />
                </div>
              </li>
            ))}
          </ul>
        </section>
      )}

      {reviews.data.length > 0 && (
        <section>
          <h2 className="mb-4 font-sans text-lg font-bold">{t("posted")}</h2>
          <ul className="space-y-3">
            {reviews.data.map((r) => (
              <li key={r.id} className="rounded-3xl border border-border bg-white p-5">
                <div className="flex gap-4">
                  {r.courseImage && (
                    <CoverImage
                      src={r.courseImage}
                      alt=""
                      className="aspect-square w-14 shrink-0 rounded-xl"
                    />
                  )}
                  <div className="min-w-0 flex-1">
                    <p className="line-clamp-1 font-bold">{r.courseTitle}</p>
                    <div className="mt-1 flex items-center gap-2 text-xs text-muted-foreground">
                      <Stars value={r.rating} />
                      <span className="sr-only">{t("stars", { count: r.rating })}</span>
                      {r.at && <span>{fmt.format(r.at)}</span>}
                    </div>
                  </div>
                </div>
                {r.comment && (
                  <p className="mt-3 text-sm leading-relaxed text-muted-foreground">{r.comment}</p>
                )}
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  )
}
