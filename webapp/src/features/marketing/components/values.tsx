import { Briefcase, Globe, Handshake, Target } from "lucide-react"
import { getTranslations } from "next-intl/server"
import { Reveal, Stagger, StaggerItem } from "@/components/motion/reveal"
import { SectionLabel, SectionTitle } from "./section"

export async function Values() {
  const t = await getTranslations("landing.values")
  const values = [
    { icon: Target, title: t("practicalTitle"), body: t("practicalBody") },
    { icon: Globe, title: t("africanTitle"), body: t("africanBody") },
    { icon: Briefcase, title: t("businessTitle"), body: t("businessBody") },
    { icon: Handshake, title: t("communityTitle"), body: t("communityBody") },
  ]

  return (
    <section id="values" className="relative overflow-hidden bg-maroon py-20 sm:py-28">
      <div className="grid-lines absolute inset-0 opacity-60" />
      <div className="container-page relative">
        <Reveal className="mx-auto max-w-xl text-center">
          <SectionLabel tone="light">{t("label")}</SectionLabel>
          <SectionTitle light>{t("title")}</SectionTitle>
          <p className="mt-3 text-[17px] leading-relaxed text-white/70">{t("subtitle")}</p>
        </Reveal>
        <Stagger className="mt-14 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {values.map(({ icon: Icon, title, body }) => (
            <StaggerItem key={title}>
              <div className="group h-full rounded-3xl border border-white/10 bg-white/6 p-8 transition-all duration-300 hover:-translate-y-1.5 hover:border-cream/30 hover:bg-cream/10">
                <Icon className="mb-5 size-10 text-cream transition-transform duration-500 group-hover:scale-110" />
                <h3 className="mb-2.5 font-sans text-base font-bold text-white">{title}</h3>
                <p className="text-sm leading-relaxed text-white/60">{body}</p>
              </div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  )
}
