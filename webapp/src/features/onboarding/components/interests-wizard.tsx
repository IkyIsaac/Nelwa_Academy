"use client"

import { ArrowLeft, ArrowRight, Check, Loader2, PartyPopper } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useTranslations } from "next-intl"
import { useRouter, useSearchParams } from "next/navigation"
import { useState } from "react"
import { toast } from "sonner"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { safeNext } from "@/features/auth/redirects"
import { cn } from "@/lib/utils"
import { saveLearningPreferences } from "../api"
import { experienceOptions, interestOptions, useForOptions } from "../options"

const EASE = [0.16, 1, 0.3, 1] as const
const STEPS = 3

/**
 * Step 2 of onboarding — the mobile app's three-question pager:
 * topics → experience level → what you'll use it for. Then "You're all set".
 */
export function InterestsWizard() {
  const t = useTranslations("onboarding.interests")
  const router = useRouter()
  const next = safeNext(useSearchParams().get("next"))
  const { user, profile } = useAuth()

  const [step, setStep] = useState(0)
  const [direction, setDirection] = useState(1)
  const [interests, setInterests] = useState<string[]>(profile?.interests ?? [])
  const [experience, setExperience] = useState(profile?.experience ?? "")
  const [useFor, setUseFor] = useState(profile?.useFor ?? "")
  const [saving, setSaving] = useState(false)
  const [finished, setFinished] = useState(false)

  const canContinue = [interests.length > 0, !!experience, !!useFor][step]

  const go = (to: number) => {
    setDirection(to > step ? 1 : -1)
    setStep(to)
  }

  const finish = async () => {
    if (!user) return
    setSaving(true)
    try {
      await saveLearningPreferences(user.uid, { interests, experience, useFor })
      setFinished(true)
    } catch {
      toast.error(t("saveFailed"))
    } finally {
      setSaving(false)
    }
  }

  const leave = () => router.replace(next ?? routes.home)

  if (finished) return <AllSet onStart={leave} />

  return (
    <div>
      {/* Progress */}
      <div className="mb-8 flex items-center gap-4">
        {step > 0 ? (
          <Button variant="ghost" size="icon-sm" onClick={() => go(step - 1)} aria-label={t("back")}>
            <ArrowLeft />
          </Button>
        ) : (
          <span className="size-8" />
        )}
        <div className="h-2 flex-1 overflow-hidden rounded-full bg-maroon-tint">
          <motion.div
            className="h-full rounded-full bg-primary"
            animate={{ width: `${((step + 1) / STEPS) * 100}%` }}
            transition={{ duration: 0.5, ease: EASE }}
          />
        </div>
        <button
          type="button"
          onClick={leave}
          className="cursor-pointer text-sm font-semibold text-muted-foreground hover:text-primary"
        >
          {t("skip")}
        </button>
      </div>

      <div className="relative min-h-[380px] overflow-hidden">
        <AnimatePresence mode="wait" custom={direction} initial={false}>
          <motion.div
            key={step}
            custom={direction}
            initial={{ opacity: 0, x: direction * 40 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: direction * -40 }}
            transition={{ duration: 0.35, ease: EASE }}
          >
            {step === 0 && (
              <Question title={t("topicsTitle")} subtitle={t("topicsSubtitle")}>
                <div className="grid gap-3 sm:grid-cols-3">
                  {interestOptions.map((option) => {
                    const selected = interests.includes(option.value)
                    return (
                      <button
                        key={option.value}
                        type="button"
                        aria-pressed={selected}
                        onClick={() =>
                          setInterests((list) =>
                            selected ? list.filter((v) => v !== option.value) : [...list, option.value],
                          )
                        }
                        className={cn(
                          "relative flex cursor-pointer flex-col items-center gap-3 rounded-2xl border-2 bg-white px-4 py-7 transition-all duration-300 hover:-translate-y-1",
                          selected
                            ? "border-primary bg-maroon-tint shadow-[0_12px_32px_rgb(93_8_11/0.14)]"
                            : "border-border hover:border-primary/30",
                        )}
                      >
                        <motion.span
                          className="text-5xl"
                          animate={selected ? { scale: [1, 1.2, 1], rotate: [0, -8, 0] } : {}}
                          transition={{ duration: 0.4 }}
                        >
                          {option.emoji}
                        </motion.span>
                        <span className="font-semibold">{t(`topics.${option.key}`)}</span>
                        <SelectedTick show={selected} className="absolute top-3 right-3" />
                      </button>
                    )
                  })}
                </div>
              </Question>
            )}

            {step === 1 && (
              <Question title={t("experienceTitle")} subtitle={t("helpsUs")}>
                <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
                  {experienceOptions.map((option) => (
                    <ChoicePill
                      key={option.value}
                      selected={experience === option.value}
                      onClick={() => setExperience(option.value)}
                    >
                      {t(`experience.${option.key}`)}
                    </ChoicePill>
                  ))}
                </div>
              </Question>
            )}

            {step === 2 && (
              <Question title={t("useForTitle")} subtitle={t("helpsUs")}>
                <div className="space-y-3">
                  {useForOptions.map((option) => (
                    <ChoicePill
                      key={option.value}
                      selected={useFor === option.value}
                      onClick={() => setUseFor(option.value)}
                      className="w-full justify-between px-5 text-left"
                    >
                      {t(`useFor.${option.key}`)}
                    </ChoicePill>
                  ))}
                </div>
              </Question>
            )}
          </motion.div>
        </AnimatePresence>
      </div>

      <Button
        size="lg"
        className="mt-6 w-full"
        disabled={!canContinue || saving}
        onClick={() => (step < STEPS - 1 ? go(step + 1) : finish())}
      >
        {saving && <Loader2 className="animate-spin" />}
        {step < STEPS - 1 ? t("continue") : t("finish")}
        {!saving && <ArrowRight />}
      </Button>
    </div>
  )
}

function Question({
  title,
  subtitle,
  children,
}: {
  title: string
  subtitle: string
  children: React.ReactNode
}) {
  return (
    <div>
      <h1 className="text-[1.75rem] leading-tight font-extrabold">{title}</h1>
      <p className="mt-2 mb-7 text-muted-foreground">{subtitle}</p>
      {children}
    </div>
  )
}

function ChoicePill({
  selected,
  className,
  children,
  ...props
}: React.ComponentProps<"button"> & { selected: boolean }) {
  return (
    <button
      type="button"
      aria-pressed={selected}
      className={cn(
        "flex min-h-13 cursor-pointer items-center justify-center gap-2 rounded-2xl border-2 bg-white px-4 py-3 text-[15px] font-medium transition-all duration-200",
        selected ? "border-primary bg-maroon-tint text-primary" : "border-border hover:border-primary/30",
        className,
      )}
      {...props}
    >
      {children}
      <SelectedTick show={selected} />
    </button>
  )
}

function SelectedTick({ show, className }: { show: boolean; className?: string }) {
  return (
    <AnimatePresence>
      {show && (
        <motion.span
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          exit={{ scale: 0 }}
          transition={{ type: "spring", stiffness: 500, damping: 25 }}
          className={cn(
            "grid size-5 shrink-0 place-items-center rounded-full bg-primary text-white",
            className,
          )}
        >
          <Check className="size-3" strokeWidth={3} />
        </motion.span>
      )}
    </AnimatePresence>
  )
}

/** Celebration screen after onboarding (mobile's "You're All Set!"). */
function AllSet({ onStart }: { onStart: () => void }) {
  const t = useTranslations("onboarding.done")
  const sparks = Array.from({ length: 12 })

  return (
    <div className="py-6 text-center">
      <div className="relative mx-auto mb-8 size-32">
        {sparks.map((_, i) => {
          const angle = (i / sparks.length) * Math.PI * 2
          return (
            <motion.span
              key={i}
              className={cn(
                "absolute top-1/2 left-1/2 size-2.5 rounded-full",
                i % 2 ? "bg-gold" : "bg-primary",
              )}
              initial={{ x: 0, y: 0, opacity: 1, scale: 0.5 }}
              animate={{ x: Math.cos(angle) * 90, y: Math.sin(angle) * 90, opacity: 0, scale: 1 }}
              transition={{ duration: 1, delay: 0.25, ease: "easeOut" }}
            />
          )
        })}
        <motion.div
          initial={{ scale: 0, rotate: -30 }}
          animate={{ scale: 1, rotate: 0 }}
          transition={{ type: "spring", stiffness: 260, damping: 16 }}
          className="grid size-32 place-items-center rounded-full bg-maroon text-cream shadow-lift"
        >
          <PartyPopper className="size-14" />
        </motion.div>
      </div>
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}>
        <h1 className="text-3xl font-extrabold">{t("title")}</h1>
        <p className="mx-auto mt-3 mb-8 max-w-sm text-muted-foreground">{t("body")}</p>
        <Button size="lg" className="w-full" onClick={onStart}>
          {t("start")} <ArrowRight />
        </Button>
      </motion.div>
    </div>
  )
}
