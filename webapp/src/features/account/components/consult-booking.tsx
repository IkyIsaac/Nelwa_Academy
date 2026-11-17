"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { CalendarCheck, Loader2 } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useTranslations } from "next-intl"
import { useEffect, useState } from "react"
import { Controller, useForm } from "react-hook-form"
import { toast } from "sonner"
import { z } from "zod"
import { Button } from "@/components/ui/button"
import { FormItem } from "@/components/ui/form-item"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"
import { bookConsultation } from "../api"
import { DEPARTMENTS, type DepartmentId } from "../types"

const toDateInput = (d: Date) => d.toISOString().slice(0, 10)
const tomorrow = () => {
  const d = new Date()
  d.setDate(d.getDate() + 1)
  return toDateInput(d)
}

const schema = (t: (key: string) => string) =>
  z.object({
    name: z.string().trim().min(2, t("errors.name")).max(100),
    phone: z
      .string()
      .trim()
      .regex(/^\+?[0-9 ()-]{7,20}$/, t("errors.phone")),
    email: z.string().trim().email(t("errors.email")).or(z.literal("")),
    department: z.enum(DEPARTMENTS.map((d) => d.id) as [DepartmentId, ...DepartmentId[]]),
    date: z.string().refine((v) => v >= tomorrow(), t("errors.date")),
    reason: z.string().trim().min(10, t("errors.reason")).max(2000),
  })
type Values = z.infer<ReturnType<typeof schema>>

/**
 * Consultation request, stored like the mobile booking form. Anyone can
 * book; signed-in learners get their details filled in. The academy is
 * emailed about every request and confirms the time with the learner.
 */
export function ConsultBooking() {
  const t = useTranslations("account.consult")
  const { user, profile } = useAuth()
  const [done, setDone] = useState(false)

  const {
    register,
    control,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting, isDirty },
  } = useForm<Values>({
    resolver: zodResolver(schema(t)),
    defaultValues: { name: "", phone: "", email: "", department: "consulting", date: "", reason: "" },
  })

  useEffect(() => {
    if (profile && !isDirty) {
      reset({
        name: profile.displayName,
        phone: profile.phoneNumber,
        email: profile.email || user?.email || "",
        department: "consulting",
        date: "",
        reason: "",
      })
    }
  }, [profile, user, isDirty, reset])

  const onSubmit = async (values: Values) => {
    try {
      await bookConsultation({
        uid: user?.uid ?? "",
        name: values.name,
        email: values.email,
        phone: values.phone,
        department: DEPARTMENTS.find((d) => d.id === values.department)!.stored,
        reason: values.reason,
        date: new Date(`${values.date}T09:00:00`),
      })
      setDone(true)
    } catch {
      toast.error(t("failed"))
    }
  }

  return (
    <div id="book" className="scroll-mt-28 rounded-3xl border border-border bg-white p-5 shadow-lift sm:p-8">
      <AnimatePresence mode="wait">
        {done ? (
          <motion.div
            key="done"
            initial={{ opacity: 0, scale: 0.96 }}
            animate={{ opacity: 1, scale: 1 }}
            className="py-10 text-center"
          >
            <motion.span
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: "spring", damping: 12 }}
              className="mx-auto mb-5 grid size-16 place-items-center rounded-full bg-success-tint text-success"
            >
              <CalendarCheck className="size-8" />
            </motion.span>
            <h3 className="font-sans text-2xl font-extrabold">{t("doneTitle")}</h3>
            <p className="mx-auto mt-2 max-w-sm text-sm text-muted-foreground">{t("doneBody")}</p>
            <Button variant="outline" className="mt-6" onClick={() => (setDone(false), reset())}>
              {t("another")}
            </Button>
          </motion.div>
        ) : (
          <motion.form
            key="form"
            exit={{ opacity: 0 }}
            onSubmit={handleSubmit(onSubmit)}
            noValidate
            className="space-y-5"
          >
            <div>
              <h2 className="font-sans text-2xl font-extrabold">{t("title")}</h2>
              <p className="mt-1 text-sm text-muted-foreground">{t("subtitle")}</p>
            </div>

            <FormItem label={t("name")} htmlFor="c-name" error={errors.name?.message}>
              <Input id="c-name" autoComplete="name" aria-invalid={!!errors.name} {...register("name")} />
            </FormItem>
            <div className="grid gap-5 sm:grid-cols-2">
              <FormItem label={t("phone")} htmlFor="c-phone" error={errors.phone?.message}>
                <Input
                  id="c-phone"
                  type="tel"
                  autoComplete="tel"
                  placeholder="+255 7XX XXX XXX"
                  aria-invalid={!!errors.phone}
                  {...register("phone")}
                />
              </FormItem>
              <FormItem label={t("email")} htmlFor="c-email" error={errors.email?.message}>
                <Input
                  id="c-email"
                  type="email"
                  autoComplete="email"
                  aria-invalid={!!errors.email}
                  {...register("email")}
                />
              </FormItem>
            </div>

            <FormItem label={t("department")}>
              <Controller
                control={control}
                name="department"
                render={({ field }) => (
                  <div role="radiogroup" aria-label={t("department")} className="grid gap-2 sm:grid-cols-2">
                    {DEPARTMENTS.map((d) => (
                      <button
                        key={d.id}
                        type="button"
                        role="radio"
                        aria-checked={field.value === d.id}
                        onClick={() => field.onChange(d.id)}
                        className={cn(
                          "rounded-2xl border-[1.5px] px-4 py-3 text-left text-sm font-semibold transition-all",
                          field.value === d.id
                            ? "border-primary bg-maroon-tint text-primary"
                            : "border-border hover:border-primary/40",
                        )}
                      >
                        {t(`departments.${d.id}`)}
                      </button>
                    ))}
                  </div>
                )}
              />
            </FormItem>

            <FormItem label={t("date")} htmlFor="c-date" hint={t("dateHint")} error={errors.date?.message}>
              <Input
                id="c-date"
                type="date"
                min={tomorrow()}
                aria-invalid={!!errors.date}
                {...register("date")}
              />
            </FormItem>

            <FormItem label={t("reason")} htmlFor="c-reason" error={errors.reason?.message}>
              <Textarea
                id="c-reason"
                rows={4}
                placeholder={t("reasonPlaceholder")}
                aria-invalid={!!errors.reason}
                {...register("reason")}
              />
            </FormItem>

            <Button type="submit" size="lg" className="w-full" disabled={isSubmitting}>
              {isSubmitting && <Loader2 className="animate-spin" />}
              {t("submit")}
            </Button>
            <p className="text-center text-xs text-muted-foreground">{t("note")}</p>
          </motion.form>
        )}
      </AnimatePresence>
    </div>
  )
}
