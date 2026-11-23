import { Star } from "lucide-react"
import { getTranslations } from "next-intl/server"
import { Reveal, Stagger, StaggerItem } from "@/components/motion/reveal"
import { SectionLabel, SectionTitle } from "./section"

export async function Testimonials() {
  const t = await getTranslations("landing.testimonials")
  const people = [
    { initials: "AJ", name: "Amina J.", city: "Dar es Salaam, Tanzania", quote: t("amina") },
    { initials: "GM", name: "Grace M.", city: "Mwanza, Tanzania", quote: t("grace") },
    { initials: "FK", name: "Fatuma K.", city: "Arusha, Tanzania", quote: t("fatuma") },
  ]

  return (
    <section id="testimonials" className="bg-cream py-20 sm:py-28">
      <div className="container-page">
        <Reveal className="mx-auto mb-14 max-w-xl text-center">
          <SectionLabel tone="gold">{t("label")}</SectionLabel>
          <SectionTitle>{t("title")}</SectionTitle>
          <p className="mt-3 text-[17px] text-muted-foreground">{t("subtitle")}</p>
        </Reveal>
        <Stagger className="grid gap-6 md:grid-cols-3">
          {people.map((person) => (
            <StaggerItem key={person.name}>
              <figure className="relative h-full rounded-3xl border border-border bg-white p-8 transition-all duration-300 hover:-translate-y-1.5 hover:border-primary hover:shadow-lift">
                <span
                  aria-hidden
                  className="mb-4 block font-display text-7xl leading-[0.7] font-black text-primary/12"
                >
                  &ldquo;
                </span>
                <blockquote className="mb-7 text-[15px] leading-[1.75] italic">{person.quote}</blockquote>
                <div className="mb-4 flex gap-0.5 text-gold" aria-label="5 out of 5 stars">
                  {Array.from({ length: 5 }).map((_, i) => (
                    <Star key={i} className="size-4 fill-current" />
                  ))}
                </div>
                <figcaption className="flex items-center gap-3.5">
                  <span className="grid size-11 place-items-center rounded-full bg-maroon font-bold text-cream">
                    {person.initials}
                  </span>
                  <span>
                    <span className="block text-sm font-bold">{person.name}</span>
                    <span className="text-xs text-muted-foreground">{person.city}</span>
                  </span>
                </figcaption>
              </figure>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  )
}
