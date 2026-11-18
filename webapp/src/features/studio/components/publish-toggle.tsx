"use client"

import { useTranslations } from "next-intl"
import { toast } from "sonner"
import { Switch } from "@/components/ui/switch"
import type { Course } from "@/features/catalog/types"
import { usePublishCourse } from "../hooks"

/**
 * Published courses appear in the catalog for everyone. Learners who
 * already bought a course keep access while it's unpublished.
 */
export function PublishToggle({ course }: { course: Course }) {
  const t = useTranslations("studio.courses")
  const publish = usePublishCourse()
  const noLessons = course.totalLessons === 0 && !course.isPublished

  return (
    <label className="inline-flex cursor-pointer items-center gap-2 text-sm font-semibold">
      <Switch
        checked={course.isPublished}
        disabled={publish.isPending || noLessons}
        onCheckedChange={(next) =>
          publish.mutate(
            { id: course.id, publish: next },
            {
              onSuccess: () => toast.success(next ? t("publishedToast") : t("unpublishedToast")),
              onError: () => toast.error(t("saveFailed")),
            },
          )
        }
      />
      <span title={noLessons ? t("needLessons") : undefined}>{t("publishLabel")}</span>
    </label>
  )
}
