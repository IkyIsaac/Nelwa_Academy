"use client"

import { ArrowRight, CloudOff, Flame, LayoutGrid } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { parseAsString, useQueryState } from "nuqs"
import { useMemo, useState } from "react"
import { EmptyState } from "@/components/empty-state"
import { PageHeader } from "@/components/layout/page-header"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { SHELVES, searchCourses, shelfCourses } from "../filters"
import { useCatalogOptions, useCourses } from "../hooks"
import { CategoryGrid } from "./category-grid"
import { CourseBrowser } from "./course-browser"
import { CourseShelf } from "./course-shelf"
import { SearchBox, SearchChips } from "./search-box"

/** Shown when Firestore can't be reached or refuses the read. */
export function LoadError({ onRetry }: { onRetry: () => void }) {
  const t = useTranslations("common")
  return (
    <EmptyState
      icon={CloudOff}
      title={t("somethingWrong")}
      body={t("loadFailed")}
      action={
        <Button variant="outline" onClick={onRetry}>
          {t("retry")}
        </Button>
      }
    />
  )
}

function SectionHeading({
  icon: Icon,
  title,
  href,
  linkLabel,
}: {
  icon: typeof Flame
  title: string
  href?: string
  linkLabel?: string
}) {
  return (
    <div className="mb-4 flex items-center justify-between gap-4">
      <h2 className="inline-flex items-center gap-2 font-sans text-xl font-bold sm:text-2xl">
        <Icon className="size-5 text-gold" />
        {title}
      </h2>
      {href && (
        <Link
          href={href}
          className="group inline-flex items-center gap-1 rounded-full px-3 py-1.5 text-sm font-semibold text-primary hover:bg-maroon-tint"
        >
          {linkLabel}
          <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
        </Link>
      )}
    </div>
  )
}

/** /explore — trending searches, categories, recommendations and every course. */
export function ExploreView() {
  const t = useTranslations("catalog")
  const router = useRouter()
  const [text, setText] = useState("")
  const courses = useCourses()
  const options = useCatalogOptions()

  const goSearch = (q: string) =>
    q.trim() && router.push(`${routes.search}?q=${encodeURIComponent(q.trim())}`)

  return (
    <>
      <PageHeader
        eyebrow={t("explore.eyebrow")}
        title={t("explore.title")}
        description={t("explore.subtitle")}
      >
        <SearchBox value={text} onChange={setText} onSubmit={goSearch} className="max-w-2xl" />
        {!!options.data?.trendingNow.length && (
          <div className="mt-5 flex flex-wrap items-center gap-3">
            <span className="inline-flex items-center gap-1.5 text-sm font-semibold text-muted-foreground">
              <Flame className="size-4 text-gold" />
              {t("trending")}
            </span>
            <SearchChips terms={options.data.trendingNow} onPick={goSearch} />
          </div>
        )}
      </PageHeader>

      <div className="container-page py-10">
        {courses.isError ? (
          <LoadError onRetry={() => courses.refetch()} />
        ) : (
          <>
            {(options.isPending || !!options.data?.categories.length) && (
              <section className="pb-6">
                <SectionHeading
                  icon={LayoutGrid}
                  title={t("categories")}
                  href={routes.categories}
                  linkLabel={t("allCategories")}
                />
                <CategoryGrid
                  categories={options.data?.categories.slice(0, 4)}
                  courses={courses.data}
                  loading={options.isPending}
                />
              </section>
            )}

            <CourseShelf
              title={t("shelves.recommended")}
              courses={courses.data && shelfCourses(courses.data, SHELVES.recommended)}
              loading={courses.isPending}
              seeAllHref={routes.group(SHELVES.recommended)}
            />

            <section className="pt-6">
              <h2 className="mb-2 font-sans text-xl font-bold sm:text-2xl">{t("allCourses")}</h2>
              <CourseBrowser courses={courses.data} loading={courses.isPending} />
            </section>
          </>
        )}
      </div>
    </>
  )
}

/** /search?q=… — results update as you type; the query stays in the URL. */
export function SearchView() {
  const t = useTranslations("catalog")
  const [q, setQ] = useQueryState("q", parseAsString.withDefault("").withOptions({ throttleMs: 300 }))
  const courses = useCourses()
  const options = useCatalogOptions()
  const results = useMemo(
    () => (courses.data ? searchCourses(courses.data, q) : undefined),
    [courses.data, q],
  )

  return (
    <>
      <PageHeader title={t("search.title")}>
        <SearchBox value={q} onChange={(v) => setQ(v || null)} autoFocus className="max-w-2xl" />
      </PageHeader>

      <div className="container-page py-10">
        {courses.isError ? (
          <LoadError onRetry={() => courses.refetch()} />
        ) : q.trim() ? (
          <CourseBrowser
            courses={results}
            loading={courses.isPending}
            emptyTitle={t("search.noResults", { query: q })}
          />
        ) : (
          <div className="space-y-10">
            {!!options.data?.trendingNow.length && (
              <section>
                <SectionHeading icon={Flame} title={t("trending")} />
                <SearchChips terms={options.data.trendingNow} onPick={(term) => setQ(term)} />
              </section>
            )}
            <section>
              <SectionHeading
                icon={LayoutGrid}
                title={t("categories")}
                href={routes.categories}
                linkLabel={t("allCategories")}
              />
              <CategoryGrid
                categories={options.data?.categories.slice(0, 4)}
                courses={courses.data}
                loading={options.isPending}
              />
            </section>
            <CourseShelf
              title={t("shelves.recommended")}
              courses={courses.data && shelfCourses(courses.data, SHELVES.recommended)}
              loading={courses.isPending}
              seeAllHref={routes.group(SHELVES.recommended)}
            />
          </div>
        )}
      </div>
    </>
  )
}

/** /categories — every category tile. */
export function CategoriesView() {
  const t = useTranslations("catalog")
  const courses = useCourses()
  const options = useCatalogOptions()

  return (
    <>
      <PageHeader
        back={{ href: routes.explore, label: t("explore.title") }}
        title={t("categories")}
        description={t("categoriesSubtitle")}
      />
      <div className="container-page py-10">
        {options.isError ? (
          <LoadError onRetry={() => options.refetch()} />
        ) : (
          <CategoryGrid
            categories={options.data?.categories}
            courses={courses.data}
            loading={options.isPending}
          />
        )}
      </div>
    </>
  )
}

type ListingKind = "category" | "tag" | "group"

/** /categories/[name], /tags/[tag] and /groups/[shelf]: one filtered course list. */
export function ListingView({ kind, value }: { kind: ListingKind; value: string }) {
  const t = useTranslations("catalog")
  const courses = useCourses()

  const list = useMemo(() => {
    if (!courses.data) return undefined
    if (kind === "category") return courses.data.filter((c) => c.category === value)
    if (kind === "tag") return courses.data.filter((c) => c.tags.includes(value))
    return shelfCourses(courses.data, value)
  }, [courses.data, kind, value])

  const shelfTitles: Record<string, string> = {
    [SHELVES.new]: t("shelves.new"),
    [SHELVES.recommended]: t("shelves.recommended"),
    [SHELVES.popular]: t("shelves.popular"),
  }
  const title = kind === "tag" ? `#${value}` : kind === "group" ? (shelfTitles[value] ?? value) : value
  const back =
    kind === "category"
      ? { href: routes.categories, label: t("categories") }
      : { href: routes.explore, label: t("explore.title") }

  return (
    <>
      <PageHeader back={back} eyebrow={t(`listing.${kind}`)} title={title} />
      <div className="container-page py-10">
        {courses.isError ? (
          <LoadError onRetry={() => courses.refetch()} />
        ) : (
          <CourseBrowser
            courses={list}
            loading={courses.isPending}
            // Shelves already have a natural order; keep it unless the learner changes it.
            defaultSort={
              value === SHELVES.new ? "newest" : value === SHELVES.recommended ? "rating" : "popular"
            }
          />
        )}
      </div>
    </>
  )
}
