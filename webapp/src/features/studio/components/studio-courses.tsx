"use client"

import { BookOpen, ExternalLink, Pencil, Plus, Star, Users } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { CoverImage } from "@/components/cover-image"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { formatCourseLength, formatPrice } from "@/features/catalog/format"
import { LoadError } from "@/features/catalog/components/discover-views"
import { courseTitle } from "@/features/catalog/types"
import { useMyCourses } from "../hooks"
import { PublishToggle } from "./publish-toggle"
import { StudioSection } from "./studio-shell"

export function StudioCourses() {
  const t = useTranslations("studio.courses")
  const locale = useLocale()
  const courses = useMyCourses()

  const newButton = (
    <Button render={<Link href={routes.studioNewCourse} />}>
      <Plus /> {t("new")}
    </Button>
  )

  if (courses.isError) return <LoadError onRetry={() => courses.refetch()} />
  if (courses.isPending) {
    return (
      <div className="space-y-3">
        {Array.from({ length: 3 }, (_, i) => (
          <Skeleton key={i} className="h-32 rounded-3xl" />
        ))}
      </div>
    )
  }
  if (courses.data.length === 0) {
    return <EmptyState icon={BookOpen} title={t("emptyTitle")} body={t("emptyBody")} action={newButton} />
  }

  return (
    <StudioSection title={t("title", { count: courses.data.length })} action={newButton}>
      <ul className="space-y-3">
        {courses.data.map((c) => (
          <li
            key={c.id}
            className="flex flex-col gap-4 rounded-3xl border border-border bg-white p-4 sm:flex-row sm:items-center"
          >
            <CoverImage src={c.image} alt="" className="aspect-video w-full shrink-0 rounded-2xl sm:w-44" />
            <div className="min-w-0 flex-1">
              <div className="flex flex-wrap items-center gap-2">
                <span
                  className={
                    c.isPublished
                      ? "rounded-full bg-success-tint px-2.5 py-0.5 text-[11px] font-bold text-success"
                      : "rounded-full bg-muted px-2.5 py-0.5 text-[11px] font-bold text-muted-foreground"
                  }
                >
                  {c.isPublished ? t("published") : t("draft")}
                </span>
                <span className="text-xs text-muted-foreground">{c.category}</span>
              </div>
              <p className="mt-1.5 line-clamp-1 font-bold">{courseTitle(c, locale) || t("untitled")}</p>
              <p className="mt-1 flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground">
                <span className="font-semibold text-primary">
                  {c.price > 0 ? formatPrice(c.price) : t("free")}
                </span>
                <span className="inline-flex items-center gap-1">
                  <BookOpen className="size-3.5" />
                  {t("lessons", { count: c.totalLessons })}
                  {c.totalSeconds > 0 && ` · ${formatCourseLength(c.totalSeconds)}`}
                </span>
                <span className="inline-flex items-center gap-1">
                  <Users className="size-3.5" /> {t("students", { count: c.studentIds.length })}
                </span>
                {c.reviewsCount > 0 && (
                  <span className="inline-flex items-center gap-1">
                    <Star className="size-3.5" /> {c.rating.toFixed(1)} ({c.reviewsCount})
                  </span>
                )}
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-2 sm:flex-col sm:items-end">
              <PublishToggle course={c} />
              <div className="flex gap-2">
                <Button size="sm" variant="outline" render={<Link href={routes.course(c.id)} />}>
                  <ExternalLink /> {t("view")}
                </Button>
                <Button size="sm" render={<Link href={routes.studioCourse(c.id)} />}>
                  <Pencil /> {t("edit")}
                </Button>
              </div>
            </div>
          </li>
        ))}
      </ul>
    </StudioSection>
  )
}
