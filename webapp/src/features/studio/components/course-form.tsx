"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { Check, Loader2, Plus } from "lucide-react"
import { useTranslations } from "next-intl"
import { useRouter } from "next/navigation"
import { useState } from "react"
import { Controller, useForm } from "react-hook-form"
import { toast } from "sonner"
import { z } from "zod"
import { Button } from "@/components/ui/button"
import { FormItem } from "@/components/ui/form-item"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { routes } from "@/config/site"
import { useCatalogOptions } from "@/features/catalog/hooks"
import type { Course } from "@/features/catalog/types"
import { cn } from "@/lib/utils"
import { useSaveCourse } from "../hooks"
import { COURSE_GROUPS, COURSE_LANGUAGES, type CourseInput } from "../types"
import { ImageUpload, VideoUpload } from "./media-fields"
import { NativeSelect } from "./studio-shell"

const schema = (t: (key: string) => string) =>
  z
    .object({
      title: z.string().trim().min(3, t("errors.title")).max(120, t("errors.tooLong")),
      titleSw: z.string().trim().max(120, t("errors.tooLong")),
      description: z.string().trim().min(20, t("errors.description")).max(5000, t("errors.tooLong")),
      descriptionSw: z.string().trim().max(5000, t("errors.tooLong")),
      category: z.string().min(1, t("errors.category")),
      group: z.string().min(1),
      languageCode: z.string().min(1),
      tags: z.array(z.string()),
      audience: z.array(z.string()),
      price: z.number({ error: t("errors.price") }).min(0, t("errors.price")),
      yearPrice: z.number({ error: t("errors.price") }).min(0, t("errors.price")),
      image: z.string().min(1, t("errors.image")),
      previewVideo: z.string(),
    })
    .refine((v) => v.price === 0 || v.price >= 500, { path: ["price"], message: t("errors.minPrice") })

function toInput(course?: Course): CourseInput {
  return {
    title: course?.title ?? "",
    titleSw: course?.titleSw ?? "",
    description: course?.description ?? "",
    descriptionSw: course?.descriptionSw ?? "",
    category: course?.category ?? "",
    group: course?.group || COURSE_GROUPS[0],
    languageCode: course?.language.code || "en",
    tags: course?.tags ?? [],
    audience: course?.audience ?? [],
    price: course?.price ?? 0,
    yearPrice: course?.yearPrice ?? 0,
    image: course?.image ?? "",
    previewVideo: course?.previewVideo ?? "",
  }
}

/** Create or edit a course. Same fields as the mobile "Create new course" screen. */
export function CourseForm({ course }: { course?: Course }) {
  const t = useTranslations("studio.form")
  const router = useRouter()
  const options = useCatalogOptions()
  const save = useSaveCourse()

  const {
    register,
    control,
    handleSubmit,
    reset,
    formState: { errors, isDirty },
  } = useForm<CourseInput>({ resolver: zodResolver(schema(t)), defaultValues: toInput(course) })

  const onSubmit = (input: CourseInput) =>
    save.mutate(
      { id: course?.id, input },
      {
        onSuccess: (id) => {
          if (course) {
            toast.success(t("saved"))
            reset(input)
          } else {
            toast.success(t("created"))
            router.replace(`${routes.studioCourse(id)}#lessons`)
          }
        },
        onError: () => toast.error(t("saveFailed")),
      },
    )

  const categories = options.data?.categories.map((c) => c.name) ?? []
  // Keep a category that's no longer in the options list selectable.
  if (course?.category && !categories.includes(course.category)) categories.unshift(course.category)

  return (
    <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-8">
      <Card title={t("basics")}>
        <FormItem label={t("title")} htmlFor="s-title" error={errors.title?.message}>
          <Input id="s-title" aria-invalid={!!errors.title} {...register("title")} />
        </FormItem>
        <FormItem label={t("description")} htmlFor="s-desc" error={errors.description?.message}>
          <Textarea id="s-desc" rows={6} aria-invalid={!!errors.description} {...register("description")} />
        </FormItem>
        <details className="group rounded-2xl border border-border p-4">
          <summary className="cursor-pointer text-sm font-semibold">{t("swahili")}</summary>
          <div className="mt-4 space-y-5">
            <FormItem label={t("titleSw")} htmlFor="s-title-sw" error={errors.titleSw?.message}>
              <Input id="s-title-sw" {...register("titleSw")} />
            </FormItem>
            <FormItem label={t("descriptionSw")} htmlFor="s-desc-sw" error={errors.descriptionSw?.message}>
              <Textarea id="s-desc-sw" rows={5} {...register("descriptionSw")} />
            </FormItem>
          </div>
        </details>
        <div className="grid gap-5 sm:grid-cols-3">
          <FormItem label={t("category")} htmlFor="s-cat" error={errors.category?.message}>
            <NativeSelect id="s-cat" aria-invalid={!!errors.category} {...register("category")}>
              <option value="">{t("choose")}</option>
              {categories.map((c) => (
                <option key={c} value={c}>
                  {c}
                </option>
              ))}
            </NativeSelect>
          </FormItem>
          <FormItem label={t("language")} htmlFor="s-lang">
            <NativeSelect id="s-lang" {...register("languageCode")}>
              {COURSE_LANGUAGES.map((l) => (
                <option key={l.code} value={l.code}>
                  {l.name}
                </option>
              ))}
            </NativeSelect>
          </FormItem>
          <FormItem label={t("group")} htmlFor="s-group" hint={t("groupHint")}>
            <NativeSelect id="s-group" {...register("group")}>
              {COURSE_GROUPS.map((g) => (
                <option key={g} value={g}>
                  {t(`groups.${g === "New Courses" ? "new" : "recommended"}`)}
                </option>
              ))}
            </NativeSelect>
          </FormItem>
        </div>
      </Card>

      <Card title={t("media")}>
        <div className="grid gap-6 md:grid-cols-2">
          <FormItem label={t("cover")} error={errors.image?.message}>
            <Controller
              control={control}
              name="image"
              render={({ field }) => (
                <ImageUpload
                  value={field.value}
                  onChange={field.onChange}
                  kind="course"
                  invalid={!!errors.image}
                />
              )}
            />
          </FormItem>
          <FormItem label={t("preview")} hint={t("previewHint")}>
            <Controller
              control={control}
              name="previewVideo"
              render={({ field }) => (
                <VideoUpload value={field.value} onChange={field.onChange} kind="preview" />
              )}
            />
          </FormItem>
        </div>
      </Card>

      <Card title={t("pricing")}>
        <div className="grid gap-5 sm:grid-cols-2">
          <FormItem label={t("price")} htmlFor="s-price" hint={t("priceHint")} error={errors.price?.message}>
            <Input
              id="s-price"
              type="number"
              inputMode="numeric"
              min={0}
              step={100}
              aria-invalid={!!errors.price}
              {...register("price", { valueAsNumber: true })}
            />
          </FormItem>
          <FormItem
            label={t("yearPrice")}
            htmlFor="s-year"
            hint={t("yearPriceHint")}
            error={errors.yearPrice?.message}
          >
            <Input
              id="s-year"
              type="number"
              inputMode="numeric"
              min={0}
              step={100}
              {...register("yearPrice", { valueAsNumber: true })}
            />
          </FormItem>
        </div>
      </Card>

      <Card title={t("discovery")}>
        <FormItem label={t("tags")} hint={t("tagsHint")}>
          <Controller
            control={control}
            name="tags"
            render={({ field }) => (
              <ChipPicker
                value={field.value}
                onChange={field.onChange}
                options={options.data?.tags ?? []}
                allowNew
              />
            )}
          />
        </FormItem>
        <FormItem label={t("audience")} hint={t("audienceHint")}>
          <Controller
            control={control}
            name="audience"
            render={({ field }) => (
              <ChipPicker
                value={field.value}
                onChange={field.onChange}
                options={options.data?.audiences ?? []}
              />
            )}
          />
        </FormItem>
      </Card>

      <div className="sticky bottom-24 z-10 flex justify-end gap-3 md:bottom-4">
        <Button
          type="submit"
          size="lg"
          disabled={save.isPending || (!!course && !isDirty)}
          className="shadow-lift"
        >
          {save.isPending && <Loader2 className="animate-spin" />}
          {course ? t("save") : t("create")}
        </Button>
      </div>
    </form>
  )
}

function Card({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="space-y-5 rounded-3xl border border-border bg-white p-5 sm:p-7">
      <h2 className="font-sans text-lg font-bold">{title}</h2>
      {children}
    </section>
  )
}

/** Pick from a list of suggestions; optionally add your own. */
function ChipPicker({
  value,
  onChange,
  options,
  allowNew = false,
}: {
  value: string[]
  onChange: (next: string[]) => void
  options: string[]
  allowNew?: boolean
}) {
  const t = useTranslations("studio.form")
  const [draft, setDraft] = useState("")
  const all = [...new Set([...options, ...value])]
  const toggle = (v: string) => onChange(value.includes(v) ? value.filter((x) => x !== v) : [...value, v])
  const add = () => {
    const v = draft.trim()
    if (v && !value.includes(v)) onChange([...value, v])
    setDraft("")
  }

  return (
    <div className="space-y-3">
      <div className="flex flex-wrap gap-2">
        {all.map((o) => {
          const on = value.includes(o)
          return (
            <button
              key={o}
              type="button"
              aria-pressed={on}
              onClick={() => toggle(o)}
              className={cn(
                "inline-flex items-center gap-1 rounded-full border-[1.5px] px-3 py-1.5 text-sm font-medium transition-colors",
                on ? "border-primary bg-maroon-tint text-primary" : "border-border hover:border-primary/40",
              )}
            >
              {on && <Check className="size-3.5" />}
              {o}
            </button>
          )
        })}
      </div>
      {allowNew && (
        <div className="flex max-w-sm gap-2">
          <Input
            value={draft}
            onChange={(e) => setDraft(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                e.preventDefault()
                add()
              }
            }}
            placeholder={t("newTag")}
            className="h-10"
          />
          <Button type="button" variant="outline" onClick={add} disabled={!draft.trim()}>
            <Plus />
          </Button>
        </div>
      )}
    </div>
  )
}
