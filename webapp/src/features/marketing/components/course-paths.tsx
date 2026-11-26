import { ArrowRight, GraduationCap, Handshake, House, IceCreamCone, Star } from "lucide-react"
import { getTranslations } from "next-intl/server"
import Link from "next/link"
import { Reveal } from "@/components/motion/reveal"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { cn } from "@/lib/utils"
import { SectionLabel, SectionTitle } from "./section"

/**
 * The four offers on the landing page: the free class, Soft Serve Starter,
 * the in-person Gelato Masterclass and 1:1 Business Mentorship. These are
 * fixed marketing cards; the live course catalogue is on /explore.
 */
export async function CoursePaths() {
  const t = await getTranslations("landing.courses")

  const paths = [
    {
      icon: House,
      badges: [
        { text: t("freeBadge"), className: "bg-success-tint text-success" },
        { text: t("beginner"), className: "border border-border bg-cream text-muted-foreground" },
      ],
      title: t("homeTitle"),
      price: t("homePrice"),
      priceNote: t("homePriceNote"),
      body: t("homeBody"),
      points: t("homePoints").split("|"),
      cta: t("homeCta"),
      href: routes.explore,
      variant: "default" as const,
      featured: false,
    },
    {
      icon: IceCreamCone,
      badges: [{ text: t("popular"), className: "bg-gold-light text-maroon", star: true }],
      title: t("softTitle"),
      price: t("softPrice"),
      priceNote: t("softPriceNote"),
      body: t("softBody"),
      points: t("softPoints").split("|"),
      cta: t("softCta"),
      href: routes.explore,
      variant: "gold" as const,
      featured: true,
    },
    {
      icon: GraduationCap,
      badges: [
        { text: t("advanced"), className: "bg-maroon-tint text-primary" },
        { text: t("inPerson"), className: "border border-border bg-cream text-muted-foreground" },
      ],
      title: t("gelatoTitle"),
      price: t("gelatoPrice"),
      priceNote: t("gelatoPriceNote"),
      body: t("gelatoBody"),
      points: t("gelatoPoints").split("|"),
      cta: t("gelatoCta"),
      href: routes.contact,
      variant: "outline" as const,
      featured: false,
    },
    {
      icon: Handshake,
      badges: [
        { text: t("oneOnOne"), className: "border border-border bg-cream text-muted-foreground" },
      ],
      title: t("mentorTitle"),
      price: t("mentorPrice"),
      priceNote: t("mentorPriceNote"),
      body: t("mentorBody"),
      points: t("mentorPoints").split("|"),
      cta: t("mentorCta"),
      href: routes.consult,
      variant: "outline" as const,
      featured: false,
    },
  ]

  return (
    <section id="courses" className="bg-cream py-20 sm:py-28">
      <div className="container-page">
        <div className="mb-14 flex flex-wrap items-end justify-between gap-8">
          <Reveal>
            <SectionLabel tone="gold">{t("label")}</SectionLabel>
            <SectionTitle className="max-w-xl">{t("title")}</SectionTitle>
          </Reveal>
          <Reveal delay={0.15} className="max-w-sm">
            <p className="mb-4 text-[17px] leading-relaxed text-muted-foreground">{t("subtitle")}</p>
            <Link
              href={routes.explore}
              className="group inline-flex items-center gap-2 font-semibold text-primary"
            >
              {t("browseAll")}
              <ArrowRight className="size-4 transition-transform group-hover:translate-x-1" />
            </Link>
          </Reveal>
        </div>

        <div className="grid gap-6 md:grid-cols-2 xl:grid-cols-4">
          {paths.map((path, i) => (
            <Reveal key={path.title} delay={0.1 * i} className="h-full">
              <article
                className={cn(
                  "group relative flex h-full flex-col overflow-hidden rounded-3xl border bg-white transition-all duration-500 ease-(--ease-out-expo) hover:-translate-y-2 hover:shadow-lift",
                  path.featured
                    ? "border-gold/50 shadow-[0_16px_60px_rgb(224_158_0/0.15)]"
                    : "border-border hover:border-primary",
                )}
              >
                <div
                  className={cn(
                    "h-1.5 transition-colors duration-300",
                    path.featured ? "bg-gold" : "bg-border group-hover:bg-primary",
                  )}
                />
                <div className="flex flex-1 flex-col p-7 sm:p-8 xl:p-6">
                  <div className="mb-5 flex flex-wrap gap-2">
                    {path.badges.map((badge) => (
                      <span
                        key={badge.text}
                        className={cn(
                          "inline-flex items-center gap-1 rounded-full px-3 py-1 text-[11px] font-bold",
                          badge.className,
                        )}
                      >
                        {"star" in badge && <Star className="size-3 fill-current" />}
                        {badge.text}
                      </span>
                    ))}
                  </div>
                  <path.icon
                    className={cn(
                      "mb-4 size-10 transition-transform duration-500 group-hover:scale-110 group-hover:rotate-[-8deg]",
                      path.featured ? "text-gold" : "text-primary",
                    )}
                  />
                  <h3 className="mb-2 text-[22px] font-extrabold tracking-tight">{path.title}</h3>
                  <p className="mb-4 text-2xl font-extrabold text-primary">
                    {path.price}
                    <span className="block text-[13px] font-normal text-muted-foreground">{path.priceNote}</span>
                  </p>
                  <p className="mb-6 text-sm leading-relaxed text-muted-foreground">{path.body}</p>
                  <ul className="mb-8 space-y-2.5">
                    {path.points.map((point) => (
                      <li key={point} className="flex gap-2 text-[13px] leading-snug">
                        <span className={cn("font-extrabold", path.featured ? "text-gold" : "text-primary")}>
                          ✓
                        </span>
                        {point}
                      </li>
                    ))}
                  </ul>
                  <Button
                    variant={path.variant}
                    className="mt-auto w-full"
                    render={<Link href={path.href} />}
                  >
                    {path.cta} <ArrowRight />
                  </Button>
                </div>
              </article>
            </Reveal>
          ))}
        </div>
      </div>
    </section>
  )
}
