"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { CheckCircle2, ImagePlus, Loader2, ReceiptText, X } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useEffect, useMemo, useState } from "react"
import { Controller, useForm } from "react-hook-form"
import { toast } from "sonner"
import { z } from "zod"
import { EmptyState } from "@/components/empty-state"
import { PageHeader } from "@/components/layout/page-header"
import { Button } from "@/components/ui/button"
import { FormItem } from "@/components/ui/form-item"
import { Skeleton } from "@/components/ui/skeleton"
import { Textarea } from "@/components/ui/textarea"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { formatPrice } from "@/features/catalog/format"
import { useCourse } from "@/features/catalog/hooks"
import { type Course, courseTitle } from "@/features/catalog/types"
import { cn } from "@/lib/utils"
import { uploadRefundScreenshot } from "../api"
import { useCourseAccess, useRefundRequest, useRequestRefund } from "../hooks"
import { REFUND_REASONS, type RefundReasonId } from "../types"

const MAX_SCREENSHOT_BYTES = 5 * 1024 * 1024

const schema = (t: (key: string) => string) =>
  z.object({
    reason: z.enum(REFUND_REASONS.map((r) => r.id) as [RefundReasonId, ...RefundReasonId[]], {
      error: t("refund.reasonRequired"),
    }),
    comment: z.string().trim().max(1000, t("refund.commentTooLong")),
  })

type Values = z.infer<ReturnType<typeof schema>>

export function RefundView({ courseId }: { courseId: string }) {
  const t = useTranslations("learning")
  const course = useCourse(courseId)
  const access = useCourseAccess(course.data ?? undefined)
  const existing = useRefundRequest(courseId)
  const back = { href: routes.learnCourse(courseId), label: t("backToCourse") }

  const loading = course.isPending || access.loading || existing.isPending
  return (
    <>
      <PageHeader title={t("refund.title")} description={t("refund.subtitle")} back={back} />
      <div className="container-page max-w-3xl py-10">
        {loading ? (
          <Skeleton className="h-96 rounded-3xl" />
        ) : !course.data || !access.purchase || course.data.price <= 0 ? (
          <EmptyState
            icon={ReceiptText}
            title={t("refund.notEligible")}
            body={t("refund.notEligibleBody")}
            action={<Button render={<Link href={routes.learn} />}>{t("myCourses")}</Button>}
          />
        ) : existing.data ? (
          <EmptyState
            icon={CheckCircle2}
            title={t("refund.alreadyRequested")}
            body={t("refundStatus", { status: existing.data.status })}
            action={
              <Button render={<Link href={routes.learnCourse(courseId)} />}>{t("backToCourse")}</Button>
            }
          />
        ) : (
          <RefundForm course={course.data} />
        )}
      </div>
    </>
  )
}

function RefundForm({ course }: { course: Course }) {
  const t = useTranslations("learning")
  const locale = useLocale()
  const router = useRouter()
  const { user } = useAuth()
  const request = useRequestRefund()
  const [file, setFile] = useState<File | null>(null)
  const [fileError, setFileError] = useState("")
  const [uploading, setUploading] = useState(false)

  const preview = useMemo(() => (file ? URL.createObjectURL(file) : ""), [file])
  useEffect(() => () => void (preview && URL.revokeObjectURL(preview)), [preview])

  const {
    control,
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<Values>({ resolver: zodResolver(schema(t)), defaultValues: { comment: "" } })

  const pickFile = (f: File | undefined) => {
    setFileError("")
    if (!f) return
    if (!f.type.startsWith("image/")) return setFileError(t("refund.imageOnly"))
    if (f.size > MAX_SCREENSHOT_BYTES) return setFileError(t("refund.imageTooBig"))
    setFile(f)
  }

  const onSubmit = async (values: Values) => {
    try {
      setUploading(!!file)
      const screenshotUrl = file ? await uploadRefundScreenshot(user!.uid, file) : ""
      setUploading(false)
      await request.mutateAsync({
        uid: user!.uid,
        course,
        reason: REFUND_REASONS.find((r) => r.id === values.reason)!.stored,
        comment: values.comment.trim(),
        screenshotUrl,
      })
      toast.success(t("refund.sent"))
      router.push(routes.learnCourse(course.id))
    } catch {
      setUploading(false)
      toast.error(t("refund.failed"))
    }
  }

  const busy = uploading || request.isPending

  return (
    <motion.form
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      onSubmit={handleSubmit(onSubmit)}
      noValidate
      className="space-y-8 rounded-3xl border border-border bg-white p-5 sm:p-8"
    >
      <div className="flex items-center justify-between gap-4 rounded-2xl bg-cream px-4 py-3">
        <p className="line-clamp-1 text-sm font-semibold">{courseTitle(course, locale)}</p>
        <p className="shrink-0 font-bold text-primary">{formatPrice(course.price)}</p>
      </div>

      <FormItem label={t("refund.reason")} error={errors.reason?.message}>
        <Controller
          control={control}
          name="reason"
          render={({ field }) => (
            <div role="radiogroup" aria-label={t("refund.reason")} className="grid gap-2.5">
              {REFUND_REASONS.map((r) => (
                <button
                  key={r.id}
                  type="button"
                  role="radio"
                  aria-checked={field.value === r.id}
                  onClick={() => field.onChange(r.id)}
                  className={cn(
                    "flex items-center gap-3 rounded-2xl border-[1.5px] px-4 py-3 text-left text-sm transition-all",
                    field.value === r.id
                      ? "border-primary bg-maroon-tint font-semibold"
                      : "border-border hover:border-primary/40",
                  )}
                >
                  <span
                    className={cn(
                      "grid size-5 shrink-0 place-items-center rounded-full border-2",
                      field.value === r.id ? "border-primary" : "border-border",
                    )}
                  >
                    {field.value === r.id && <span className="size-2.5 rounded-full bg-primary" />}
                  </span>
                  {t(`refund.reasons.${r.id}`)}
                </button>
              ))}
            </div>
          )}
        />
      </FormItem>

      <FormItem label={t("refund.screenshot")} hint={t("refund.screenshotHint")} error={fileError}>
        <AnimatePresence mode="wait" initial={false}>
          {preview ? (
            <motion.div
              key="preview"
              initial={{ opacity: 0, scale: 0.97 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0 }}
              className="relative w-fit"
            >
              {/* eslint-disable-next-line @next/next/no-img-element -- local blob preview */}
              <img src={preview} alt="" className="max-h-56 rounded-2xl border border-border" />
              <button
                type="button"
                onClick={() => setFile(null)}
                aria-label={t("refund.removeImage")}
                className="absolute -top-2 -right-2 grid size-7 place-items-center rounded-full bg-foreground text-white shadow"
              >
                <X className="size-4" />
              </button>
            </motion.div>
          ) : (
            <motion.label
              key="pick"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="flex cursor-pointer flex-col items-center gap-2 rounded-2xl border-2 border-dashed border-border px-6 py-8 text-center text-sm text-muted-foreground transition-colors hover:border-primary/40 hover:bg-cream/60"
            >
              <ImagePlus className="size-7 text-primary" />
              {t("refund.addImage")}
              <input
                type="file"
                accept="image/*"
                className="sr-only"
                onChange={(e) => pickFile(e.target.files?.[0])}
              />
            </motion.label>
          )}
        </AnimatePresence>
      </FormItem>

      <FormItem label={t("refund.comment")} htmlFor="refund-comment" error={errors.comment?.message}>
        <Textarea
          id="refund-comment"
          rows={4}
          placeholder={t("refund.commentPlaceholder")}
          {...register("comment")}
        />
      </FormItem>

      <div>
        <Button type="submit" size="lg" className="w-full sm:w-auto" disabled={busy}>
          {busy && <Loader2 className="animate-spin" />}
          {uploading ? t("refund.uploading") : t("refund.submit")}
        </Button>
        <p className="mt-3 text-xs text-muted-foreground">{t("refund.note")}</p>
      </div>
    </motion.form>
  )
}
