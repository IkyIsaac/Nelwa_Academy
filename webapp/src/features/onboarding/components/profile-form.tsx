"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { ArrowRight, Loader2 } from "lucide-react"
import { useTranslations } from "next-intl"
import { useRouter, useSearchParams } from "next/navigation"
import { useEffect, useState } from "react"
import { Controller, useForm, useWatch } from "react-hook-form"
import { toast } from "sonner"
import { z } from "zod"
import { CountryPicker } from "@/components/country-picker"
import { Button } from "@/components/ui/button"
import { FormItem } from "@/components/ui/form-item"
import { Input } from "@/components/ui/input"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { uploadAvatar, saveProfile } from "../api"
import { AvatarPicker } from "./avatar-picker"

const schema = (t: (key: string) => string) =>
  z.object({
    displayName: z.string().trim().min(2, t("nameRequired")).max(60),
    dateOfBirth: z.string().refine((v) => !v || new Date(v) < new Date(), t("dobInFuture")),
    country: z.string(),
  })
type Values = z.infer<ReturnType<typeof schema>>

const toDateInput = (d: Date | null) => (d ? d.toISOString().slice(0, 10) : "")

/** Step 1 of onboarding: name, photo, date of birth, country. */
export function ProfileForm() {
  const t = useTranslations("onboarding.profile")
  const router = useRouter()
  const next = useSearchParams().get("next")
  const { user, profile } = useAuth()
  const [photo, setPhoto] = useState<File | null>(null)

  const {
    register,
    control,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting, isDirty },
  } = useForm<Values>({
    resolver: zodResolver(schema(t)),
    defaultValues: { displayName: "", dateOfBirth: "", country: "" },
  })

  const displayName = useWatch({ control, name: "displayName" })

  // Fill in what we already know (e.g. name from Google) once the profile loads.
  useEffect(() => {
    if (profile && !isDirty) {
      reset({
        displayName: profile.displayName || user?.displayName || "",
        dateOfBirth: toDateInput(profile.dateOfBirth),
        country: profile.country || "Tanzania",
      })
    }
  }, [profile, user, isDirty, reset])

  const onSubmit = async (values: Values) => {
    if (!user) return
    try {
      const photoUrl = photo ? await uploadAvatar(user.uid, photo) : profile?.photoUrl || user.photoURL || ""
      await saveProfile(user.uid, {
        displayName: values.displayName,
        photoUrl,
        dateOfBirth: values.dateOfBirth ? new Date(values.dateOfBirth) : null,
        country: values.country,
      })
      router.push(next ? `${routes.interests}?next=${encodeURIComponent(next)}` : routes.interests)
    } catch {
      toast.error(t("saveFailed"))
    }
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-6">
      <AvatarPicker
        currentUrl={profile?.photoUrl || user?.photoURL || ""}
        name={displayName}
        file={photo}
        onFileChange={setPhoto}
      />

      <FormItem label={t("name")} htmlFor="displayName" error={errors.displayName?.message}>
        <Input
          id="displayName"
          autoComplete="name"
          placeholder={t("namePlaceholder")}
          aria-invalid={!!errors.displayName}
          {...register("displayName")}
        />
      </FormItem>

      <div className="grid gap-6 sm:grid-cols-2">
        <FormItem label={t("dateOfBirth")} htmlFor="dateOfBirth" error={errors.dateOfBirth?.message}>
          <Input
            id="dateOfBirth"
            type="date"
            max={toDateInput(new Date())}
            aria-invalid={!!errors.dateOfBirth}
            {...register("dateOfBirth")}
          />
        </FormItem>
        <FormItem label={t("country")} htmlFor="country">
          <Controller
            control={control}
            name="country"
            render={({ field }) => (
              <CountryPicker id="country" value={field.value} onChange={field.onChange} />
            )}
          />
        </FormItem>
      </div>

      <Button type="submit" size="lg" className="w-full" disabled={isSubmitting}>
        {isSubmitting ? <Loader2 className="animate-spin" /> : null}
        {t("continue")}
        {!isSubmitting && <ArrowRight />}
      </Button>
    </form>
  )
}
