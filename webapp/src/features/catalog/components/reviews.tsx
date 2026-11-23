"use client"

import { MessageSquareText, ThumbsDown, ThumbsUp } from "lucide-react"
import { motion } from "motion/react"
import { useFormatter, useTranslations } from "next-intl"
import { EmptyState } from "@/components/empty-state"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Skeleton } from "@/components/ui/skeleton"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn, initials } from "@/lib/utils"
import { formatRating } from "../format"
import { useReviewReaction } from "../hooks"
import type { Review } from "../types"
import { Stars } from "./rating"

/** Average score with a bar per star level, like the mobile reviews header. */
export function RatingSummary({ reviews, rating }: { reviews: Review[]; rating: number }) {
  const t = useTranslations("catalog.reviews")
  const average = rating || (reviews.length ? reviews.reduce((s, r) => s + r.rating, 0) / reviews.length : 0)

  return (
    <div className="flex flex-col gap-6 rounded-3xl bg-cream p-6 sm:flex-row sm:items-center">
      <div className="text-center sm:w-36">
        <p className="font-display text-5xl font-extrabold text-primary">{formatRating(average)}</p>
        <Stars value={average} className="mt-2 text-lg" />
        <p className="mt-1 text-xs text-muted-foreground">{t("count", { count: reviews.length })}</p>
      </div>
      <div className="flex-1 space-y-1.5">
        {[5, 4, 3, 2, 1].map((star) => {
          const n = reviews.filter((r) => Math.round(r.rating) === star).length
          const share = reviews.length ? n / reviews.length : 0
          return (
            <div key={star} className="flex items-center gap-3 text-xs">
              <span className="w-3 font-semibold">{star}</span>
              <div className="h-2 flex-1 overflow-hidden rounded-full bg-white">
                <motion.div
                  className="h-full rounded-full bg-gold"
                  initial={{ width: 0 }}
                  whileInView={{ width: `${share * 100}%` }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
                />
              </div>
              <span className="w-6 text-right text-muted-foreground">{n}</span>
            </div>
          )
        })}
      </div>
    </div>
  )
}

export function ReviewCard({ review, courseId }: { review: Review; courseId: string }) {
  const t = useTranslations("catalog.reviews")
  const format = useFormatter()
  const { user } = useAuth()
  const react = useReviewReaction(courseId)
  const liked = !!user && review.likedBy.includes(user.uid)
  const disliked = !!user && review.dislikedBy.includes(user.uid)

  const reactionButton = (kind: "like" | "dislike") => {
    const active = kind === "like" ? liked : disliked
    const Icon = kind === "like" ? ThumbsUp : ThumbsDown
    const count = kind === "like" ? review.likedBy.length : review.dislikedBy.length
    return (
      <button
        type="button"
        disabled={!user}
        aria-pressed={active}
        aria-label={t(kind === "like" ? "helpful" : "notHelpful")}
        title={user ? undefined : t("signInToReact")}
        onClick={() => react.mutate({ reviewId: review.id, reaction: active ? null : kind })}
        className={cn(
          "inline-flex items-center gap-1.5 rounded-full px-3 py-1.5 text-xs font-semibold transition-colors disabled:cursor-default",
          active
            ? "bg-primary text-primary-foreground"
            : "bg-muted text-muted-foreground enabled:hover:text-primary",
        )}
      >
        <Icon className="size-3.5" fill={active ? "currentColor" : "none"} />
        {count}
      </button>
    )
  }

  return (
    <article className="rounded-3xl border border-border bg-white p-5">
      <header className="flex items-center gap-3">
        <Avatar className="size-10">
          <AvatarImage src={review.userImage || undefined} alt="" />
          <AvatarFallback className="bg-maroon-tint text-xs font-bold text-primary">
            {initials(review.userName || "?")}
          </AvatarFallback>
        </Avatar>
        <div className="min-w-0 flex-1">
          <p className="truncate text-sm font-bold">{review.userName || t("anonymous")}</p>
          {review.createdAt && (
            <p className="text-xs text-muted-foreground">
              {format.relativeTime(review.createdAt, new Date())}
            </p>
          )}
        </div>
        <Stars value={review.rating} className="text-sm" />
      </header>
      {review.comment && <p className="mt-3 text-sm leading-relaxed whitespace-pre-line">{review.comment}</p>}
      <footer className="mt-4 flex gap-2">
        {reactionButton("like")}
        {reactionButton("dislike")}
      </footer>
    </article>
  )
}

export function ReviewList({
  reviews,
  courseId,
  loading,
}: {
  reviews?: Review[]
  courseId: string
  loading?: boolean
}) {
  const t = useTranslations("catalog.reviews")
  if (loading) {
    return (
      <div className="space-y-3">
        {Array.from({ length: 3 }, (_, i) => (
          <Skeleton key={i} className="h-32 rounded-3xl" />
        ))}
      </div>
    )
  }
  if (!reviews?.length)
    return <EmptyState icon={MessageSquareText} title={t("empty")} body={t("emptyBody")} />
  return (
    <div className="space-y-3">
      {reviews.map((review) => (
        <ReviewCard key={review.id} review={review} courseId={courseId} />
      ))}
    </div>
  )
}
