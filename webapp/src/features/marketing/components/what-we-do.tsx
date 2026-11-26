import { House, ShoppingCart, Tag } from "lucide-react"
import { getTranslations } from "next-intl/server"
import { CountUp } from "@/components/motion/count-up"
import { Reveal } from "@/components/motion/reveal"
import { cn } from "@/lib/utils"
import { SectionLabel, SectionTitle } from "./section"

export async function WhatWeDo() {
  const t = await getTranslations("landing.what")

  const benefits = [
    { icon: House, title: t("homeTitle"), body: t("homeBody") },
    { icon: ShoppingCart, title: t("businessTitle"), body: t("businessBody") },
    { icon: Tag, title: t("brandTitle"), body: t("brandBody") },
  ]

  const stats = [
    {
      value: <CountUp to={2013} grouping={false} className="tabular-nums" />,
      label: t("founded"),
      gold: false,
    },
    {
      value: (
        <>
          <CountUp to={1200} className="tabular-nums" />
          <span className="text-xl">kg</span>
        </>
      ),
      label: t("production"),
      gold: true,
    },
    {
      value: (
        <>
          <CountUp to={3} />+
        </>
      ),
      label: t("countries"),
      gold: true,
    },
    { value: "∞", label: t("dreams"), gold: false },
  ]

  return (
    <section id="about-section" className="bg-white py-20 sm:py-28">
      <div className="container-page grid items-center gap-14 lg:grid-cols-2 lg:gap-20">
        <div>
          <Reveal>
            <SectionLabel>{t("label")}</SectionLabel>
            <SectionTitle>{t("title")}</SectionTitle>
          </Reveal>
          <div className="mt-10 space-y-4">
            {benefits.map(({ icon: Icon, title, body }, i) => (
              <Reveal key={title} delay={0.1 * (i + 1)}>
                <div className="group flex gap-4 rounded-2xl border border-border p-5 transition-all duration-300 hover:translate-x-2 hover:border-primary hover:bg-maroon-tint hover:shadow-soft">
                  <span className="grid size-11 shrink-0 place-items-center rounded-xl bg-primary text-white transition-transform duration-300 group-hover:rotate-[-6deg]">
                    <Icon className="size-5" />
                  </span>
                  <div>
                    <h3 className="mb-1 font-sans text-[15px] font-bold">{title}</h3>
                    <p className="text-sm leading-relaxed text-muted-foreground">{body}</p>
                  </div>
                </div>
              </Reveal>
            ))}
          </div>
        </div>

        <Reveal delay={0.2}>
          <p className="mb-8 text-base leading-[1.8] text-muted-foreground">{t("intro")}</p>
          <div className="grid grid-cols-2 gap-4">
            {stats.map((stat) => (
              <div
                key={stat.label}
                className={cn(
                  "rounded-[1.25rem] px-6 py-7 transition-transform duration-300 hover:-translate-y-1",
                  stat.gold ? "border border-gold/20 bg-gold-light" : "bg-maroon",
                )}
              >
                <div
                  className={cn(
                    "mb-1.5 font-display text-4xl leading-none font-extrabold",
                    stat.gold ? "text-maroon" : "text-cream",
                  )}
                >
                  {stat.value}
                </div>
                <div
                  className={cn(
                    "text-xs font-semibold tracking-wide",
                    stat.gold ? "text-muted-foreground" : "text-white/70",
                  )}
                >
                  {stat.label}
                </div>
              </div>
            ))}
          </div>
        </Reveal>
      </div>
    </section>
  )
}
