import { getTranslations } from "next-intl/server"
import Image from "next/image"
import { Reveal } from "@/components/motion/reveal"
import { SectionLabel, SectionTitle } from "./section"

export async function Story() {
  const t = await getTranslations("landing.story")

  return (
    <section id="about" className="bg-white py-20 sm:py-28">
      <div className="container-page grid items-center gap-14 lg:grid-cols-2 lg:gap-20">
        <Reveal className="relative mx-auto w-full max-w-md lg:max-w-none">
          <div className="group relative aspect-[4/5] overflow-hidden rounded-[2rem]">
            <Image
              src="/brand/founder.jpg"
              alt={t("founderAlt")}
              fill
              sizes="(min-width: 1024px) 560px, 90vw"
              className="object-cover transition-transform duration-1000 ease-(--ease-out-expo) group-hover:scale-105"
            />
          </div>
          <div className="absolute -top-5 -right-3 grid size-28 place-items-center rounded-3xl bg-maroon text-center text-white shadow-lift sm:-right-5 sm:size-[120px]">
            <div>
              <div className="font-display text-3xl leading-none font-black">10+</div>
              <div className="mt-1 px-2 text-[10px] font-bold tracking-wide uppercase">{t("years")}</div>
            </div>
          </div>
        </Reveal>

        <Reveal delay={0.15}>
          <SectionLabel>{t("label")}</SectionLabel>
          <SectionTitle>{t("title")}</SectionTitle>
          <div className="mt-6 mb-6 h-1 w-16 rounded-full bg-gradient-to-r from-gold to-maroon" />
          {(["p1", "p2", "p3"] as const).map((key) => (
            <p key={key} className="mb-5 text-base leading-[1.8] text-muted-foreground">
              {t(key)}
            </p>
          ))}
          <blockquote className="my-8 rounded-r-xl border-l-[3px] border-gold bg-maroon-tint px-6 py-4 font-display text-lg leading-snug text-primary italic">
            &ldquo;{t("quote")}&rdquo;
          </blockquote>
          <ul className="grid gap-3 sm:grid-cols-2">
            {t("milestones")
              .split("|")
              .map((milestone) => (
                <li key={milestone} className="flex items-center gap-2.5 text-[13px] font-medium">
                  <span className="size-2 shrink-0 rounded-full bg-gold" />
                  {milestone}
                </li>
              ))}
          </ul>
        </Reveal>
      </div>
    </section>
  )
}
