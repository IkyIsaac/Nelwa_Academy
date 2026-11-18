"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { ArrowDown, ArrowUp, Film, Loader2, Pencil, Plus, Trash2 } from "lucide-react"
import { useTranslations } from "next-intl"
import { useState } from "react"
import { Controller, useForm, useWatch } from "react-hook-form"
import { toast } from "sonner"
import { z } from "zod"
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { FormItem } from "@/components/ui/form-item"
import { Input } from "@/components/ui/input"
import { Skeleton } from "@/components/ui/skeleton"
import { Switch } from "@/components/ui/switch"
import { Textarea } from "@/components/ui/textarea"
import { formatCourseLength, formatSeconds } from "@/features/catalog/format"
import type { Lesson } from "@/features/catalog/types"
import { useDeleteLesson, useReorderLessons, useSaveLesson, useStudioLessons } from "../hooks"
import type { LessonInput } from "../types"
import { ImageUpload, VideoUpload } from "./media-fields"
import { StudioSection } from "./studio-shell"

type Editing = { lesson?: Lesson } | null

export function LessonsManager({ courseId }: { courseId: string }) {
  const t = useTranslations("studio.lessons")
  const lessons = useStudioLessons(courseId)
  const reorder = useReorderLessons(courseId)
  const remove = useDeleteLesson(courseId)
  const [editing, setEditing] = useState<Editing>(null)
  const [deleting, setDeleting] = useState<Lesson | null>(null)

  const list = lessons.data ?? []
  const total = list.reduce((sum, l) => sum + l.seconds, 0)

  const move = (index: number, by: -1 | 1) => {
    const ids = list.map((l) => l.id)
    const [id] = ids.splice(index, 1)
    ids.splice(index + by, 0, id)
    reorder.mutate(ids, { onError: () => toast.error(t("saveFailed")) })
  }

  return (
    <StudioSection
      title={t("title")}
      action={
        <Button onClick={() => setEditing({})}>
          <Plus /> {t("add")}
        </Button>
      }
    >
      <div id="lessons" className="scroll-mt-28" />
      {lessons.isPending ? (
        <Skeleton className="h-40 rounded-3xl" />
      ) : list.length === 0 ? (
        <button
          type="button"
          onClick={() => setEditing({})}
          className="flex w-full flex-col items-center gap-2 rounded-3xl border-[1.5px] border-dashed border-border bg-white p-10 text-center text-sm text-muted-foreground hover:border-primary/40"
        >
          <Film className="size-7 text-primary" />
          <span className="font-semibold text-foreground">{t("emptyTitle")}</span>
          {t("emptyBody")}
        </button>
      ) : (
        <>
          <p className="text-sm text-muted-foreground">
            {t("summary", { count: list.length })}
            {total > 0 && ` · ${formatCourseLength(total)}`}
          </p>
          <ol className="divide-y divide-border rounded-3xl border border-border bg-white">
            {list.map((l, i) => (
              <li key={l.id} className="flex items-center gap-3 px-4 py-3 sm:px-5">
                <span className="grid size-8 shrink-0 place-items-center rounded-full bg-maroon-tint text-xs font-bold text-primary">
                  {i + 1}
                </span>
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-sm font-semibold">{l.title}</span>
                  <span className="text-xs text-muted-foreground">
                    {formatSeconds(l.seconds) || t("noLength")}
                    {l.isFree && <span className="ml-2 font-semibold text-success">{t("free")}</span>}
                    {!l.videoUrl && (
                      <span className="ml-2 font-semibold text-destructive">{t("noVideo")}</span>
                    )}
                  </span>
                </span>
                <span className="flex shrink-0 items-center">
                  <Button
                    size="icon"
                    variant="ghost"
                    aria-label={t("moveUp")}
                    disabled={i === 0 || reorder.isPending}
                    onClick={() => move(i, -1)}
                  >
                    <ArrowUp />
                  </Button>
                  <Button
                    size="icon"
                    variant="ghost"
                    aria-label={t("moveDown")}
                    disabled={i === list.length - 1 || reorder.isPending}
                    onClick={() => move(i, 1)}
                  >
                    <ArrowDown />
                  </Button>
                  <Button
                    size="icon"
                    variant="ghost"
                    aria-label={t("edit")}
                    onClick={() => setEditing({ lesson: l })}
                  >
                    <Pencil />
                  </Button>
                  <Button
                    size="icon"
                    variant="ghost"
                    aria-label={t("delete")}
                    className="hover:text-destructive"
                    onClick={() => setDeleting(l)}
                  >
                    <Trash2 />
                  </Button>
                </span>
              </li>
            ))}
          </ol>
        </>
      )}

      {editing && (
        <LessonDialog
          courseId={courseId}
          lesson={editing.lesson}
          nextOrder={list.length + 1}
          onClose={() => setEditing(null)}
        />
      )}

      <Dialog open={!!deleting} onOpenChange={(open) => !open && setDeleting(null)}>
        <DialogContent className="rounded-3xl p-6 sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="font-sans text-xl font-extrabold">{t("deleteTitle")}</DialogTitle>
            <DialogDescription>{t("deleteBody", { title: deleting?.title ?? "" })}</DialogDescription>
          </DialogHeader>
          <div className="flex justify-end gap-2">
            <Button variant="outline" onClick={() => setDeleting(null)}>
              {t("cancel")}
            </Button>
            <Button
              variant="destructive"
              disabled={remove.isPending}
              onClick={() =>
                deleting &&
                remove.mutate(deleting.id, {
                  onSuccess: () => {
                    toast.success(t("deleted"))
                    setDeleting(null)
                  },
                  onError: () => toast.error(t("saveFailed")),
                })
              }
            >
              {remove.isPending && <Loader2 className="animate-spin" />}
              {t("delete")}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </StudioSection>
  )
}

const lessonSchema = (t: (key: string) => string) =>
  z.object({
    title: z.string().trim().min(2, t("errors.title")).max(120, t("errors.tooLong")),
    titleSw: z.string().trim().max(120, t("errors.tooLong")),
    description: z.string().trim().max(3000, t("errors.tooLong")),
    descriptionSw: z.string().trim().max(3000, t("errors.tooLong")),
    videoUrl: z.string().min(1, t("errors.video")),
    image: z.string(),
    seconds: z.number().min(0),
    isFree: z.boolean(),
  })

function LessonDialog({
  courseId,
  lesson,
  nextOrder,
  onClose,
}: {
  courseId: string
  lesson?: Lesson
  nextOrder: number
  onClose: () => void
}) {
  const t = useTranslations("studio.lessons")
  const save = useSaveLesson(courseId)
  const {
    register,
    control,
    handleSubmit,
    setValue,
    formState: { errors },
  } = useForm<LessonInput>({
    resolver: zodResolver(lessonSchema(t)),
    defaultValues: {
      title: lesson?.title ?? "",
      titleSw: lesson?.titleSw ?? "",
      description: lesson?.description ?? "",
      descriptionSw: lesson?.descriptionSw ?? "",
      videoUrl: lesson?.videoUrl ?? "",
      image: lesson?.image ?? "",
      seconds: lesson?.seconds ?? 0,
      isFree: lesson?.isFree ?? false,
    },
  })
  const seconds = useWatch({ control, name: "seconds" })

  const onSubmit = (input: LessonInput) =>
    save.mutate(
      { id: lesson?.id, input, order: nextOrder },
      {
        onSuccess: () => {
          toast.success(lesson ? t("saved") : t("added"))
          onClose()
        },
        onError: () => toast.error(t("saveFailed")),
      },
    )

  return (
    <Dialog open onOpenChange={(open) => !open && !save.isPending && onClose()}>
      <DialogContent className="max-h-[90dvh] overflow-y-auto rounded-3xl p-6 sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle className="font-sans text-xl font-extrabold">
            {lesson ? t("editTitle") : t("addTitle")}
          </DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-5">
          <FormItem
            label={t("video")}
            error={errors.videoUrl?.message}
            hint={seconds ? t("length", { length: formatSeconds(seconds) }) : undefined}
          >
            <Controller
              control={control}
              name="videoUrl"
              render={({ field }) => (
                <VideoUpload
                  value={field.value}
                  onChange={field.onChange}
                  onDuration={(s) => setValue("seconds", s)}
                  kind="lesson"
                  invalid={!!errors.videoUrl}
                />
              )}
            />
          </FormItem>
          <FormItem label={t("lessonTitle")} htmlFor="l-title" error={errors.title?.message}>
            <Input id="l-title" aria-invalid={!!errors.title} {...register("title")} />
          </FormItem>
          <FormItem label={t("description")} htmlFor="l-desc" error={errors.description?.message}>
            <Textarea id="l-desc" rows={4} {...register("description")} />
          </FormItem>
          <details className="rounded-2xl border border-border p-4">
            <summary className="cursor-pointer text-sm font-semibold">{t("swahili")}</summary>
            <div className="mt-4 space-y-5">
              <FormItem label={t("lessonTitleSw")} htmlFor="l-title-sw">
                <Input id="l-title-sw" {...register("titleSw")} />
              </FormItem>
              <FormItem label={t("descriptionSw")} htmlFor="l-desc-sw">
                <Textarea id="l-desc-sw" rows={3} {...register("descriptionSw")} />
              </FormItem>
            </div>
          </details>
          <FormItem label={t("thumbnail")} hint={t("thumbnailHint")}>
            <Controller
              control={control}
              name="image"
              render={({ field }) => (
                <ImageUpload value={field.value} onChange={field.onChange} kind="lesson" />
              )}
            />
          </FormItem>
          <Controller
            control={control}
            name="isFree"
            render={({ field }) => (
              <label className="flex items-start gap-3 rounded-2xl border border-border p-4">
                <Switch checked={field.value} onCheckedChange={field.onChange} className="mt-0.5" />
                <span>
                  <span className="block text-sm font-semibold">{t("freeLabel")}</span>
                  <span className="text-xs text-muted-foreground">{t("freeHint")}</span>
                </span>
              </label>
            )}
          />
          <div className="flex justify-end gap-2 pt-2">
            <Button type="button" variant="outline" onClick={onClose} disabled={save.isPending}>
              {t("cancel")}
            </Button>
            <Button type="submit" disabled={save.isPending}>
              {save.isPending && <Loader2 className="animate-spin" />}
              {lesson ? t("save") : t("addLesson")}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  )
}
