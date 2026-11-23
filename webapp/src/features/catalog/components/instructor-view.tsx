"use client"

import { BookOpen, GraduationCap, PlayCircle, Star, UserCheck, Users } from "lucide-react"
import { useTranslations } from "next-intl"
import { useMemo } from "react"
import { CountUp } from "@/components/motion/count-up"
import { Reveal } from "@/components/motion/reveal"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Skeleton } from "@/components/ui/skeleton"
import { initials } from "@/lib/utils"
import { formatRating } from "../format"
import { useCourses, useInstructor } from "../hooks"
import { CourseBrowser } from "./course-browser"
import { LoadError } from "./discover-views"
import { FollowButton } from "./instructor-summary"

/** /instructors/[id] — the instructor's profile, stats and courses. */
export function InstructorView({ id }: { id: string }) {
  const t = useTranslations("catalog.instructor")
  const instructor = useInstructor(id)
  const courses = useCourses()

  const theirCourses = useMemo(() => courses.data?.filter((c) => c.instructorId === id), [courses.data, id])
  // Visitors can't read user profiles, so take the name from the courses.
  const name = instructor.data?.name || theirCourses?.[0]?.instructorName || ""
  const students = new Set(theirCourses?.flatMap((c) => c.studentIds)).size

  if (instructor.isError) {
    return (
      <div className="container-page pt-32 pb-20">
        <LoadError onRetry={() => instructor.refetch()} />
      </div>
    )
  }

  const stats = [
    { icon: PlayCircle, label: t("courses"), value: theirCourses?.length ?? 0 },
    { icon: Users, label: t("students"), value: Math.max(students, instructor.data?.studentIds.length ?? 0) },
    { icon: UserCheck, label: t("followers"), value: instructor.data?.followerIds.length ?? 0 },
    { icon: BookOpen, label: t("lessons"), value: instructor.data?.lessons ?? 0 },
  ]

  return (
    <div className="pb-16">
      <section className="grid-lines relative overflow-hidden bg-maroon pt-28 pb-24 text-white sm:pt-32">
        <div className="pointer-events-none absolute -bottom-40 -left-32 size-[460px] rounded-full bg-maroon-light/40 blur-3xl" />
        <div className="container-page relative flex flex-col items-center gap-6 text-center sm:flex-row sm:text-left">
          {instructor.isPending ? (
            <Skeleton className="size-28 rounded-full bg-white/15" />
          ) : (
            <Avatar className="size-28 ring-4 ring-white/20">
              <AvatarImage src={instructor.data?.photoUrl || undefined} alt="" />
              <AvatarFallback className="bg-cream text-3xl font-extrabold text-primary">
                {initials(name || "?")}
              </AvatarFallback>
            </Avatar>
          )}
          <div className="flex-1">
            <p className="mb-1 text-xs font-bold tracking-[0.2em] text-gold uppercase">{t("eyebrow")}</p>
            {name ? (
              <h1 className="text-3xl font-extrabold sm:text-4xl">{name}</h1>
            ) : (
              <Skeleton className="h-10 w-56 bg-white/15" />
            )}
            {instructor.data?.specialty && <p className="mt-1 text-white/75">{instructor.data.specialty}</p>}
            {!!instructor.data?.rating && (
              <p className="mt-2 inline-flex items-center gap-1.5 text-sm font-semibold">
                <Star className="size-4 text-gold" fill="currentColor" strokeWidth={0} />
                {t("rating", { rating: formatRating(instructor.data.rating) })}
              </p>
            )}
          </div>
          <div className="[&_button]:bg-white [&_button]:text-primary">
            <FollowButton instructorId={id} size="default" />
          </div>
        </div>
      </section>

      <div className="container-page relative -mt-12">
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
          {stats.map(({ icon: Icon, label, value }) => (
            <div key={label} className="rounded-3xl border border-border bg-white p-5 shadow-soft">
              <Icon className="mb-3 size-5 text-gold" />
              <p className="font-display text-3xl font-extrabold text-primary">
                <CountUp to={value} />
              </p>
              <p className="text-xs font-semibold text-muted-foreground">{label}</p>
            </div>
          ))}
        </div>

        {(instructor.data?.about || instructor.data?.education || !!instructor.data?.expertise.length) && (
          <Reveal y={20} className="mt-12 grid gap-6 lg:grid-cols-[1.4fr_1fr]">
            {instructor.data?.about && (
              <section>
                <h2 className="mb-3 font-sans text-xl font-bold">{t("about")}</h2>
                <p className="leading-[1.8] whitespace-pre-line text-muted-foreground">
                  {instructor.data.about}
                </p>
              </section>
            )}
            <div className="space-y-6">
              {instructor.data?.education && (
                <section className="rounded-3xl bg-cream p-5">
                  <h2 className="mb-2 inline-flex items-center gap-2 text-sm font-bold">
                    <GraduationCap className="size-4 text-primary" />
                    {t("education")}
                  </h2>
                  <p className="text-sm text-muted-foreground">{instructor.data.education}</p>
                </section>
              )}
              {!!instructor.data?.expertise.length && (
                <section>
                  <h2 className="mb-3 text-sm font-bold">{t("expertise")}</h2>
                  <div className="flex flex-wrap gap-2">
                    {instructor.data.expertise.map((e) => (
                      <span
                        key={e}
                        className="rounded-full bg-maroon-tint px-3 py-1.5 text-xs font-semibold text-primary"
                      >
                        {e}
                      </span>
                    ))}
                  </div>
                </section>
              )}
            </div>
          </Reveal>
        )}

        <section className="mt-12">
          <h2 className="mb-2 font-sans text-xl font-bold sm:text-2xl">
            {t("coursesBy", { name: name || "…" })}
          </h2>
          {courses.isError ? (
            <LoadError onRetry={() => courses.refetch()} />
          ) : (
            <CourseBrowser courses={theirCourses} loading={courses.isPending} />
          )}
        </section>
      </div>
    </div>
  )
}
