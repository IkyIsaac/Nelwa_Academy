import type { Course } from "./types"

/**
 * Browsing logic, kept free of React so it is easy to read and test.
 */

export type DurationRange = "any" | "under1h" | "1to3h" | "3to10h" | "over10h"
export type PriceRange = "any" | "free" | "under50k" | "50to150k" | "over150k"
export type SortBy = "popular" | "newest" | "rating" | "priceLow" | "priceHigh"

export type CourseFilters = {
  /** Minimum star rating: 0 means any. */
  rating: number
  duration: DurationRange
  price: PriceRange
  /** Language code the course is taught in, or "" for any. */
  language: string
  sort: SortBy
}

export const defaultFilters: CourseFilters = {
  rating: 0,
  duration: "any",
  price: "any",
  language: "",
  sort: "popular",
}

export const countActiveFilters = (f: CourseFilters) =>
  [f.rating > 0, f.duration !== "any", f.price !== "any", f.language !== ""].filter(Boolean).length

// Mobile filter buckets, in seconds (course length is stored in seconds).
const DURATION: Record<DurationRange, [number, number]> = {
  any: [0, Infinity],
  under1h: [0, 3600],
  "1to3h": [3600, 10_800],
  "3to10h": [10_800, 36_000],
  over10h: [36_000, Infinity],
}

const PRICE: Record<PriceRange, [number, number]> = {
  any: [0, Infinity],
  free: [0, 0],
  under50k: [1, 50_000],
  "50to150k": [50_000, 150_000],
  over150k: [150_000, Infinity],
}

const inRange = (value: number, [min, max]: [number, number]) => value >= min && value <= max

const SORTERS: Record<SortBy, (a: Course, b: Course) => number> = {
  popular: (a, b) => b.studentIds.length - a.studentIds.length || b.rating - a.rating,
  newest: (a, b) => (b.publishedAt?.getTime() ?? 0) - (a.publishedAt?.getTime() ?? 0),
  rating: (a, b) => b.rating - a.rating || b.reviewsCount - a.reviewsCount,
  priceLow: (a, b) => a.price - b.price,
  priceHigh: (a, b) => b.price - a.price,
}

export function applyFilters(courses: Course[], f: CourseFilters) {
  return courses
    .filter(
      (c) =>
        c.rating >= f.rating &&
        (f.duration === "any" || inRange(c.totalSeconds, DURATION[f.duration])) &&
        inRange(c.price, PRICE[f.price]) &&
        (!f.language || c.language.code === f.language),
    )
    .sort(SORTERS[f.sort])
}

export const sortCourses = (courses: Course[], sort: SortBy) => [...courses].sort(SORTERS[sort])

/** Lower-case and strip accents so "creme" finds "crème". */
const normalize = (text: string) =>
  text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")

/**
 * Search titles, descriptions (both languages), category, tags and
 * instructor. Every word typed must appear somewhere; title matches rank first.
 */
export function searchCourses(courses: Course[], text: string) {
  const words = normalize(text).split(/\s+/).filter(Boolean)
  if (!words.length) return []

  return courses
    .map((c) => {
      const title = normalize(`${c.title} ${c.titleSw}`)
      const rest = normalize(
        [c.description, c.descriptionSw, c.category, c.instructorName, ...c.tags, ...c.audience].join(" "),
      )
      if (!words.every((w) => title.includes(w) || rest.includes(w))) return null
      const score = words.filter((w) => title.includes(w)).length
      return { course: c, score }
    })
    .filter((r): r is { course: Course; score: number } => r !== null)
    .sort((a, b) => b.score - a.score || b.course.rating - a.course.rating)
    .map((r) => r.course)
}

/** The shelves on the home screen. "See all" opens the same list as a page. */
export const SHELVES = {
  new: "New Courses",
  recommended: "We Recommend",
  popular: "Popular Courses",
} as const

export function shelfCourses(courses: Course[], shelf: string) {
  switch (shelf) {
    case SHELVES.new:
      return sortCourses(courses, "newest")
    case SHELVES.popular:
      return sortCourses(courses, "popular")
    case SHELVES.recommended: {
      const picked = courses.filter((c) => c.group === SHELVES.recommended)
      // Until instructors tag courses as recommended, fall back to the best rated.
      return sortCourses(picked.length ? picked : courses, "rating")
    }
    default:
      return courses.filter((c) => c.group === shelf)
  }
}
