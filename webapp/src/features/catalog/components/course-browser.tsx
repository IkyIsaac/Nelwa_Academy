"use client"

import { LayoutGrid, List, SearchX } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useTranslations } from "next-intl"
import { useMemo } from "react"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"
import { applyFilters, countActiveFilters, type CourseFilters } from "../filters"
import type { Course } from "../types"
import { useCourseFilters } from "../use-filters"
import { CourseCard, CourseCardSkeleton, CourseRow, CourseRowSkeleton } from "./course-card"
import { FilterSheet } from "./filter-sheet"

const SORTS: CourseFilters["sort"][] = ["popular", "newest", "rating", "priceLow", "priceHigh"]

/**
 * A full list of courses with sort, filters and grid/list view — used by the
 * category, tag, shelf, search and explore pages.
 */
export function CourseBrowser({
  courses,
  loading,
  defaultSort,
  emptyTitle,
}: {
  courses: Course[] | undefined
  loading?: boolean
  defaultSort?: CourseFilters["sort"]
  emptyTitle?: string
}) {
  const t = useTranslations("catalog")
  const { filters, view, setFilters, setView, reset } = useCourseFilters(defaultSort)

  const results = useMemo(() => applyFilters(courses ?? [], filters), [courses, filters])
  const languages = useMemo(() => {
    const map = new Map<string, string>()
    for (const c of courses ?? [])
      if (c.language.code) map.set(c.language.code, c.language.name || c.language.code)
    return [...map.entries()]
  }, [courses])

  return (
    <div>
      <div className="mb-6 flex flex-wrap items-center gap-3">
        <p className="mr-auto text-sm text-muted-foreground" aria-live="polite">
          {loading ? t("loadingCourses") : t("resultsCount", { count: results.length })}
        </p>

        <label className="sr-only" htmlFor="course-sort">
          {t("sort.label")}
        </label>
        <select
          id="course-sort"
          value={filters.sort}
          onChange={(e) => setFilters({ sort: e.target.value as CourseFilters["sort"] })}
          className="h-9 rounded-full border border-border bg-white pr-8 pl-4 text-sm font-medium outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
        >
          {SORTS.map((s) => (
            <option key={s} value={s}>
              {t(`sort.${s}`)}
            </option>
          ))}
        </select>

        <FilterSheet filters={filters} onApply={setFilters} languages={languages} />

        <div
          className="flex rounded-full border border-border bg-white p-0.5"
          role="group"
          aria-label={t("viewMode")}
        >
          {(["grid", "list"] as const).map((mode) => {
            const Icon = mode === "grid" ? LayoutGrid : List
            return (
              <button
                key={mode}
                type="button"
                aria-pressed={view === mode}
                aria-label={t(mode === "grid" ? "gridView" : "listView")}
                onClick={() => setView(mode)}
                className={cn(
                  "relative grid size-8 place-items-center rounded-full transition-colors",
                  view === mode ? "text-primary-foreground" : "text-muted-foreground hover:text-primary",
                )}
              >
                {view === mode && (
                  <motion.span layoutId="view-toggle" className="absolute inset-0 rounded-full bg-primary" />
                )}
                <Icon className="relative size-4" />
              </button>
            )
          })}
        </div>
      </div>

      {loading ? (
        view === "grid" ? (
          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {Array.from({ length: 8 }, (_, i) => (
              <CourseCardSkeleton key={i} />
            ))}
          </div>
        ) : (
          <div className="grid gap-4 lg:grid-cols-2">
            {Array.from({ length: 6 }, (_, i) => (
              <CourseRowSkeleton key={i} />
            ))}
          </div>
        )
      ) : results.length === 0 ? (
        <EmptyState
          icon={SearchX}
          title={emptyTitle ?? t("noCourses")}
          body={countActiveFilters(filters) ? t("noCoursesFiltered") : undefined}
          action={
            countActiveFilters(filters) ? (
              <Button variant="outline" onClick={reset}>
                {t("filters.clear")}
              </Button>
            ) : undefined
          }
        />
      ) : (
        <motion.div
          layout
          className={cn(
            "grid gap-5",
            view === "grid" ? "sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4" : "gap-4 lg:grid-cols-2",
          )}
        >
          <AnimatePresence mode="popLayout" initial={false}>
            {results.map((course) => (
              <motion.div
                key={course.id}
                layout
                initial={{ opacity: 0, scale: 0.96 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.96 }}
                transition={{ duration: 0.25 }}
              >
                {view === "grid" ? (
                  <CourseCard course={course} morph className="h-full" />
                ) : (
                  <CourseRow course={course} morph />
                )}
              </motion.div>
            ))}
          </AnimatePresence>
        </motion.div>
      )}
    </div>
  )
}
