"use client"

import { ArrowRight, BookOpen, ChevronLeft, Clock, Globe, SearchX, Users } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { useState } from "react"
import { EmptyState } from "@/components/empty-state"
import { Reveal } from "@/components/motion/reveal"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"
import { formatMinutes, formatRating } from "../format"
import { useCourse, useReviews } from "../hooks"
import { type Course, courseDescription, courseTitle } from "../types"
import { LoadError } from "./discover-views"
import { InstructorSummary } from "./instructor-summary"
import { LessonList } from "./lesson-list"
import { MobilePurchaseBar, PurchasePanel } from "./purchase-panel"
import { Stars } from "./rating"
import { RatingSummary, ReviewCard } from "./reviews"

/** /courses/[id] — everything about one course, and the way in to buy it. */
export function CourseDetail({ id }: { id: string }) {
  const t = useTranslations("catalog.course")
  const course = useCourse(id)
  const { user } = useAuth()

  if (course.isError) {
    return (
      <div className="container-page pt-32 pb-20">
        <LoadError onRetry={() => course.refetch()} />
      </div>
    )
  }
  if (course.isPending) return <CourseDetailSkeleton />
  if (!course.data) {
    return (
      <div className="container-page pt-32 pb-20">
        <EmptyState
          icon={SearchX}
          title={t("notFound")}
          body={t("notFoundBody")}
          action={<Button render={<Link href={routes.explore} />}>{t("browseCourses")}</Button>}
        />
      </div>
    )
  }

  const owned = !!user && course.data.studentIds.includes(user.uid)
  return <CourseLayout course={course.data} owned={owned} />
}

function CourseLayout({ course, owned }: { course: Course; owned: boolean }) {
  const t = useTranslations("catalog.course")
  const locale = useLocale()

  const facts = [
    course.totalLessons > 0 && { icon: BookOpen, label: t("lessonsCount", { count: course.totalLessons }) },
    course.totalMinutes > 0 && { icon: Clock, label: formatMinutes(course.totalMinutes) },
    course.language.name && { icon: Globe, label: course.language.name },
    { icon: Users, label: t("students", { count: course.studentIds.length }) },
  ].filter(Boolean) as { icon: typeof Clock; label: string }[]

  return (
    <div className="pb-28 lg:pb-16">
      {/* Hero */}
      <section className="grid-lines relative overflow-hidden bg-maroon pt-24 pb-12 text-white sm:pt-28 lg:pb-40">
        <div className="pointer-events-none absolute -top-40 -right-40 size-[500px] rounded-full bg-maroon-light/40 blur-3xl" />
        <div className="container-page relative lg:pr-[440px]">
          <Link
            href={routes.explore}
            className="mb-5 inline-flex items-center gap-1 text-sm font-semibold text-white/70 hover:text-white"
          >
            <ChevronLeft className="size-4" />
            {t("backToCourses")}
          </Link>
          <div className="mb-4 flex flex-wrap gap-2">
            {course.category && (
              <Link
                href={routes.category(course.category)}
                className="rounded-full bg-gold px-3 py-1 text-xs font-bold text-white transition-transform hover:scale-105"
              >
                {course.category}
              </Link>
            )}
            {course.level && (
              <span className="rounded-full bg-white/15 px-3 py-1 text-xs font-semibold">{course.level}</span>
            )}
          </div>
          <h1 className="text-3xl leading-tight font-extrabold text-balance sm:text-4xl lg:text-5xl">
            {courseTitle(course, locale)}
          </h1>
          <div className="mt-5 flex flex-wrap items-center gap-x-5 gap-y-2 text-sm text-white/80">
            {course.rating > 0 && (
              <a href="#reviews" className="inline-flex items-center gap-2 hover:text-white">
                <span className="font-bold text-gold">{formatRating(course.rating)}</span>
                <Stars value={course.rating} />
                <span>({t("reviewsCount", { count: course.reviewsCount })})</span>
              </a>
            )}
            {course.instructorName && (
              <span>
                {t("by")}{" "}
                <Link
                  href={routes.instructor(course.instructorId)}
                  className="font-semibold text-white underline-offset-4 hover:underline"
                >
                  {course.instructorName}
                </Link>
              </span>
            )}
          </div>
          <ul className="mt-6 flex flex-wrap gap-2.5">
            {facts.map(({ icon: Icon, label }) => (
              <li
                key={label}
                className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-3.5 py-1.5 text-sm"
              >
                <Icon className="size-4 text-gold" />
                {label}
              </li>
            ))}
          </ul>
        </div>
      </section>

      <div className="container-page relative grid gap-10 lg:grid-cols-[1fr_400px] lg:gap-12">
        {/* Sidebar first in the DOM so phones see the preview straight after the title. */}
        <aside className="-mt-8 lg:col-start-2 lg:row-start-1 lg:-mt-32">
          <div className="lg:sticky lg:top-24">
            <PurchasePanel course={course} owned={owned} />
          </div>
        </aside>

        <div className="min-w-0 space-y-12 lg:col-start-1 lg:row-start-1 lg:pt-12">
          <Section title={t("about")}>
            <Description text={courseDescription(course, locale)} />
          </Section>

          {course.audience.length > 0 && (
            <Section title={t("forWho")}>
              <ul className="grid gap-2.5 sm:grid-cols-2">
                {course.audience.map((a) => (
                  <li
                    key={a}
                    className="flex items-start gap-3 rounded-2xl bg-cream px-4 py-3 text-sm font-medium"
                  >
                    <span className="mt-1.5 size-2 shrink-0 rounded-full bg-gold" />
                    {a}
                  </li>
                ))}
              </ul>
            </Section>
          )}

          <Section title={t("curriculum")} id="lessons">
            <LessonList course={course} owned={owned} />
          </Section>

          <Section title={t("instructor")}>
            <InstructorSummary instructorId={course.instructorId} fallbackName={course.instructorName} />
          </Section>

          <ReviewsPreview course={course} />

          {course.tags.length > 0 && (
            <Section title={t("tags")}>
              <div className="flex flex-wrap gap-2">
                {course.tags.map((tag) => (
                  <Link
                    key={tag}
                    href={routes.tag(tag)}
                    className="rounded-full border border-border px-4 py-2 text-sm font-medium transition-colors hover:border-primary hover:text-primary"
                  >
                    #{tag}
                  </Link>
                ))}
              </div>
            </Section>
          )}
        </div>
      </div>

      <MobilePurchaseBar course={course} owned={owned} />
    </div>
  )
}

function Section({ title, id, children }: { title: string; id?: string; children: React.ReactNode }) {
  return (
    <Reveal y={20}>
      <section id={id} className="scroll-mt-28">
        <h2 className="mb-5 font-sans text-xl font-bold sm:text-2xl">{title}</h2>
        {children}
      </section>
    </Reveal>
  )
}

/** Long descriptions are folded after a few lines, with "Show more". */
function Description({ text }: { text: string }) {
  const t = useTranslations("catalog.course")
  const [open, setOpen] = useState(false)
  const long = text.length > 420

  return (
    <div>
      <p
        className={cn(
          "leading-[1.8] whitespace-pre-line text-muted-foreground",
          long && !open && "line-clamp-5",
        )}
      >
        {text || t("noDescription")}
      </p>
      {long && (
        <button
          type="button"
          onClick={() => setOpen(!open)}
          className="mt-2 text-sm font-semibold text-primary hover:underline"
        >
          {open ? t("showLess") : t("showMore")}
        </button>
      )}
    </div>
  )
}

function ReviewsPreview({ course }: { course: Course }) {
  const t = useTranslations("catalog.course")
  const reviews = useReviews(course.id)

  if (reviews.isPending || reviews.isError || !reviews.data.length) return null

  return (
    <section id="reviews" className="scroll-mt-28">
      <div className="mb-5 flex items-center justify-between gap-4">
        <h2 className="font-sans text-xl font-bold sm:text-2xl">{t("reviews")}</h2>
        <Link
          href={routes.courseReviews(course.id)}
          className="group inline-flex items-center gap-1 text-sm font-semibold text-primary"
        >
          {t("allReviews", { count: reviews.data.length })}
          <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
        </Link>
      </div>
      <RatingSummary reviews={reviews.data} rating={course.rating} />
      <div className="mt-4 space-y-3">
        {reviews.data.slice(0, 3).map((review) => (
          <ReviewCard key={review.id} review={review} courseId={course.id} />
        ))}
      </div>
    </section>
  )
}

function CourseDetailSkeleton() {
  return (
    <div className="pb-16">
      <div className="bg-maroon pt-28 pb-40">
        <div className="container-page space-y-4 lg:pr-[440px]">
          <Skeleton className="h-4 w-32 bg-white/15" />
          <Skeleton className="h-12 w-4/5 bg-white/15" />
          <Skeleton className="h-5 w-1/2 bg-white/15" />
        </div>
      </div>
      <div className="container-page grid gap-12 lg:grid-cols-[1fr_400px]">
        <div className="space-y-4 pt-12">
          <Skeleton className="h-6 w-40" />
          <Skeleton className="h-24 w-full" />
        </div>
        <Skeleton className="-mt-32 hidden h-[480px] rounded-3xl lg:block" />
      </div>
    </div>
  )
}
