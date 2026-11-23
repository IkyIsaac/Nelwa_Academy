"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { Loader2 } from "lucide-react"
import { useTranslations } from "next-intl"
import { useEffect, useState } from "react"
import { Controller, useForm, useWatch } from "react-hook-form"
import { toast } from "sonner"
import { z } from "zod"
import { CountryPicker } from "@/components/country-picker"
import { Button } from "@/components/ui/button"
import { FormItem } from "@/components/ui/form-item"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { useAuth } from "@/features/auth/components/auth-provider"
import { uploadAvatar } from "@/features/onboarding/api"
import { AvatarPicker } from "@/features/onboarding/components/avatar-picker"
import { savePersonalInfo } from "../api"

const schema = (t: (key: string) => string) =>
  z.object({
    displayName: z.string().trim().min(2, t("errors.nameRequired")).max(60),
    aboutUser: z.string().trim().max(500, t("errors.tooLong")),
    specialty: z.string().trim().max(80, t("errors.tooLong")),
    phoneNumber: z
      .string()
      .trim()
      .refine((v) => !v || /^\+?[0-9 ()-]{7,20}$/.test(v), t("errors.phone")),
    dateOfBirth: z.string().refine((v) => !v || new Date(v) < new Date(), t("errors.dobInFuture")),
    country: z.string(),
    education: z.string().trim().max(120, t("errors.tooLong")),
  })
type Values = z.infer<ReturnType<typeof schema>>

const toDateInput = (d: Date | null) => (d ? d.toISOString().slice(0, 10) : "")

export function PersonalInfoForm() {
  const t = useTranslations("account.personal")
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
    defaultValues: {
      displayName: "",
      aboutUser: "",
      specialty: "",
      phoneNumber: "",
      dateOfBirth: "",
      country: "",
      education: "",
    },
  })
  const displayName = useWatch({ control, name: "displayName" })

  useEffect(() => {
    if (profile && !isDirty) {
      reset({
        displayName: profile.displayName,
        aboutUser: profile.aboutUser,
        specialty: profile.specialty,
        phoneNumber: profile.phoneNumber,
        dateOfBirth: toDateInput(profile.dateOfBirth),
        country: profile.country,
        education: profile.education,
      })
    }
  }, [profile, isDirty, reset])

  const onSubmit = async (values: Values) => {
    if (!user) return
    try {
      const photoUrl = photo ? await uploadAvatar(user.uid, photo) : profile?.photoUrl || user.photoURL || ""
      await savePersonalInfo(user, {
        ...values,
        photoUrl,
        dateOfBirth: values.dateOfBirth ? new Date(values.dateOfBirth) : null,
      })
      setPhoto(null)
      reset(values)
      toast.success(t("saved"))
    } catch {
      toast.error(t("saveFailed"))
    }
  }

  return (
    <form
      onSubmit={handleSubmit(onSubmit)}
      noValidate
      className="space-y-6 rounded-3xl border border-border bg-white p-5 sm:p-8"
    >
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
          aria-invalid={!!errors.displayName}
          {...register("displayName")}
        />
      </FormItem>

      <FormItem label={t("email")} htmlFor="email" hint={t("emailHint")}>
        <Input id="email" value={user?.email ?? ""} readOnly disabled />
      </FormItem>

      <FormItem label={t("about")} htmlFor="aboutUser" error={errors.aboutUser?.message}>
        <Textarea id="aboutUser" rows={3} placeholder={t("aboutPlaceholder")} {...register("aboutUser")} />
      </FormItem>

      <div className="grid gap-6 sm:grid-cols-2">
        <FormItem label={t("specialty")} htmlFor="specialty" error={errors.specialty?.message}>
          <Input id="specialty" placeholder={t("specialtyPlaceholder")} {...register("specialty")} />
        </FormItem>
        <FormItem label={t("phone")} htmlFor="phoneNumber" error={errors.phoneNumber?.message}>
          <Input
            id="phoneNumber"
            type="tel"
            autoComplete="tel"
            placeholder="+255 7XX XXX XXX"
            aria-invalid={!!errors.phoneNumber}
            {...register("phoneNumber")}
          />
        </FormItem>
        <FormItem label={t("dateOfBirth")} htmlFor="dateOfBirth" error={errors.dateOfBirth?.message}>
          <Input id="dateOfBirth" type="date" max={toDateInput(new Date())} {...register("dateOfBirth")} />
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

      <FormItem label={t("education")} htmlFor="education" error={errors.education?.message}>
        <Input id="education" placeholder={t("educationPlaceholder")} {...register("education")} />
      </FormItem>

      <Button
        type="submit"
        size="lg"
        className="w-full sm:w-auto"
        disabled={isSubmitting || (!isDirty && !photo)}
      >
        {isSubmitting && <Loader2 className="animate-spin" />}
        {t("save")}
      </Button>
    </form>
  )
}
