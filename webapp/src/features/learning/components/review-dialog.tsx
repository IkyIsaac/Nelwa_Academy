"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { Loader2, Star } from "lucide-react"
import { motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import { useState } from "react"
import { Controller, useForm } from "react-hook-form"
import { toast } from "sonner"
import { z } from "zod"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { FormItem } from "@/components/ui/form-item"
import { Textarea } from "@/components/ui/textarea"
import { useAuth } from "@/features/auth/components/auth-provider"
import { type Course, courseTitle } from "@/features/catalog/types"
import { cn } from "@/lib/utils"
import { useSubmitReview } from "../hooks"

const schema = (t: (key: string) => string) =>
  z.object({
    rating: z.number().min(1, t("review.ratingRequired")).max(5),
    comment: z.string().trim().max(1000, t("review.commentTooLong")),
  })

type Values = z.infer<ReturnType<typeof schema>>

export function ReviewDialog({ course, purchaseId }: { course: Course; purchaseId: string }) {
  const t = useTranslations("learning")
  const locale = useLocale()
  const { user, profile } = useAuth()
  const submit = useSubmitReview()
  const [open, setOpen] = useState(false)

  const {
    control,
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<Values>({ resolver: zodResolver(schema(t)), defaultValues: { rating: 0, comment: "" } })

  const onSubmit = (values: Values) =>
    submit.mutate(
      {
        uid: user!.uid,
        userName: profile?.displayName || user?.displayName || "",
        userImage: profile?.photoUrl || user?.photoURL || "",
        course,
        purchaseId,
        rating: values.rating,
        comment: values.comment.trim(),
      },
      {
        onSuccess: () => {
          toast.success(t("review.thanks"))
          setOpen(false)
          reset()
        },
        onError: () => toast.error(t("review.failed")),
      },
    )

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button className="w-full" />}>
        <Star />
        {t("review.cta")}
      </DialogTrigger>
      <DialogContent className="rounded-3xl p-6 sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="font-sans text-xl font-extrabold">{t("review.title")}</DialogTitle>
          <DialogDescription>{t("review.body", { course: courseTitle(course, locale) })}</DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-5">
          <FormItem error={errors.rating?.message}>
            <Controller
              control={control}
              name="rating"
              render={({ field }) => <StarPicker value={field.value} onChange={field.onChange} />}
            />
          </FormItem>
          <FormItem label={t("review.comment")} htmlFor="review-comment" error={errors.comment?.message}>
            <Textarea
              id="review-comment"
              rows={4}
              placeholder={t("review.placeholder")}
              aria-invalid={!!errors.comment}
              {...register("comment")}
            />
          </FormItem>
          <Button type="submit" size="lg" className="w-full" disabled={submit.isPending}>
            {submit.isPending && <Loader2 className="animate-spin" />}
            {t("review.submit")}
          </Button>
        </form>
      </DialogContent>
    </Dialog>
  )
}

function StarPicker({ value, onChange }: { value: number; onChange: (v: number) => void }) {
  const t = useTranslations("learning")
  const [hover, setHover] = useState(0)
  const shown = hover || value
  return (
    <div
      role="radiogroup"
      aria-label={t("review.rating")}
      className="flex justify-center gap-1.5"
      onMouseLeave={() => setHover(0)}
    >
      {[1, 2, 3, 4, 5].map((n) => (
        <motion.button
          key={n}
          type="button"
          role="radio"
          aria-checked={value === n}
          aria-label={t("review.stars", { count: n })}
          whileTap={{ scale: 0.85 }}
          animate={{ scale: shown >= n ? 1.08 : 1 }}
          onMouseEnter={() => setHover(n)}
          onClick={() => onChange(n)}
          className="p-1"
        >
          <Star
            className={cn("size-9 transition-colors", shown >= n ? "text-gold" : "text-border")}
            fill="currentColor"
          />
        </motion.button>
      ))}
    </div>
  )
}
