"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { ArrowLeft, Loader2, MailCheck } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { useState } from "react"
import { useForm } from "react-hook-form"
import { toast } from "sonner"
import { PageEnter } from "@/components/motion/page-enter"
import { Button } from "@/components/ui/button"
import { FormItem } from "@/components/ui/form-item"
import { Input } from "@/components/ui/input"
import { routes } from "@/config/site"
import { authErrorCode, sendResetEmail } from "../api"
import { authErrorKey } from "../errors"
import { forgotPasswordSchema, type ForgotPasswordValues } from "../schemas"
import { AuthHeading } from "./auth-heading"

/**
 * Asks for an email and sends Firebase's password-reset link. The link opens
 * /auth/action, where the learner chooses a new password.
 */
export function ForgotPasswordForm() {
  const t = useTranslations("auth")
  const [sentTo, setSentTo] = useState<string | null>(null)

  const {
    register,
    handleSubmit,
    getValues,
    formState: { errors, isSubmitting },
  } = useForm<ForgotPasswordValues>({
    resolver: zodResolver(forgotPasswordSchema(t)),
    defaultValues: { email: "" },
  })

  const send = async ({ email }: ForgotPasswordValues) => {
    try {
      await sendResetEmail(email)
      setSentTo(email)
    } catch (error) {
      // Don't reveal whether an account exists for this email.
      if (authErrorCode(error) === "auth/user-not-found") setSentTo(email)
      else toast.error(t(`errors.${authErrorKey(error)}`))
    }
  }

  return (
    <PageEnter>
      <Link
        href={routes.signIn}
        className="mb-8 inline-flex items-center gap-2 text-sm font-semibold text-muted-foreground hover:text-primary"
      >
        <ArrowLeft className="size-4" /> {t("backToSignIn")}
      </Link>

      <AnimatePresence mode="wait">
        {sentTo ? (
          <motion.div
            key="sent"
            initial={{ opacity: 0, scale: 0.96 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
            className="text-center"
          >
            <div className="mx-auto mb-6 grid size-20 place-items-center rounded-full bg-maroon-tint text-primary">
              <MailCheck className="size-9" />
            </div>
            <AuthHeading
              title={t("forgot.sentTitle")}
              subtitle={t.rich("forgot.sentBody", {
                email: () => <strong className="font-semibold text-foreground">{sentTo}</strong>,
              })}
            />
            <Button
              variant="outline"
              className="w-full"
              disabled={isSubmitting}
              onClick={() => send({ email: getValues("email") })}
            >
              {isSubmitting && <Loader2 className="animate-spin" />}
              {t("forgot.resend")}
            </Button>
          </motion.div>
        ) : (
          <motion.div key="form" exit={{ opacity: 0, y: -8 }}>
            <AuthHeading title={t("forgot.title")} subtitle={t("forgot.subtitle")} />
            <form onSubmit={handleSubmit(send)} noValidate className="space-y-5">
              <FormItem label={t("email")} htmlFor="email" error={errors.email?.message}>
                <Input
                  id="email"
                  type="email"
                  autoComplete="email"
                  placeholder="you@example.com"
                  aria-invalid={!!errors.email}
                  {...register("email")}
                />
              </FormItem>
              <Button type="submit" size="lg" className="w-full" disabled={isSubmitting}>
                {isSubmitting && <Loader2 className="animate-spin" />}
                {t("forgot.submit")}
              </Button>
            </form>
          </motion.div>
        )}
      </AnimatePresence>
    </PageEnter>
  )
}
