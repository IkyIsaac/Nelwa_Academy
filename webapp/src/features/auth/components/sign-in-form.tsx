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
import { signInWithEmail } from "../api"
import { authErrorKey } from "../errors"
import { destinationAfterSignIn } from "../redirects"
import { signInSchema, type SignInValues } from "../schemas"
import { AuthDivider, AuthHeading } from "./auth-heading"
import { GoogleButton } from "./google-button"

export function SignInForm() {
  const t = useTranslations("auth")
  const locale = useLocale()
  const router = useRouter()
  const next = useSearchParams().get("next")

  const {
    register,
    control,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<SignInValues>({
    resolver: zodResolver(signInSchema(t)),
    defaultValues: { email: "", password: "", rememberMe: true },
  })

  const onSubmit = async (values: SignInValues) => {
    try {
      const user = await signInWithEmail(values.email, values.password, values.rememberMe, locale)
      router.replace(await destinationAfterSignIn(user, next))
    } catch (error) {
      toast.error(t(`errors.${authErrorKey(error)}`))
    }
  }

  const signUpHref = next ? `${routes.signUp}?next=${encodeURIComponent(next)}` : routes.signUp

  return (
    <PageEnter>
      <AuthHeading title={t("signIn.title")} subtitle={t("signIn.subtitle")} />

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

        <FormItem label={t("password")} htmlFor="password" error={errors.password?.message}>
          <PasswordInput
            id="password"
            autoComplete="current-password"
            aria-invalid={!!errors.password}
            {...register("password")}
          />
        </FormItem>

        <div className="flex items-center justify-between">
          <label className="flex cursor-pointer items-center gap-2.5 text-sm">
            <Controller
              control={control}
              name="rememberMe"
              render={({ field }) => (
                <Checkbox
                  checked={field.value}
                  onCheckedChange={(checked) => field.onChange(checked === true)}
                />
              )}
            />
            {t("rememberMe")}
          </label>
          <Link href={routes.forgotPassword} className="text-sm font-semibold text-primary hover:underline">
            {t("forgotPassword")}
          </Link>
        </div>

        <Button type="submit" size="lg" className="w-full" disabled={isSubmitting}>
          {isSubmitting && <Loader2 className="animate-spin" />}
          {t("signIn.submit")}
        </Button>
      </form>

      <AuthDivider label={t("orContinueWith")} />
      <GoogleButton />

      <p className="mt-8 text-center text-sm text-muted-foreground">
        {t("signIn.noAccount")}{" "}
        <Link href={signUpHref} className="font-semibold text-primary hover:underline">
          {t("signIn.signUpLink")}
        </Link>
      </p>
    </PageEnter>
  )
}
