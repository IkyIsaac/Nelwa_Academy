"use client"

import { Lock, LogIn, PlayCircle } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"
import { formatSeconds } from "../format"
import { useLessons } from "../hooks"
import { type Course, type Lesson, lessonTitle } from "../types"

/**
 * The course curriculum. Lessons carry video links, so only signed-in
 * learners can load them; visitors see a sign-in prompt instead.
 * Free lessons (and every lesson once purchased) open in the player.
 */
export function LessonList({ course, owned }: { course: Course; owned: boolean }) {
  const t = useTranslations("catalog.course")
  const { status } = useAuth()
  const pathname = usePathname()
  const lessons = useLessons(course.id)

  if (status === "signed-out") {
    return (
      <EmptyState
        icon={LogIn}
        title={t("curriculumLocked", { count: course.totalLessons })}
        body={t("curriculumLockedBody")}
        action={
          <Button render={<Link href={`${routes.signUp}?next=${encodeURIComponent(pathname)}`} />}>
            {t("signUpFree")}
          </Button>
        }
      />
    )
  }

  if (status === "loading" || lessons.isPending) {
    return (
      <div className="space-y-3">
        {Array.from({ length: 4 }, (_, i) => (
          <Skeleton key={i} className="h-18 rounded-2xl" />
        ))}
      </div>
    )
  }

  if (!lessons.data?.length) {
    return <p className="rounded-2xl bg-muted px-5 py-4 text-sm text-muted-foreground">{t("noLessons")}</p>
  }

  return (
    <ol className="space-y-2.5">
      {lessons.data.map((lesson, index) => (
        <li key={lesson.id}>
          <LessonRow lesson={lesson} index={index} course={course} open={owned || lesson.isFree} />
        </li>
      ))}
    </ol>
  )
}

function LessonRow({
  lesson,
  index,
  course,
  open,
}: {
  lesson: Lesson
  index: number
  course: Course
  open: boolean
}) {
  const t = useTranslations("catalog.course")
  const locale = useLocale()

  const body = (
    <>
      <span
        className={cn(
          "grid size-10 shrink-0 place-items-center rounded-xl text-sm font-bold",
          open ? "bg-primary text-primary-foreground" : "bg-muted text-muted-foreground",
        )}
      >
        {String(index + 1).padStart(2, "0")}
      </span>
      <span className="min-w-0 flex-1">
        <span className="line-clamp-2 text-sm font-semibold">{lessonTitle(lesson, locale)}</span>
        <span className="mt-0.5 flex items-center gap-2 text-xs text-muted-foreground">
          {formatSeconds(lesson.seconds)}
          {lesson.isFree && (
            <span className="rounded-full bg-success-tint px-2 py-0.5 font-bold text-success">
              {t("freePreview")}
            </span>
          )}
        </span>
      </span>
      {open ? (
        <PlayCircle className="size-6 shrink-0 text-primary transition-transform group-hover:scale-110" />
      ) : (
        <Lock className="size-5 shrink-0 text-muted-foreground" aria-label={t("locked")} />
      )}
    </>
  )

  const className =
    "group flex items-center gap-4 rounded-2xl border border-border bg-white p-3.5 transition-all"

  return open ? (
    <Link
      href={`${routes.learnCourse(course.id)}?lesson=${lesson.id}`}
      className={cn(className, "hover:border-primary/30 hover:shadow-soft")}
    >
      {body}
    </Link>
  ) : (
    <div className={cn(className, "opacity-80")}>{body}</div>
  )
}
