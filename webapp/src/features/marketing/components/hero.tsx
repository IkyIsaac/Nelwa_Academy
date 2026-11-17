"use client"

import { ArrowRight, Award, GraduationCap } from "lucide-react"
import { motion, useScroll, useTransform } from "motion/react"
import { useTranslations } from "next-intl"
import Image from "next/image"
import Link from "next/link"
import { useRef } from "react"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"

const EASE = [0.16, 1, 0.3, 1] as const
const fadeUp = (delay: number) => ({
  initial: { opacity: 0, y: 30 },
  animate: { opacity: 1, y: 0 },
  transition: { duration: 0.8, ease: EASE, delay },
})

/** Maroon hero with the spinning ring photo and floating stat tags. */
export function Hero() {
  const t = useTranslations("landing.hero")
  const { status } = useAuth()
  const ref = useRef<HTMLElement>(null)

  // As the hero scrolls away, the photo drifts down and the text drifts up.
  const { scrollYProgress } = useScroll({ target: ref, offset: ["start start", "end start"] })
  const imageY = useTransform(scrollYProgress, [0, 1], [0, 120])
  const textY = useTransform(scrollYProgress, [0, 1], [0, -60])
  const fade = useTransform(scrollYProgress, [0, 0.8], [1, 0])

  return (
    <section ref={ref} id="home" className="relative flex min-h-dvh items-center overflow-hidden bg-maroon">
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_80%_60%_at_70%_50%,rgb(255_247_238/0.08),transparent_60%),radial-gradient(ellipse_60%_80%_at_20%_80%,rgb(122_14_18/0.8),transparent_60%)]" />
      <div className="grid-lines absolute inset-0" />
      <div className="absolute -top-24 -right-24 size-[600px] animate-blob rounded-full bg-cream opacity-15 blur-[80px]" />
      <div className="absolute -bottom-12 left-1/3 size-[400px] animate-blob rounded-full bg-maroon-light opacity-40 blur-[80px] [animation-direction:reverse]" />

      <div className="container-page relative grid items-center gap-16 pt-36 pb-24 lg:grid-cols-2 lg:gap-20 lg:pt-40 lg:pb-32">
        <motion.div style={{ y: textY, opacity: fade }} className="text-center lg:text-left">
          <motion.div
            {...fadeUp(0)}
            className="mb-7 inline-flex items-center gap-2 rounded-full border border-cream/30 bg-cream/15 px-4 py-2 text-xs font-semibold tracking-wider text-cream uppercase"
          >
            <span className="size-1.5 animate-pulse rounded-full bg-cream" />
            <Award className="size-3.5" />
            {t("badge")}
          </motion.div>

          <motion.h1
            {...fadeUp(0.1)}
            className="mb-6 text-[clamp(2.75rem,6vw,4.75rem)] leading-[1.05] font-black tracking-[-0.04em] text-white"
          >
            {t("titleStart")} <em className="text-cream not-italic">{t("titleEm")}</em> {t("titleEnd")}
          </motion.h1>

          <motion.p
            {...fadeUp(0.2)}
            className="mx-auto mb-11 max-w-[480px] text-lg leading-relaxed font-light text-white/75 lg:mx-0"
          >
            {t("subtitle")}
          </motion.p>

          <motion.div {...fadeUp(0.3)} className="flex flex-wrap justify-center gap-4 lg:justify-start">
            {status === "signed-in" ? (
              <Button size="lg" variant="cream" render={<Link href={routes.learn} />}>
                <GraduationCap /> {t("goToLearning")}
              </Button>
            ) : (
              <Button size="lg" variant="cream" render={<Link href={routes.signUp} />}>
                <GraduationCap /> {t("startFree")}
              </Button>
            )}
            <Button size="lg" variant="outline-light" render={<Link href="#courses" />}>
              {t("joinSoftServe")} <ArrowRight />
            </Button>
          </motion.div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: 30 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 1, ease: EASE, delay: 0.4 }}
          style={{ y: imageY }}
          className="relative hidden justify-center lg:flex"
        >
          <div className="relative grid size-[420px] place-items-center rounded-full border border-cream/20 bg-[radial-gradient(circle,rgb(255_247_238/0.12)_0%,rgb(93_8_11/0.3)_70%)]">
            <div className="absolute inset-5 animate-spin-slow rounded-full border border-dashed border-cream/15" />
            <div className="relative size-[300px] overflow-hidden rounded-full border-[3px] border-cream/30 shadow-[0_0_80px_rgb(255_247_238/0.15)]">
              <Image
                src="/brand/hero.jpg"
                alt={t("imageAlt")}
                fill
                priority
                sizes="300px"
                className="object-cover"
              />
            </div>
          </div>
          <FloatTag className="top-10 -right-2" value="1,200kg" label={t("monthlyProduction")} />
          <FloatTag
            className="bottom-14 -left-6 [animation-delay:2s]"
            value="10+"
            label={t("yearsExpertise")}
          />
        </motion.div>
      </div>
    </section>
  )
}

function FloatTag({ value, label, className }: { value: string; label: string; className?: string }) {
  return (
    <div
      className={`absolute animate-float rounded-2xl border border-cream/20 bg-white/10 px-5 py-3 text-[13px] font-semibold whitespace-nowrap text-white backdrop-blur-xl ${className}`}
    >
      <span className="block font-display text-lg font-extrabold text-cream">{value}</span>
      {label}
    </div>
  )
}
