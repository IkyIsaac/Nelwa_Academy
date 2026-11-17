import { z } from "zod"

/**
 * Form rules, matching the mobile app (valid email, passwords of 6+ characters).
 * Each schema takes `t` so its error messages come out in the learner's language.
 */
type T = (key: string) => string

const email = (t: T) =>
  z.string().trim().min(1, t("validation.emailRequired")).email(t("validation.emailInvalid"))
const password = (t: T) => z.string().min(6, t("validation.passwordShort"))

export const signInSchema = (t: T) =>
  z.object({
    email: email(t),
    password: z.string().min(1, t("validation.passwordRequired")),
    rememberMe: z.boolean(),
  })

export const signUpSchema = (t: T) =>
  z
    .object({
      email: email(t),
      password: password(t),
      confirmPassword: z.string(),
      acceptTerms: z.boolean().refine((v) => v, t("validation.acceptTerms")),
    })
    .refine((v) => v.password === v.confirmPassword, {
      path: ["confirmPassword"],
      message: t("validation.passwordsDontMatch"),
    })

export const forgotPasswordSchema = (t: T) => z.object({ email: email(t) })

export const newPasswordSchema = (t: T) =>
  z
    .object({ password: password(t), confirmPassword: z.string() })
    .refine((v) => v.password === v.confirmPassword, {
      path: ["confirmPassword"],
      message: t("validation.passwordsDontMatch"),
    })

export type SignInValues = z.infer<ReturnType<typeof signInSchema>>
export type SignUpValues = z.infer<ReturnType<typeof signUpSchema>>
export type ForgotPasswordValues = z.infer<ReturnType<typeof forgotPasswordSchema>>
export type NewPasswordValues = z.infer<ReturnType<typeof newPasswordSchema>>
