"use client"

import { parseAsFloat, parseAsString, parseAsStringLiteral, useQueryStates } from "nuqs"
import { type CourseFilters, defaultFilters } from "./filters"

const DURATIONS = ["any", "under1h", "1to3h", "3to10h", "over10h"] as const
const PRICES = ["any", "free", "under50k", "50to150k", "over150k"] as const
const SORTS = ["popular", "newest", "rating", "priceLow", "priceHigh"] as const
const VIEWS = ["grid", "list"] as const

/**
 * Filters, sort and view mode live in the URL (?sort=newest&rating=4), so a
 * filtered list can be shared or bookmarked and survives the back button.
 */
export function useCourseFilters(defaultSort: CourseFilters["sort"] = defaultFilters.sort) {
  const [state, setState] = useQueryStates({
    rating: parseAsFloat.withDefault(0),
    duration: parseAsStringLiteral(DURATIONS).withDefault("any"),
    price: parseAsStringLiteral(PRICES).withDefault("any"),
    language: parseAsString.withDefault(""),
    sort: parseAsStringLiteral(SORTS).withDefault(defaultSort),
    view: parseAsStringLiteral(VIEWS).withDefault("grid"),
  })

  const { view, ...filters } = state
  return {
    filters: filters as CourseFilters,
    view,
    setFilters: (next: Partial<CourseFilters>) => setState(next),
    setView: (next: (typeof VIEWS)[number]) => setState({ view: next }),
    reset: () => setState({ rating: null, duration: null, price: null, language: null }),
  }
}
