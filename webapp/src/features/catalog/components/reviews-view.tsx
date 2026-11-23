"use client"

import { Star } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import { useState } from "react"
import { PageHeader } from "@/components/layout/page-header"
import { routes } from "@/config/site"
import { cn } from "@/lib/utils"
import { useCourse, useReviews } from "../hooks"
import { courseTitle } from "../types"
import { LoadError } from "./discover-views"
import { RatingSummary, ReviewList } from "./reviews"

/** /courses/[id]/reviews — every review, filterable by star rating. */
export function ReviewsView({ courseId }: { courseId: string }) {
  const t = useTranslations("catalog.reviews")
  const locale = useLocale()
  const course = useCourse(courseId)
  const reviews = useReviews(courseId)
  const [stars, setStars] = useState(0)

  const shown = stars ? reviews.data?.filter((r) => Math.round(r.rating) === stars) : reviews.data

  return (
    <>
      <PageHeader
        back={{
          href: routes.course(courseId),
          label: course.data ? courseTitle(course.data, locale) : t("backToCourse"),
        }}
        title={t("title")}
      />
      <div className="container-page max-w-3xl py-10">
        {reviews.isError ? (
          <LoadError onRetry={() => reviews.refetch()} />
        ) : (
          <>
            {!!reviews.data?.length && (
              <RatingSummary reviews={reviews.data} rating={course.data?.rating ?? 0} />
            )}

            <div className="my-6 flex flex-wrap gap-2" role="group" aria-label={t("filter")}>
              {[0, 5, 4, 3, 2, 1].map((n) => (
                <button
                  key={n}
                  type="button"
                  aria-pressed={stars === n}
                  onClick={() => setStars(n)}
                  className={cn(
                    "inline-flex items-center gap-1 rounded-full border px-4 py-2 text-sm font-semibold transition-colors",
                    stars === n
                      ? "border-primary bg-primary text-primary-foreground"
                      : "border-border bg-white hover:border-primary/40",
                  )}
                >
                  {n === 0 ? (
                    t("all")
                  ) : (
                    <>
                      <Star className="size-3.5 text-gold" fill="currentColor" strokeWidth={0} />
                      {n}
                    </>
                  )}
                </button>
              ))}
            </div>

            <ReviewList reviews={shown} courseId={courseId} loading={reviews.isPending} />
          </>
        )}
      </div>
    </>
  )
}
