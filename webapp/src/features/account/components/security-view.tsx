"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { KeyRound, Loader2, Trash2 } from "lucide-react"
import { useTranslations } from "next-intl"
import { useRouter } from "next/navigation"
import { useState } from "react"
import { useForm } from "react-hook-form"
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
import { PasswordInput } from "@/components/ui/password-input"
import { routes } from "@/config/site"
import { authErrorCode } from "@/features/auth/api"
import { useAuth } from "@/features/auth/components/auth-provider"
import { changePassword, deleteAccount, signsInWithPassword } from "../api"

/** Turns Firebase re-authentication errors into a message for the learner. */
function useAuthMessage() {
  const t = useTranslations("account.security.errors")
  return (error: unknown) => {
    const code = authErrorCode(error)
    if (code === "auth/invalid-credential" || code === "auth/wrong-password") return t("wrongPassword")
    if (code === "auth/too-many-requests") return t("tooMany")
    if (code === "auth/popup-closed-by-user" || code === "auth/cancelled-popup-request")
      return t("popupClosed")
    if (code === "auth/user-mismatch") return t("wrongAccount")
    return t("generic")
  }
}

export function SecurityView() {
  const { user } = useAuth()
  if (!user) return null
  return (
    <div className="space-y-6">
      <PasswordSection />
      <DeleteSection />
    </div>
  )
}

function PasswordSection() {
  const t = useTranslations("account.security")
  const { user } = useAuth()
  const message = useAuthMessage()

  const schema = z
    .object({
      current: z.string().min(1, t("validation.currentRequired")),
      next: z.string().min(6, t("validation.short")),
      confirm: z.string(),
    })
    .refine((v) => v.next === v.confirm, { path: ["confirm"], message: t("validation.mismatch") })
  type Values = z.infer<typeof schema>

  const {
    register,
    handleSubmit,
    reset,
    setError,
    formState: { errors, isSubmitting },
  } = useForm<Values>({
    resolver: zodResolver(schema),
    defaultValues: { current: "", next: "", confirm: "" },
  })

  if (!signsInWithPassword(user!)) {
    return (
      <section className="rounded-3xl border border-border bg-white p-5 sm:p-8">
        <h2 className="flex items-center gap-2 font-sans text-lg font-bold">
          <KeyRound className="size-5 text-primary" />
          {t("password")}
        </h2>
        <p className="mt-2 text-sm text-muted-foreground">{t("googleAccount")}</p>
      </section>
    )
  }

  const onSubmit = async (values: Values) => {
    try {
      await changePassword(user!, values.current, values.next)
      reset()
      toast.success(t("passwordChanged"))
    } catch (error) {
      setError("current", { message: message(error) })
    }
  }

  return (
    <form
      onSubmit={handleSubmit(onSubmit)}
      noValidate
      className="space-y-5 rounded-3xl border border-border bg-white p-5 sm:p-8"
    >
      <div>
        <h2 className="flex items-center gap-2 font-sans text-lg font-bold">
          <KeyRound className="size-5 text-primary" />
          {t("password")}
        </h2>
        <p className="mt-1 text-sm text-muted-foreground">{t("passwordBody")}</p>
      </div>
      <FormItem label={t("current")} htmlFor="current" error={errors.current?.message}>
        <PasswordInput
          id="current"
          autoComplete="current-password"
          aria-invalid={!!errors.current}
          {...register("current")}
        />
      </FormItem>
      <div className="grid gap-5 sm:grid-cols-2">
        <FormItem label={t("new")} htmlFor="next" error={errors.next?.message}>
          <PasswordInput
            id="next"
            autoComplete="new-password"
            aria-invalid={!!errors.next}
            {...register("next")}
          />
        </FormItem>
        <FormItem label={t("confirm")} htmlFor="confirm" error={errors.confirm?.message}>
          <PasswordInput
            id="confirm"
            autoComplete="new-password"
            aria-invalid={!!errors.confirm}
            {...register("confirm")}
          />
        </FormItem>
      </div>
      <Button type="submit" disabled={isSubmitting}>
        {isSubmitting && <Loader2 className="animate-spin" />}
        {t("changePassword")}
      </Button>
    </form>
  )
}

function DeleteSection() {
  const t = useTranslations("account.security")
  const { user } = useAuth()
  const router = useRouter()
  const message = useAuthMessage()
  const [password, setPassword] = useState("")
  const [error, setError] = useState("")
  const [busy, setBusy] = useState(false)
  const needsPassword = signsInWithPassword(user!)

  const confirm = async () => {
    setError("")
    setBusy(true)
    try {
      await deleteAccount(user!, password)
      toast.success(t("deleted"))
      router.replace(routes.landing)
    } catch (e) {
      setError(message(e))
      setBusy(false)
    }
  }

  return (
    <section className="rounded-3xl border border-destructive/30 bg-white p-5 sm:p-8">
      <h2 className="flex items-center gap-2 font-sans text-lg font-bold text-destructive">
        <Trash2 className="size-5" />
        {t("deleteTitle")}
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">{t("deleteBody")}</p>
      <Dialog>
        <DialogTrigger render={<Button variant="destructive" className="mt-5" />}>
          {t("deleteCta")}
        </DialogTrigger>
        <DialogContent className="rounded-3xl p-6 sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="font-sans text-xl font-extrabold">{t("deleteConfirmTitle")}</DialogTitle>
            <DialogDescription>{t("deleteConfirmBody")}</DialogDescription>
          </DialogHeader>
          {needsPassword && (
            <FormItem label={t("current")} htmlFor="delete-password">
              <PasswordInput
                id="delete-password"
                autoComplete="current-password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </FormItem>
          )}
          {!needsPassword && <p className="text-sm text-muted-foreground">{t("deleteGoogle")}</p>}
          {error && (
            <p role="alert" className="text-sm font-medium text-destructive">
              {error}
            </p>
          )}
          <Button
            className="w-full bg-destructive text-white hover:bg-destructive/90"
            disabled={busy || (needsPassword && !password)}
            onClick={confirm}
          >
            {busy && <Loader2 className="animate-spin" />}
            {t("deleteForever")}
          </Button>
        </DialogContent>
      </Dialog>
    </section>
  )
}
