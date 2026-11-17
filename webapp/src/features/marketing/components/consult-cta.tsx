import { Banknote, Clock, Laptop, MessageCircle } from "lucide-react"
import { getTranslations } from "next-intl/server"
import Link from "next/link"
import { Reveal } from "@/components/motion/reveal"
import { Button } from "@/components/ui/button"
import { routes, site } from "@/config/site"
import { SectionLabel, SectionTitle } from "./section"

/** Maroon call-to-action for Mercy's 1:1 consultation. */
export async function ConsultCta() {
  const t = await getTranslations("landing.consult")

  return (
    <section id="consult" className="relative overflow-hidden bg-maroon px-4 py-24 text-center sm:py-32">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_50%,rgb(255_247_238/0.08),transparent_50%),radial-gradient(circle_at_80%_50%,rgb(255_247_238/0.06),transparent_50%)]" />
      <Reveal className="relative mx-auto max-w-3xl">
        <SectionLabel tone="light">{t("label")}</SectionLabel>
        <SectionTitle light className="mx-auto max-w-2xl">
          {t("title")}
        </SectionTitle>
        <p className="mx-auto mt-5 mb-8 max-w-xl text-[17px] leading-relaxed text-white/70">
          {t("subtitle")}
        </p>

        <div className="mb-10 inline-flex flex-wrap items-center justify-center gap-x-4 gap-y-2 rounded-3xl border border-cream/25 bg-cream/15 px-6 py-3 text-sm font-semibold text-cream sm:rounded-full">
          <span className="inline-flex items-center gap-1.5">
            <Clock className="size-4" /> {t("duration")}
          </span>
          <span className="hidden opacity-50 sm:inline">·</span>
          <span className="inline-flex items-center gap-1.5">
            <Laptop className="size-4" /> {t("format")}
          </span>
          <span className="hidden opacity-50 sm:inline">·</span>
          <span className="inline-flex items-center gap-1.5">
            <Banknote className="size-4" /> {t("price")}
          </span>
        </div>

        <div className="flex flex-wrap justify-center gap-4">
          <Button size="lg" variant="cream" render={<Link href={routes.consult} />}>
            {t("book")}
          </Button>
          <Button
            size="lg"
            className="bg-[#25D366] text-white hover:bg-[#1fbd5a] hover:shadow-[0_12px_32px_rgb(37_211_102/0.3)]"
            render={<a href={site.whatsappUrl} target="_blank" rel="noreferrer" />}
          >
            <MessageCircle /> {t("whatsapp")}
          </Button>
        </div>

        <ul className="mt-12 flex flex-wrap justify-center gap-x-8 gap-y-3">
          {t("features")
            .split("|")
            .map((feature) => (
              <li key={feature} className="flex items-center gap-2 text-[13px] font-medium text-white/70">
                <span className="font-extrabold text-cream">✓</span>
                {feature}
              </li>
            ))}
        </ul>
      </Reveal>
    </section>
  )
}
