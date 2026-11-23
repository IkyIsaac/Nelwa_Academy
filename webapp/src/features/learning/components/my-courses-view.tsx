"use client"

import { useQueries } from "@tanstack/react-query"
import { Archive, ArchiveRestore, BookOpen, CheckCircle2, PlayCircle } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { useMemo, useState } from "react"
import { toast } from "sonner"
import { CoverImage } from "@/components/cover-image"
import { EmptyState } from "@/components/empty-state"
import { PageHeader } from "@/components/layout/page-header"
import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { fetchCourse } from "@/features/catalog/api"
import { LoadError } from "@/features/catalog/components/discover-views"
import { catalogKeys } from "@/features/catalog/hooks"
import { type Course, courseTitle } from "@/features/catalog/types"
import { cn } from "@/lib/utils"
import { useArchivePurchase, usePurchases } from "../hooks"

type Filter = "all" | "inProgress" | "completed" | "archived"

type Item = {
  course: Course
  done: number
  total: number
  percent: number
  purchaseId: string | null
  archived: boolean
}

/**
 * The learner's courses: everything they bought, plus free courses they've
 * started. Progress counts the lessons they've opened, as on mobile.
 */
export function MyCoursesView() {
  const t = useTranslations("learning")
  const { profile } = useAuth()
  const purchases = usePurchases()
  const [filter, setFilter] = useState<Filter>("all")

  const courseIds = useMemo(() => {
    const bought = purchases.data?.map((p) => p.courseId) ?? []
    const started = profile?.continueWatching.map((c) => c.courseId) ?? []
    return [...new Set([...bought, ...started])].filter(Boolean)
  }, [purchases.data, profile])

  const courses = useQueries({
    queries: courseIds.map((id) => ({
      queryKey: catalogKeys.course(id),
      queryFn: () => fetchCourse(id),
      staleTime: 5 * 60 * 1000,
    })),
  })

  const items = useMemo<Item[]>(() => {
    return courseIds
      .map((id, i) => {
        const course = courses[i]?.data
        if (!course) return null
        const purchase = purchases.data?.find((p) => p.courseId === id)
        const started = profile?.continueWatching.find((c) => c.courseId === id)
        // Free courses the learner only looked at aren't "their" courses.
        if (!purchase && course.price > 0) return null
        const watched = new Set([
          ...(purchase?.watchedLessonIds ?? []),
          ...(started?.completedLessonIds ?? []),
        ])
        const total = Math.max(course.totalLessons, purchase?.lessons ?? 0, watched.size)
        const percent = total ? Math.round((watched.size / total) * 100) : 0
        return {
          course,
          done: watched.size,
          total,
          percent,
          purchaseId: purchase?.id ?? null,
          archived: !!purchase?.archived,
        }
      })
      .filter((x): x is Item => x !== null)
  }, [courseIds, courses, purchases.data, profile])

  // Archived courses only appear under their own filter.
  const hasArchived = items.some((i) => i.archived)
  // Unarchiving the last course hides the tab; fall back to All.
  const current: Filter = filter === "archived" && !hasArchived ? "all" : filter
  const shown = items.filter((i) =>
    current === "archived"
      ? i.archived
      : !i.archived &&
        (current === "all" ? true : current === "completed" ? i.percent >= 100 : i.percent < 100),
  )
  const filters: Filter[] = ["all", "inProgress", "completed", ...(hasArchived ? ["archived" as const] : [])]
  const loading = purchases.isPending || courses.some((q) => q.isPending)

  return (
    <>
      <PageHeader eyebrow={t("eyebrow")} title={t("myCourses")} description={t("myCoursesBody")}>
        {items.length > 0 && (
          <div role="tablist" className="inline-flex rounded-full border border-border bg-white p-1">
            {filters.map((f) => (
              <button
                key={f}
                role="tab"
                aria-selected={current === f}
                onClick={() => setFilter(f)}
                className={cn(
                  "relative rounded-full px-4 py-1.5 text-sm font-semibold transition-colors",
                  current === f ? "text-white" : "text-muted-foreground hover:text-foreground",
                )}
              >
                {current === f && (
                  <motion.span layoutId="learn-filter" className="absolute inset-0 rounded-full bg-primary" />
                )}
                <span className="relative">{t(`filters.${f}`)}</span>
              </button>
            ))}
          </div>
        )}
      </PageHeader>

      <div className="container-page py-10">
        {purchases.isError ? (
          <LoadError onRetry={() => purchases.refetch()} />
        ) : loading ? (
          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {Array.from({ length: 3 }, (_, i) => (
              <Skeleton key={i} className="h-72 rounded-3xl" />
            ))}
          </div>
        ) : items.length === 0 ? (
          <EmptyState
            icon={BookOpen}
            title={t("emptyTitle")}
            body={t("emptyBody")}
            action={<Button render={<Link href={routes.explore} />}>{t("browse")}</Button>}
          />
        ) : shown.length === 0 ? (
          <EmptyState
            icon={BookOpen}
            title={t(
              current === "completed"
                ? "noneCompleted"
                : current === "archived"
                  ? "noneArchived"
                  : "noneInProgress",
            )}
          />
        ) : (
          <motion.ul layout className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            <AnimatePresence mode="popLayout">
              {shown.map((item) => (
                <motion.li
                  key={item.course.id}
                  layout
                  initial={{ opacity: 0, scale: 0.96 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.96 }}
                >
                  <div className="relative h-full">
                    <LearnCard item={item} />
                    {item.purchaseId && (
                      <ArchiveButton purchaseId={item.purchaseId} archived={item.archived} />
                    )}
                  </div>
                </motion.li>
              ))}
            </AnimatePresence>
          </motion.ul>
        )}
      </div>
    </>
  )
}

/** Hides a bought course from My courses, or brings it back. Never deletes it. */
function ArchiveButton({ purchaseId, archived }: { purchaseId: string; archived: boolean }) {
  const t = useTranslations("learning")
  const archive = useArchivePurchase()
  const label = archived ? t("unarchive") : t("archive")
  return (
    <button
      type="button"
      aria-label={label}
      title={label}
      disabled={archive.isPending}
      onClick={() =>
        archive.mutate(
          { purchaseId, archived: !archived },
          {
            onSuccess: () => toast.success(archived ? t("unarchived") : t("archived")),
            onError: () => toast.error(t("archiveFailed")),
          },
        )
      }
      className="absolute top-3 right-3 grid size-9 place-items-center rounded-full bg-white/90 text-foreground shadow-soft backdrop-blur transition-colors hover:bg-white hover:text-primary disabled:opacity-60"
    >
      {archived ? <ArchiveRestore className="size-4" /> : <Archive className="size-4" />}
    </button>
  )
}

function LearnCard({ item }: { item: Item }) {
  const t = useTranslations("learning")
  const locale = useLocale()
  const { course, done, total, percent } = item
  const complete = percent >= 100
  return (
    <Link
      href={routes.learnCourse(course.id)}
      className="group flex h-full flex-col overflow-hidden rounded-3xl border border-border bg-white transition-all hover:-translate-y-0.5 hover:border-primary/20 hover:shadow-lift"
    >
      <div className="relative aspect-video overflow-hidden">
        <CoverImage
          src={course.image}
          alt=""
          className="size-full transition-transform duration-500 group-hover:scale-105"
        />
        <span className="absolute inset-0 grid place-items-center bg-maroon-dark/30 opacity-0 transition-opacity group-hover:opacity-100">
          <PlayCircle className="size-12 text-white" />
        </span>
        {complete && (
          <span className="absolute top-3 left-3 inline-flex items-center gap-1 rounded-full bg-success px-2.5 py-1 text-[11px] font-bold text-white">
            <CheckCircle2 className="size-3.5" />
            {t("completed")}
          </span>
        )}
      </div>
      <div className="flex flex-1 flex-col p-4">
        <p className="line-clamp-2 font-bold">{courseTitle(course, locale)}</p>
        <p className="mt-1 text-xs text-muted-foreground">{course.instructorName}</p>
        <div className="mt-auto pt-4">
          <div className="mb-1.5 flex justify-between text-xs font-semibold">
            <span className="text-muted-foreground">{t("lessonsDone", { done, total })}</span>
            <span className="text-primary">{percent}%</span>
          </div>
          <Progress value={percent} className="h-1.5" />
          <p className="mt-4 text-sm font-bold text-primary">
            {done === 0 ? t("start") : complete ? t("watchAgain") : t("continue")} →
          </p>
        </div>
      </div>
    </Link>
  )
}
