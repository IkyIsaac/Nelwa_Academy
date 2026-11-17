import { Globe, Mail, MessageCircle } from "lucide-react"
import { getTranslations } from "next-intl/server"
import Link from "next/link"
import { routes, site } from "@/config/site"
import { Logo } from "./logo"

/** Maroon footer from the landing template. */
export async function SiteFooter() {
  const t = await getTranslations("footer")
  const nav = await getTranslations("nav")

  const columns = [
    {
      title: t("learn"),
      links: [
        { href: routes.explore, label: t("allCourses") },
        { href: routes.consult, label: t("consultation") },
        { href: site.playStoreUrl, label: t("getTheApp") },
      ],
    },
    {
      title: t("company"),
      links: [
        { href: routes.about, label: t("ourValues") },
        { href: `${routes.landing}#testimonials`, label: t("studentStories") },
        { href: routes.contact, label: nav("contact") },
        { href: routes.help, label: t("helpCenter") },
      ],
    },
    {
      title: t("legal"),
      links: [
        { href: routes.privacy, label: t("privacyPolicy") },
        { href: routes.terms, label: t("terms") },
      ],
    },
  ]

  const socials = [
    { href: `mailto:${site.email}`, label: "Email", icon: Mail },
    { href: site.whatsappUrl, label: "WhatsApp", icon: MessageCircle },
    { href: site.gelatoUrl, label: "Nelwa's Gelato", icon: Globe },
  ]

  return (
    <footer className="bg-maroon pt-20 pb-28 text-white md:pb-10">
      <div className="container-page">
        <div className="grid gap-12 md:grid-cols-[2fr_1fr_1fr_1fr]">
          <div>
            <Logo light className="[&_img]:h-12" />
            <p className="mt-5 max-w-xs text-sm leading-relaxed text-white/80">{t("tagline")}</p>
            <div className="mt-6 flex gap-3">
              {socials.map(({ href, label, icon: Icon }) => (
                <a
                  key={label}
                  href={href}
                  target="_blank"
                  rel="noreferrer"
                  aria-label={label}
                  className="grid size-10 place-items-center rounded-xl border border-white/10 bg-white/8 text-white/70 transition hover:-translate-y-0.5 hover:border-cream hover:bg-cream hover:text-maroon"
                >
                  <Icon className="size-5" />
                </a>
              ))}
            </div>
          </div>

          {columns.map((column) => (
            <div key={column.title}>
              <h4 className="mb-5 font-sans text-xs font-bold tracking-widest text-cream uppercase">
                {column.title}
              </h4>
              <ul className="space-y-3">
                {column.links.map((link) => (
                  <li key={link.label}>
                    <Link
                      href={link.href}
                      className="text-sm text-white/80 transition-colors hover:text-white"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="mt-14 flex flex-col items-center justify-between gap-4 border-t border-white/10 pt-8 text-center text-[13px] text-white/70 sm:flex-row sm:text-left">
          <p>
            © {new Date().getFullYear()} {site.name}. {t("rights")}
          </p>
          <a href={site.gelatoUrl} target="_blank" rel="noreferrer" className="hover:text-cream">
            nelwasgelato.com
          </a>
        </div>
      </div>
    </footer>
  )
}
