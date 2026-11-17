"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { Loader2 } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Link from "next/link"
import { useRouter, useSearchParams } from "next/navigation"
import { Controller, useForm } from "react-hook-form"
import { toast } from "sonner"
import { PageEnter } from "@/components/motion/page-enter"
import { Button } from "@/components/ui/button"
import { Checkbox } from "@/components/ui/checkbox"
import { FormItem } from "@/components/ui/form-item"
import { Input } from "@/components/ui/input"
import { PasswordInput } from "@/components/ui/password-input"
import { routes } from "@/config/site"
import { signUpWithEmail } from "../api"
import { authErrorKey } from "../errors"
import { destinationAfterSignIn } from "../redirects"
import { signUpSchema, type SignUpValues } from "../schemas"
import { AuthDivider, AuthHeading } from "./auth-heading"
import { GoogleButton } from "./google-button"

export function SignUpForm() {
  const t = useTranslations("auth")
  const locale = useLocale()
  const router = useRouter()
  const next = useSearchParams().get("next")

  const {
    register,
    control,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<SignUpValues>({
    resolver: zodResolver(signUpSchema(t)),
    defaultValues: { email: "", password: "", confirmPassword: "", acceptTerms: false },
  })

  const onSubmit = async (values: SignUpValues) => {
    try {
      const user = await signUpWithEmail(values.email, values.password, locale)
      router.replace(await destinationAfterSignIn(user, next))
    } catch (error) {
      toast.error(t(`errors.${authErrorKey(error)}`))
    }
  }

  const signInHref = next ? `${routes.signIn}?next=${encodeURIComponent(next)}` : routes.signIn

  return (
    <PageEnter>
      <AuthHeading title={t("signUp.title")} subtitle={t("signUp.subtitle")} />

      <GoogleButton />
      <AuthDivider label={t("orWithEmail")} />

      <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-5">
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

        <FormItem
          label={t("password")}
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
          label={t("confirmPassword")}
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

        <FormItem error={errors.acceptTerms?.message}>
          <label className="flex cursor-pointer items-start gap-3 text-sm leading-relaxed text-muted-foreground">
            <Controller
              control={control}
              name="acceptTerms"
              render={({ field }) => (
                <Checkbox
                  className="mt-0.5"
                  checked={field.value}
                  onCheckedChange={(checked) => field.onChange(checked === true)}
                  aria-invalid={!!errors.acceptTerms}
                />
              )}
            />
            <span>
              {t.rich("signUp.terms", {
                terms: (chunks) => (
                  <Link
                    href={routes.terms}
                    target="_blank"
                    className="font-semibold text-primary hover:underline"
                  >
                    {chunks}
                  </Link>
                ),
                privacy: (chunks) => (
                  <Link
                    href={routes.privacy}
                    target="_blank"
                    className="font-semibold text-primary hover:underline"
                  >
                    {chunks}
                  </Link>
                ),
              })}
            </span>
          </label>
        </FormItem>

        <Button type="submit" size="lg" className="w-full" disabled={isSubmitting}>
          {isSubmitting && <Loader2 className="animate-spin" />}
          {t("signUp.submit")}
        </Button>
      </form>

      <p className="mt-8 text-center text-sm text-muted-foreground">
        {t("signUp.haveAccount")}{" "}
        <Link href={signInHref} className="font-semibold text-primary hover:underline">
          {t("signUp.signInLink")}
        </Link>
      </p>
    </PageEnter>
  )
}
