"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { Check, ChevronDown, Loader2, Send } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useTranslations } from "next-intl"
import { useEffect, useState } from "react"
import { useForm } from "react-hook-form"
import { toast } from "sonner"
import { z } from "zod"
import { Button } from "@/components/ui/button"
import { FormItem } from "@/components/ui/form-item"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { useAuth } from "@/features/auth/components/auth-provider"
import { sendContactMessage } from "../api"

const schema = (t: (key: string) => string, auth: (key: string) => string) =>
  z.object({
    name: z.string().trim().min(1, t("nameRequired")).max(100),
    email: z.string().trim().email(auth("validation.emailInvalid")),
    topic: z.string(),
    message: z.string().trim().min(1, t("messageRequired")).max(3000),
  })
type Values = z.infer<ReturnType<typeof schema>>

export function ContactForm() {
  const t = useTranslations("landing.contact")
  const authT = useTranslations("auth")
  const { profile, user } = useAuth()
  const [sent, setSent] = useState(false)

  const {
    register,
    handleSubmit,
    reset,
    getValues,
    formState: { errors, isSubmitting },
  } = useForm<Values>({
    resolver: zodResolver(schema(t, authT)),
    defaultValues: { name: "", email: "", topic: "", message: "" },
  })

  // Signed-in learners don't need to type their name and email.
  useEffect(() => {
    if (profile && !getValues("email")) {
      reset({ ...getValues(), name: profile.displayName, email: profile.email || user?.email || "" })
    }
  }, [profile, user, reset, getValues])

  const onSubmit = async (values: Values) => {
    try {
      await sendContactMessage(values)
      setSent(true)
      reset({ ...values, topic: "", message: "" })
      setTimeout(() => setSent(false), 4000)
    } catch {
      toast.error(t("sendFailed"))
    }
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-4">
      <FormItem error={errors.name?.message}>
        <Input
          placeholder={t("name")}
          aria-label={t("name")}
          autoComplete="name"
          aria-invalid={!!errors.name}
          {...register("name")}
        />
      </FormItem>
      <FormItem error={errors.email?.message}>
        <Input
          type="email"
          placeholder={t("email")}
          aria-label={t("email")}
          autoComplete="email"
          aria-invalid={!!errors.email}
          {...register("email")}
        />
      </FormItem>
      <div className="relative">
        <select
          aria-label={t("topic")}
          className="h-12 w-full cursor-pointer appearance-none rounded-xl border-[1.5px] border-input bg-white px-4 text-[15px] transition-[border-color,box-shadow] outline-none invalid:text-muted-foreground/70 hover:border-primary/30 focus-visible:border-primary focus-visible:ring-4 focus-visible:ring-primary/8"
          required
          {...register("topic")}
        >
          <option value="" disabled>
            {t("topic")}
          </option>
          {t("topics")
            .split("|")
            .map((topic) => (
              <option key={topic} value={topic} className="text-foreground">
                {topic}
              </option>
            ))}
        </select>
        <ChevronDown className="pointer-events-none absolute top-1/2 right-4 size-4 -translate-y-1/2 text-muted-foreground" />
      </div>
      <FormItem error={errors.message?.message}>
        <Textarea
          placeholder={t("message")}
          aria-label={t("message")}
          aria-invalid={!!errors.message}
          {...register("message")}
        />
      </FormItem>

      <Button
        type="submit"
        size="lg"
        disabled={isSubmitting || sent}
        className={sent ? "w-full bg-success hover:bg-success disabled:opacity-100" : "w-full"}
      >
        <AnimatePresence mode="wait" initial={false}>
          <motion.span
            key={sent ? "sent" : isSubmitting ? "sending" : "idle"}
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -8 }}
            className="inline-flex items-center gap-2"
          >
            {sent ? (
              <>
                <Check className="size-4" /> {t("sent")}
              </>
            ) : isSubmitting ? (
              <Loader2 className="size-4 animate-spin" />
            ) : (
              <>
                {t("send")} <Send className="size-4" />
              </>
            )}
          </motion.span>
        </AnimatePresence>
      </Button>
    </form>
  )
}
