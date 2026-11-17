"use client"

import { ArrowUpRight, MessagesSquare, PlayCircle } from "lucide-react"
import { motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useMemo, useState } from "react"
import { CoverImage } from "@/components/cover-image"
import { Progress } from "@/components/ui/progress"
import { routes, site } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { SHELVES, shelfCourses } from "../filters"
import { useCatalogOptions, useCourses, useHomeAd } from "../hooks"
import { type Course, courseTitle } from "../types"
import { CourseShelf } from "./course-shelf"
import { LoadError } from "./discover-views"
import { SearchBox } from "./search-box"

/** /home — the signed-in learner's start page (the mobile home screen). */
export function HomeView() {
  const t = useTranslations("catalog.home")
  const tc = useTranslations("catalog")
  const locale = useLocale()
  const router = useRouter()
  const { profile } = useAuth()
  const courses = useCourses()
  const [text, setText] = useState("")

  const firstName = profile?.displayName.trim().split(/\s+/)[0] ?? ""

  // Like mobile, "New courses" prefers courses taught in the learner's language.
  const newCourses = useMemo(() => {
    if (!courses.data) return undefined
    const newest = shelfCourses(courses.data, SHELVES.new)
    const mine = newest.filter((c) => c.language.code === (locale === "sw" ? "sw" : "en"))
    return mine.length >= 3 ? mine : newest
  }, [courses.data, locale])

  return (
    <div className="pb-28 md:pb-16">
      <section className="relative overflow-hidden bg-cream pt-28 pb-10 sm:pt-32">
        <div className="pointer-events-none absolute -top-24 -right-20 size-96 rounded-full bg-gold-light blur-3xl" />
        <div className="container-page relative">
          <motion.p
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-sm font-semibold text-muted-foreground"
          >
            {firstName ? t("greeting", { name: firstName }) : t("greetingNoName")}
          </motion.p>
          <motion.h1
            initial={{ opacity: 0, y: 14 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.06 }}
            className="mt-1 text-3xl font-extrabold sm:text-4xl"
          >
            {t("title")}
          </motion.h1>
          <SearchBox
            value={text}
            onChange={setText}
            onSubmit={(q) => q.trim() && router.push(`${routes.search}?q=${encodeURIComponent(q.trim())}`)}
            className="mt-6 max-w-2xl"
          />
          <Topics />
        </div>
      </section>

      <div className="container-page">
        {courses.isError ? (
          <div className="py-10">
            <LoadError onRetry={() => courses.refetch()} />
          </div>
        ) : (
          <>
            <ContinueWatching courses={courses.data} />
            <CourseShelf
              title={tc("shelves.new")}
              courses={newCourses}
              loading={courses.isPending}
              seeAllHref={routes.group(SHELVES.new)}
            />
            <CourseShelf
              title={tc("shelves.recommended")}
              courses={courses.data && shelfCourses(courses.data, SHELVES.recommended)}
              loading={courses.isPending}
              seeAllHref={routes.group(SHELVES.recommended)}
            />
            <AdBanner />
            <CourseShelf
              title={tc("shelves.popular")}
              courses={courses.data && shelfCourses(courses.data, SHELVES.popular)}
              loading={courses.isPending}
              seeAllHref={routes.group(SHELVES.popular)}
            />
          </>
        )}
      </div>
    </div>
  )
}

/** Category shortcuts plus the consultation tile, as on the mobile home screen. */
function Topics() {
  const t = useTranslations("catalog.home")
  const options = useCatalogOptions()
  const categories = options.data?.categories.slice(0, 5) ?? []

  return (
    <div className="mt-6">
      <p className="mb-3 text-sm font-bold">{t("popularTopics")}</p>
      <div className="-mx-4 flex scrollbar-none gap-2.5 overflow-x-auto px-4 pb-1 sm:mx-0 sm:flex-wrap sm:px-0">
        {categories.map((c) => (
          <Link
            key={c.name}
            href={routes.category(c.name)}
            className="flex shrink-0 items-center gap-2 rounded-full border border-border bg-white py-1.5 pr-4 pl-1.5 text-sm font-semibold transition-all hover:-translate-y-0.5 hover:border-primary/30 hover:shadow-soft"
          >
            <CoverImage src={c.image} alt="" className="size-8 rounded-full" />
            {c.name}
          </Link>
        ))}
        <Link
          href={routes.consult}
          className="flex shrink-0 items-center gap-2 rounded-full bg-primary py-1.5 pr-4 pl-1.5 text-sm font-semibold text-primary-foreground transition-all hover:-translate-y-0.5 hover:shadow-soft"
        >
          <span className="grid size-8 place-items-center rounded-full bg-white/15">
            <MessagesSquare className="size-4" />
          </span>
          {t("consultation")}
        </Link>
      </div>
    </div>
  )
}

/** Courses the learner has started, with how far they got. */
function ContinueWatching({ courses }: { courses: Course[] | undefined }) {
  const t = useTranslations("catalog.home")
  const locale = useLocale()
  const { profile } = useAuth()

  const items = useMemo(() => {
    if (!courses || !profile) return []
    return profile.continueWatching
      .map((entry) => {
        const course = courses.find((c) => c.id === entry.courseId)
        if (!course) return null
        const done = entry.completedLessonIds.length
        const percent = course.totalLessons
          ? Math.min(100, Math.round((done / course.totalLessons) * 100))
          : 0
        return { course, done, percent }
      })
      .filter((x): x is NonNullable<typeof x> => x !== null)
  }, [courses, profile])

  if (!items.length) return null

  return (
    <section className="py-6">
      <h2 className="mb-4 font-sans text-xl font-bold sm:text-2xl">{t("continueWatching")}</h2>
      <div className="-mx-4 flex snap-x scrollbar-none gap-4 overflow-x-auto px-4 pb-2 sm:mx-0 sm:grid sm:grid-cols-2 sm:px-0 lg:grid-cols-3">
        {items.map(({ course, done, percent }) => (
          <Link
            key={course.id}
            href={routes.learnCourse(course.id)}
            className="group flex w-[85vw] shrink-0 snap-start gap-4 rounded-3xl border border-border bg-white p-3 transition-all hover:border-primary/20 hover:shadow-soft sm:w-auto"
          >
            <div className="relative aspect-square w-24 shrink-0 overflow-hidden rounded-2xl">
              <CoverImage src={course.image} alt="" className="size-full" />
              <span className="absolute inset-0 grid place-items-center bg-maroon-dark/30 opacity-0 transition-opacity group-hover:opacity-100">
                <PlayCircle className="size-8 text-white" />
              </span>
            </div>
            <div className="flex min-w-0 flex-1 flex-col justify-center">
              <p className="line-clamp-2 text-sm font-bold">{courseTitle(course, locale)}</p>
              <p className="mt-1 text-xs text-muted-foreground">
                {t("lessonsDone", { done, total: course.totalLessons })}
              </p>
              <Progress value={percent} className="mt-3 h-1.5" />
            </div>
          </Link>
        ))}
      </div>
    </section>
  )
}

/** The admin-managed banner. Tapping it opens WhatsApp (mobile opens SMS). */
function AdBanner() {
  const t = useTranslations("catalog.home")
  const ad = useHomeAd()
  if (!ad.data) return null

  const href = `${site.whatsappUrl}?text=${encodeURIComponent(t("adMessage"))}`

  return (
    <motion.a
      href={href}
      target="_blank"
      rel="noreferrer"
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      className="group relative my-6 block aspect-[21/9] overflow-hidden rounded-3xl bg-maroon sm:aspect-[32/9]"
    >
      <CoverImage
        src={ad.data.imageUrl}
        alt={ad.data.title || t("adAlt")}
        className="size-full transition-transform duration-700 group-hover:scale-105"
      />
      <span className="absolute right-4 bottom-4 inline-flex items-center gap-1 rounded-full bg-white/90 px-4 py-2 text-sm font-semibold text-primary backdrop-blur">
        {t("adCta")}
        <ArrowUpRight className="size-4" />
      </span>
    </motion.a>
  )
}
