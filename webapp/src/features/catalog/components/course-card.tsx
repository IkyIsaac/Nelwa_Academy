"use client"

import { BookOpen, Clock, PlayCircle } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { ViewTransition } from "react"
import { CoverImage } from "@/components/cover-image"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"
import { formatCourseLength, formatPrice } from "../format"
import { type Course, courseTitle } from "../types"
import { RatingBadge } from "./rating"
import { WishlistButton } from "./wishlist-button"

type CardProps = {
  course: Course
  /**
   * Morph the cover into the course page header on click. Only turn this on
   * where the course appears once on the page (view transition names must be unique).
   */
  morph?: boolean
  className?: string
}

/** Learners who own the course go straight to it, like on mobile. */
function useCourseHref(course: Course) {
  const { user } = useAuth()
  const owned = !!user && course.studentIds.includes(user.uid)
  return { owned, href: owned ? routes.learnCourse(course.id) : routes.course(course.id) }
}

function Cover({ course, morph, className }: { course: Course; morph?: boolean; className?: string }) {
  const locale = useLocale()
  const image = (
    <CoverImage src={course.image} alt={courseTitle(course, locale)} className={cn("size-full", className)} />
  )
  return morph ? (
    <ViewTransition name={`course-cover-${course.id}`} share="morph">
      {image}
    </ViewTransition>
  ) : (
    image
  )
}

function Price({ course }: { course: Course }) {
  const t = useTranslations("catalog")
  if (!course.price) return <span className="font-bold text-success">{t("free")}</span>
  return (
    <span className="font-bold text-primary">
      {formatPrice(course.price)}
      <span className="text-xs font-medium text-muted-foreground">{t("perMonth")}</span>
    </span>
  )
}

/** Vertical card used in shelves and grids. */
export function CourseCard({ course, morph, className }: CardProps) {
  const t = useTranslations("catalog")
  const locale = useLocale()
  const { href, owned } = useCourseHref(course)

  return (
    <Link
      href={href}
      className={cn(
        "group flex flex-col overflow-hidden rounded-3xl border border-border bg-card transition-all duration-300 ease-out-expo hover:-translate-y-1.5 hover:border-primary/20 hover:shadow-lift focus-visible:-translate-y-1.5",
        className,
      )}
    >
      <div className="relative aspect-[16/10] overflow-hidden bg-muted">
        <Cover
          course={course}
          morph={morph}
          className="transition-transform duration-700 ease-out-expo group-hover:scale-105"
        />
        <div className="absolute inset-x-3 top-3 flex items-start justify-between gap-2">
          {course.category ? (
            <span className="truncate rounded-full bg-white/90 px-2.5 py-1 text-[11px] font-bold text-primary backdrop-blur">
              {course.category}
            </span>
          ) : (
            <span />
          )}
          <WishlistButton courseId={course.id} />
        </div>
        {owned && (
          <span className="absolute bottom-3 left-3 inline-flex items-center gap-1 rounded-full bg-success px-2.5 py-1 text-[11px] font-bold text-white">
            <PlayCircle className="size-3.5" />
            {t("enrolled")}
          </span>
        )}
      </div>

      <div className="flex flex-1 flex-col p-4">
        <h3 className="line-clamp-2 font-sans text-[15px] leading-snug font-bold group-hover:text-primary">
          {courseTitle(course, locale)}
        </h3>
        {course.instructorName && (
          <p className="mt-1 truncate text-xs text-muted-foreground">{course.instructorName}</p>
        )}
        <div className="mt-3 flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-muted-foreground">
          <RatingBadge rating={course.rating} count={course.reviewsCount} className="text-foreground" />
          {course.totalLessons > 0 && (
            <span className="inline-flex items-center gap-1">
              <BookOpen className="size-3.5" />
              {t("lessonsCount", { count: course.totalLessons })}
            </span>
          )}
          {course.totalSeconds > 0 && (
            <span className="inline-flex items-center gap-1">
              <Clock className="size-3.5" />
              {formatCourseLength(course.totalSeconds)}
            </span>
          )}
        </div>
        <div className="mt-auto pt-4 text-sm">
          <Price course={course} />
        </div>
      </div>
    </Link>
  )
}

/** Horizontal row used in list view and search results. */
export function CourseRow({ course, morph, className }: CardProps) {
  const t = useTranslations("catalog")
  const locale = useLocale()
  const { href } = useCourseHref(course)

  return (
    <Link
      href={href}
      className={cn(
        "group flex gap-4 rounded-3xl border border-border bg-card p-3 transition-all duration-300 hover:border-primary/20 hover:shadow-soft sm:p-4",
        className,
      )}
    >
      <div className="relative aspect-[4/3] w-28 shrink-0 overflow-hidden rounded-2xl bg-muted sm:w-44">
        <Cover
          course={course}
          morph={morph}
          className="transition-transform duration-700 group-hover:scale-105"
        />
      </div>
      <div className="flex min-w-0 flex-1 flex-col py-0.5">
        {course.category && (
          <span className="mb-1 truncate text-[11px] font-bold tracking-wide text-gold uppercase">
            {course.category}
          </span>
        )}
        <h3 className="line-clamp-2 font-sans text-sm leading-snug font-bold group-hover:text-primary sm:text-base">
          {courseTitle(course, locale)}
        </h3>
        <div className="mt-1.5 flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-muted-foreground">
          {course.instructorName && <span className="truncate">{course.instructorName}</span>}
          <RatingBadge rating={course.rating} count={course.reviewsCount} className="text-foreground" />
          {course.totalLessons > 0 && <span>{t("lessonsCount", { count: course.totalLessons })}</span>}
        </div>
        <div className="mt-auto flex items-center justify-between gap-3 pt-2 text-sm">
          <Price course={course} />
          <WishlistButton courseId={course.id} className="size-8 bg-cream shadow-none" />
        </div>
      </div>
    </Link>
  )
}

export function CourseCardSkeleton({ className }: { className?: string }) {
  return (
    <div className={cn("overflow-hidden rounded-3xl border border-border bg-card", className)}>
      <Skeleton className="aspect-[16/10] rounded-none" />
      <div className="space-y-2.5 p-4">
        <Skeleton className="h-4 w-4/5" />
        <Skeleton className="h-3 w-1/2" />
        <Skeleton className="h-3 w-2/3" />
        <Skeleton className="mt-4 h-4 w-1/3" />
      </div>
    </div>
  )
}

export function CourseRowSkeleton() {
  return (
    <div className="flex gap-4 rounded-3xl border border-border p-4">
      <Skeleton className="aspect-[4/3] w-28 rounded-2xl sm:w-44" />
      <div className="flex-1 space-y-2.5">
        <Skeleton className="h-3 w-1/4" />
        <Skeleton className="h-4 w-3/4" />
        <Skeleton className="h-3 w-1/2" />
      </div>
    </div>
  )
}
