"use client"

import {
  CheckCircle2,
  ChevronLeft,
  ChevronRight,
  Clock,
  Lock,
  PlayCircle,
  ReceiptText,
  SearchX,
  Star,
} from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { parseAsString, useQueryState } from "nuqs"
import { useEffect, useMemo, useRef } from "react"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { LoadError } from "@/features/catalog/components/discover-views"
import { formatSeconds } from "@/features/catalog/format"
import { useCourse, useLessons } from "@/features/catalog/hooks"
import { type Course, type Lesson, courseTitle, lessonTitle } from "@/features/catalog/types"
import { cn } from "@/lib/utils"
import { useCourseAccess, useMarkWatched, useRefundRequest } from "../hooks"
import { ReviewDialog } from "./review-dialog"

const lessonDescription = (l: Lesson, locale: string) =>
  locale === "sw" && l.descriptionSw ? l.descriptionSw : l.description

export function CoursePlayer({ courseId }: { courseId: string }) {
  const t = useTranslations("learning")
  const course = useCourse(courseId)
  const lessons = useLessons(courseId)

  if (course.isPending || lessons.isPending) return <PlayerSkeleton />
  if (course.isError || lessons.isError) {
    return (
      <div className="container-page pt-32 pb-16">
        <LoadError onRetry={() => (course.refetch(), lessons.refetch())} />
      </div>
    )
  }
  if (!course.data) {
    return (
      <div className="container-page pt-32 pb-16">
        <EmptyState
          icon={SearchX}
          title={t("courseNotFound")}
          action={<Button render={<Link href={routes.learn} />}>{t("myCourses")}</Button>}
        />
      </div>
    )
  }
  return <Player course={course.data} lessons={lessons.data ?? []} />
}

function Player({ course, lessons }: { course: Course; lessons: Lesson[] }) {
  const t = useTranslations("learning")
  const locale = useLocale()
  const { profile } = useAuth()
  const access = useCourseAccess(course)
  const markWatched = useMarkWatched(course.id)
  const [lessonParam, setLessonParam] = useQueryState("lesson", parseAsString.withOptions({ scroll: true }))

  const watched = useMemo(() => {
    const fromProfile =
      profile?.continueWatching.find((c) => c.courseId === course.id)?.completedLessonIds ?? []
    return new Set([...(access.purchase?.watchedLessonIds ?? []), ...fromProfile])
  }, [profile, access.purchase, course.id])

  // The requested lesson, else the first unwatched one the learner can open.
  const current =
    lessons.find((l) => l.id === lessonParam) ??
    lessons.find((l) => access.canWatch(l) && !watched.has(l.id)) ??
    lessons[0]
  const index = current ? lessons.indexOf(current) : -1
  const unlocked = !!current && access.canWatch(current)

  // Opening a lesson counts as watching it, as on mobile. Instructors
  // previewing their own course aren't tracked.
  const recorded = useRef(new Set<string>())
  useEffect(() => {
    if (!current || !unlocked || access.loading || access.teaches) return
    if (watched.has(current.id) || recorded.current.has(current.id)) return
    recorded.current.add(current.id)
    markWatched.mutate({ lessonId: current.id, purchaseId: access.purchase?.id })
  }, [current, unlocked, access.loading, access.teaches, access.purchase, watched, markWatched])

  if (!current) {
    return (
      <div className="container-page pt-32 pb-16">
        <EmptyState icon={PlayCircle} title={t("noLessons")} />
      </div>
    )
  }

  const percent = lessons.length
    ? Math.round((Math.min(watched.size, lessons.length) / lessons.length) * 100)
    : 0
  const go = (lesson: Lesson | undefined) => lesson && setLessonParam(lesson.id)

  return (
    <div className="container-page pt-24 pb-28 sm:pt-28 lg:pb-16">
      <Link
        href={routes.learn}
        className="mb-4 inline-flex items-center gap-1 text-sm font-semibold text-muted-foreground transition-colors hover:text-primary"
      >
        <ChevronLeft className="size-4" />
        {t("myCourses")}
      </Link>

      <div className="grid items-start gap-6 lg:grid-cols-[1fr_360px] lg:gap-8">
        <div className="min-w-0">
          <div className="relative aspect-video overflow-hidden rounded-3xl bg-maroon-dark shadow-lift">
            {unlocked && current.videoUrl ? (
              <video
                key={current.id}
                src={current.videoUrl}
                poster={current.image || course.image}
                controls
                autoPlay
                playsInline
                controlsList="nodownload"
                onContextMenu={(e) => e.preventDefault()}
                onEnded={() => go(lessons.slice(index + 1).find(access.canWatch))}
                className="size-full bg-black"
              />
            ) : (
              <LockedPlayer course={course} unlocked={unlocked} />
            )}
          </div>

          <AnimatePresence mode="wait">
            <motion.div
              key={current.id}
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -8 }}
              transition={{ duration: 0.2 }}
              className="mt-6"
            >
              <p className="text-xs font-bold tracking-[0.15em] text-gold uppercase">
                {t("lessonOf", { number: index + 1, total: lessons.length })}
              </p>
              <h1 className="mt-1 text-2xl font-extrabold text-balance sm:text-3xl">
                {lessonTitle(current, locale)}
              </h1>
              {current.seconds > 0 && (
                <p className="mt-2 inline-flex items-center gap-1.5 text-sm text-muted-foreground">
                  <Clock className="size-4" />
                  {formatSeconds(current.seconds)}
                </p>
              )}
              {lessonDescription(current, locale) && (
                <p className="mt-4 leading-relaxed whitespace-pre-line text-muted-foreground">
                  {lessonDescription(current, locale)}
                </p>
              )}
            </motion.div>
          </AnimatePresence>

          <div className="mt-8 flex gap-3">
            <Button variant="outline" disabled={index <= 0} onClick={() => go(lessons[index - 1])}>
              <ChevronLeft />
              {t("previous")}
            </Button>
            <Button
              className="ml-auto"
              disabled={index >= lessons.length - 1}
              onClick={() => go(lessons[index + 1])}
            >
              {t("next")}
              <ChevronRight />
            </Button>
          </div>
        </div>

        <aside className="space-y-4 lg:sticky lg:top-28">
          <div className="rounded-3xl border border-border bg-white p-4 sm:p-5">
            <Link href={routes.course(course.id)} className="line-clamp-2 font-bold hover:text-primary">
              {courseTitle(course, locale)}
            </Link>
            <p className="mt-0.5 text-xs text-muted-foreground">{course.instructorName}</p>
            <div className="mt-4 mb-1.5 flex justify-between text-xs font-semibold">
              <span className="text-muted-foreground">
                {t("lessonsDone", { done: Math.min(watched.size, lessons.length), total: lessons.length })}
              </span>
              <span className="text-primary">{percent}%</span>
            </div>
            <Progress value={percent} className="h-1.5" />

            <ol className="-mx-2 mt-4 max-h-[50vh] space-y-1 overflow-y-auto lg:max-h-[calc(100dvh-24rem)]">
              {lessons.map((lesson, i) => {
                const open = access.canWatch(lesson)
                const active = lesson.id === current.id
                const done = watched.has(lesson.id)
                return (
                  <li key={lesson.id}>
                    <button
                      type="button"
                      onClick={() => go(lesson)}
                      aria-current={active ? "true" : undefined}
                      className={cn(
                        "flex w-full items-center gap-3 rounded-2xl px-2 py-2.5 text-left transition-colors",
                        active ? "bg-maroon-tint" : "hover:bg-cream",
                      )}
                    >
                      <span
                        className={cn(
                          "grid size-8 shrink-0 place-items-center rounded-full text-xs font-bold",
                          done
                            ? "bg-success-tint text-success"
                            : active
                              ? "bg-primary text-white"
                              : "bg-cream",
                        )}
                      >
                        {done ? (
                          <CheckCircle2 className="size-4" />
                        ) : !open ? (
                          <Lock className="size-3.5 text-muted-foreground" />
                        ) : (
                          i + 1
                        )}
                      </span>
                      <span className="min-w-0 flex-1">
                        <span className={cn("line-clamp-2 text-sm", active ? "font-bold" : "font-medium")}>
                          {lessonTitle(lesson, locale)}
                        </span>
                        {lesson.seconds > 0 && (
                          <span className="text-xs text-muted-foreground">
                            {formatSeconds(lesson.seconds)}
                          </span>
                        )}
                      </span>
                      {!access.owned && lesson.isFree && (
                        <span className="rounded-full bg-success-tint px-2 py-0.5 text-[10px] font-bold text-success">
                          {t("free")}
                        </span>
                      )}
                    </button>
                  </li>
                )
              })}
            </ol>
          </div>

          <CourseActions course={course} />
        </aside>
      </div>
    </div>
  )
}

/** Shown instead of the video when the lesson isn't unlocked (or has no video yet). */
function LockedPlayer({ course, unlocked }: { course: Course; unlocked: boolean }) {
  const t = useTranslations("learning")
  return (
    <div className="grid size-full place-items-center bg-[radial-gradient(circle_at_center,var(--maroon-light),var(--maroon-dark))] p-6 text-center text-white">
      <div>
        <span className="mx-auto mb-4 grid size-14 place-items-center rounded-full bg-white/15">
          {unlocked ? <PlayCircle className="size-7" /> : <Lock className="size-6" />}
        </span>
        <p className="text-lg font-bold">{unlocked ? t("videoComing") : t("lockedTitle")}</p>
        {!unlocked && (
          <>
            <p className="mx-auto mt-1 max-w-sm text-sm text-white/80">{t("lockedBody")}</p>
            <Button variant="cream" className="mt-5" render={<Link href={routes.checkout(course.id)} />}>
              {t("unlock")}
            </Button>
          </>
        )}
      </div>
    </div>
  )
}

/** Review and refund, for courses the learner bought. */
function CourseActions({ course }: { course: Course }) {
  const t = useTranslations("learning")
  const access = useCourseAccess(course)
  const refund = useRefundRequest(course.id)
  const purchase = access.purchase
  if (!purchase) return null

  return (
    <div className="space-y-2 rounded-3xl border border-border bg-white p-4 sm:p-5">
      {purchase.reviewed ? (
        <p className="flex items-center gap-2 text-sm font-semibold text-success">
          <Star className="size-4" fill="currentColor" />
          {t("reviewed")}
        </p>
      ) : (
        <ReviewDialog course={course} purchaseId={purchase.id} />
      )}
      {course.price > 0 &&
        (refund.data ? (
          <p className="flex items-center gap-2 pt-1 text-sm text-muted-foreground">
            <ReceiptText className="size-4" />
            {t("refundStatus", { status: refund.data.status })}
          </p>
        ) : (
          <Button
            variant="ghost"
            className="w-full justify-start text-muted-foreground"
            render={<Link href={routes.refund(course.id)} />}
          >
            <ReceiptText />
            {t("requestRefund")}
          </Button>
        ))}
    </div>
  )
}

function PlayerSkeleton() {
  return (
    <div className="container-page grid gap-8 pt-28 pb-16 lg:grid-cols-[1fr_360px]">
      <div>
        <Skeleton className="aspect-video rounded-3xl" />
        <Skeleton className="mt-6 h-8 w-2/3" />
        <Skeleton className="mt-3 h-4 w-1/3" />
      </div>
      <Skeleton className="h-96 rounded-3xl" />
    </div>
  )
}
