"use client"

import { ArrowLeft, ExternalLink, Loader2, SearchX, Trash2 } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useState } from "react"
import { toast } from "sonner"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { type Course, courseTitle } from "@/features/catalog/types"
import { useDeleteCourse, useMyCourse } from "../hooks"
import { CourseForm } from "./course-form"
import { LessonsManager } from "./lessons-manager"
import { PublishToggle } from "./publish-toggle"

export function NewCourse() {
  const t = useTranslations("studio.editor")
  return (
    <div className="mx-auto max-w-4xl space-y-6">
      <BackLink />
      <div>
        <h2 className="font-sans text-2xl font-extrabold">{t("newTitle")}</h2>
        <p className="mt-1 text-sm text-muted-foreground">{t("newBody")}</p>
      </div>
      <CourseForm />
    </div>
  )
}

export function CourseEditor({ courseId }: { courseId: string }) {
  const t = useTranslations("studio.editor")
  const locale = useLocale()
  const course = useMyCourse(courseId)

  if (course.isPending) {
    return (
      <div className="mx-auto max-w-4xl space-y-4">
        <Skeleton className="h-10 w-1/2" />
        <Skeleton className="h-96 rounded-3xl" />
      </div>
    )
  }
  if (!course.data) {
    return (
      <EmptyState
        icon={SearchX}
        title={t("notFoundTitle")}
        body={t("notFoundBody")}
        action={<Button render={<Link href={routes.studioCourses} />}>{t("back")}</Button>}
      />
    )
  }
  const c = course.data

  return (
    <div className="mx-auto max-w-4xl space-y-10">
      <div className="space-y-4">
        <BackLink />
        <div className="flex flex-wrap items-center justify-between gap-4">
          <h2 className="min-w-0 font-sans text-2xl font-extrabold">{courseTitle(c, locale)}</h2>
          <div className="flex items-center gap-4">
            <PublishToggle course={c} />
            <Button size="sm" variant="outline" render={<Link href={routes.course(c.id)} />}>
              <ExternalLink /> {t("view")}
            </Button>
          </div>
        </div>
        {!c.isPublished && (
          <p className="rounded-2xl bg-cream px-4 py-3 text-sm text-muted-foreground">{t("draftNote")}</p>
        )}
      </div>
      <LessonsManager courseId={c.id} />
      <CourseForm key={c.id} course={c} />
      <DangerZone course={c} />
    </div>
  )
}

function BackLink() {
  const t = useTranslations("studio.editor")
  return (
    <Link
      href={routes.studioCourses}
      className="inline-flex items-center gap-1.5 text-sm font-semibold text-muted-foreground hover:text-primary"
    >
      <ArrowLeft className="size-4" /> {t("back")}
    </Link>
  )
}

/**
 * Courses someone has bought can't be deleted: their purchase points at it.
 * Unpublishing hides it from the catalog and keeps buyers' access.
 */
function DangerZone({ course }: { course: Course }) {
  const t = useTranslations("studio.editor")
  const router = useRouter()
  const remove = useDeleteCourse()
  const [open, setOpen] = useState(false)
  const sold = course.studentIds.length > 0

  return (
    <section className="rounded-3xl border border-destructive/30 bg-white p-5 sm:p-7">
      <h2 className="font-sans text-lg font-bold text-destructive">{t("deleteTitle")}</h2>
      <p className="mt-1 text-sm text-muted-foreground">
        {sold ? t("deleteBlocked", { count: course.studentIds.length }) : t("deleteBody")}
      </p>
      <Button variant="destructive" className="mt-4" disabled={sold} onClick={() => setOpen(true)}>
        <Trash2 /> {t("deleteCta")}
      </Button>
      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="rounded-3xl p-6 sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="font-sans text-xl font-extrabold">{t("deleteConfirmTitle")}</DialogTitle>
            <DialogDescription>{t("deleteConfirmBody")}</DialogDescription>
          </DialogHeader>
          <div className="flex justify-end gap-2">
            <Button variant="outline" onClick={() => setOpen(false)}>
              {t("cancel")}
            </Button>
            <Button
              variant="destructive"
              disabled={remove.isPending}
              onClick={() =>
                remove.mutate(course, {
                  onSuccess: () => {
                    toast.success(t("deleted"))
                    router.replace(routes.studioCourses)
                  },
                  onError: () => toast.error(t("deleteFailed")),
                })
              }
            >
              {remove.isPending && <Loader2 className="animate-spin" />}
              {t("deleteForever")}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </section>
  )
}
