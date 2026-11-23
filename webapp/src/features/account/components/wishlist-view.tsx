"use client"

import { Heart } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { CourseCard, CourseCardSkeleton } from "@/features/catalog/components/course-card"
import { LoadError } from "@/features/catalog/components/discover-views"
import { useCourses } from "@/features/catalog/hooks"
import { useWishlist } from "@/features/catalog/wishlist"

/** Saved courses (kept in this browser, as mobile keeps them on the phone). */
export function WishlistView() {
  const t = useTranslations("account.wishlist")
  const ids = useWishlist((s) => s.courseIds)
  const courses = useCourses()

  if (courses.isError) return <LoadError onRetry={() => courses.refetch()} />
  if (courses.isPending) {
    return (
      <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 3 }, (_, i) => (
          <CourseCardSkeleton key={i} />
        ))}
      </div>
    )
  }
  // Keep the order they were saved in; skip courses that were unpublished.
  const saved = ids.map((id) => courses.data.find((c) => c.id === id)).filter((c) => c !== undefined)
  if (!saved.length) {
    return (
      <EmptyState
        icon={Heart}
        title={t("emptyTitle")}
        body={t("emptyBody")}
        action={<Button render={<Link href={routes.explore} />}>{t("browse")}</Button>}
      />
    )
  }
  return (
    <>
      <p className="mb-5 text-sm text-muted-foreground">{t("deviceNote")}</p>
      <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
        {saved.map((course) => (
          <CourseCard key={course.id} course={course} />
        ))}
      </div>
    </>
  )
}
