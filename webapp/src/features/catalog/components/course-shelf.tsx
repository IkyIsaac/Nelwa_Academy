"use client"

import { ArrowRight, ChevronLeft, ChevronRight } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { useRef } from "react"
import { Button } from "@/components/ui/button"
import type { Course } from "../types"
import { CourseCard, CourseCardSkeleton } from "./course-card"

/**
 * A titled, horizontally scrolling row of courses (the mobile home "shelves").
 * Phones swipe; larger screens also get arrow buttons.
 */
export function CourseShelf({
  title,
  courses,
  loading,
  seeAllHref,
  limit = 8,
}: {
  title: string
  courses: Course[] | undefined
  loading?: boolean
  seeAllHref?: string
  limit?: number
}) {
  const t = useTranslations("common")
  const track = useRef<HTMLDivElement>(null)

  const scroll = (direction: 1 | -1) =>
    track.current?.scrollBy({ left: direction * track.current.clientWidth * 0.8, behavior: "smooth" })

  if (!loading && !courses?.length) return null

  return (
    <section className="py-6">
      <div className="mb-4 flex items-end justify-between gap-4">
        <h2 className="font-sans text-xl font-bold sm:text-2xl">{title}</h2>
        <div className="flex items-center gap-1">
          {seeAllHref && (
            <Link
              href={seeAllHref}
              className="group inline-flex items-center gap-1 rounded-full px-3 py-1.5 text-sm font-semibold text-primary hover:bg-maroon-tint"
            >
              {t("seeAll")}
              <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
            </Link>
          )}
          <Button
            variant="outline"
            size="icon-sm"
            className="hidden md:inline-flex"
            onClick={() => scroll(-1)}
            aria-label={t("previous")}
          >
            <ChevronLeft />
          </Button>
          <Button
            variant="outline"
            size="icon-sm"
            className="hidden md:inline-flex"
            onClick={() => scroll(1)}
            aria-label={t("next")}
          >
            <ChevronRight />
          </Button>
        </div>
      </div>

      <div
        ref={track}
        className="-mx-4 flex snap-x snap-mandatory scroll-px-4 scrollbar-none gap-4 overflow-x-auto px-4 pt-1 pb-6 sm:-mx-6 sm:scroll-px-6 sm:px-6 lg:mx-0 lg:scroll-px-0 lg:px-0"
      >
        {loading
          ? Array.from({ length: 4 }, (_, i) => (
              <CourseCardSkeleton key={i} className="w-[72vw] shrink-0 snap-start sm:w-72" />
            ))
          : courses!
              .slice(0, limit)
              .map((course) => (
                <CourseCard
                  key={course.id}
                  course={course}
                  className="w-[72vw] shrink-0 snap-start sm:w-72"
                />
              ))}
      </div>
    </section>
  )
}
