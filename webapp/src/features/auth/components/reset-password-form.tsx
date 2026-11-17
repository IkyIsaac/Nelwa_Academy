"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { useQuery } from "@tanstack/react-query"
import { CircleCheck, Link2Off, Loader2 } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { useState } from "react"
import { useForm } from "react-hook-form"
import { toast } from "sonner"
import { PageEnter } from "@/components/motion/page-enter"
import { Button } from "@/components/ui/button"
import { FormItem } from "@/components/ui/form-item"
import { PasswordInput } from "@/components/ui/password-input"
import { routes } from "@/config/site"
import { checkResetCode, setNewPassword } from "../api"
import { authErrorKey } from "../errors"
import { newPasswordSchema, type NewPasswordValues } from "../schemas"
import { AuthHeading } from "./auth-heading"

/** "Create new password", opened from the link in the reset email. */
export function ResetPasswordForm({ code }: { code: string }) {
  const t = useTranslations("auth")
  const [done, setDone] = useState(false)

  // Check the link first so an expired one shows a clear message up front.
  const check = useQuery({
    queryKey: ["reset-code", code],
    queryFn: () => checkResetCode(code),
    retry: false,
    staleTime: Infinity,
  })

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<NewPasswordValues>({
    resolver: zodResolver(newPasswordSchema(t)),
    defaultValues: { password: "", confirmPassword: "" },
  })

  const onSubmit = async ({ password }: NewPasswordValues) => {
    try {
      await setNewPassword(code, password)
      setDone(true)
    } catch (error) {
      toast.error(t(`errors.${authErrorKey(error)}`))
    }
  }

  if (check.isPending) {
    return (
      <div className="grid place-items-center py-20">
        <Loader2 className="size-7 animate-spin text-primary" />
      </div>
    )
  }

  if (check.isError) {
    return (
      <PageEnter className="text-center">
        <div className="mx-auto mb-6 grid size-20 place-items-center rounded-full bg-maroon-tint text-primary">
          <Link2Off className="size-9" />
        </div>
        <AuthHeading title={t("reset.expiredTitle")} subtitle={t("reset.expiredBody")} />
        <Button className="w-full" render={<Link href={routes.forgotPassword} />}>
          {t("reset.requestNew")}
        </Button>
      </PageEnter>
    )
  }

  if (done) {
    return (
      <PageEnter className="text-center">
        <div className="mx-auto mb-6 grid size-20 place-items-center rounded-full bg-success-tint text-success">
          <CircleCheck className="size-9" />
        </div>
        <AuthHeading title={t("reset.doneTitle")} subtitle={t("reset.doneBody")} />
        <Button className="w-full" render={<Link href={routes.signIn} />}>
          {t("signIn.submit")}
        </Button>
      </PageEnter>
    )
  }

  return (
    <PageEnter>
      <AuthHeading
        title={t("reset.title")}
        subtitle={t.rich("reset.subtitle", {
          email: () => <strong className="font-semibold text-foreground">{check.data}</strong>,
        })}
      />
      <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-5">
        <FormItem
          label={t("newPassword")}
          htmlFor="password"
          error={errors.password?.message}
          hint={t("passwordHint")}
        >
          <PasswordInput
            id="password"
            autoComplete="new-password"
            aria-invalid={!!errors.password}
            {...register("password")}
          />
        </FormItem>
        <FormItem
          label={t("confirmNewPassword")}
          htmlFor="confirmPassword"
          error={errors.confirmPassword?.message}
        >
          <PasswordInput
            id="confirmPassword"
            autoComplete="new-password"
            aria-invalid={!!errors.confirmPassword}
            {...register("confirmPassword")}
          />
        </FormItem>
        <Button type="submit" size="lg" className="w-full" disabled={isSubmitting}>
          {isSubmitting && <Loader2 className="animate-spin" />}
          {t("reset.submit")}
        </Button>
      </form>
    </PageEnter>
  )
}
