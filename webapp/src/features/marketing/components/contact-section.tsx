import { Globe, Mail, MessageCircle } from "lucide-react"
import { getTranslations } from "next-intl/server"
import { Reveal } from "@/components/motion/reveal"
import { site } from "@/config/site"
import { ContactForm } from "./contact-form"
import { SectionLabel, SectionTitle } from "./section"

export async function ContactSection() {
  const t = await getTranslations("landing.contact")
  const channels = [
    { icon: Mail, label: t("emailUs"), value: site.email, href: `mailto:${site.email}` },
    { icon: MessageCircle, label: t("whatsapp"), value: site.whatsappNumber, href: site.whatsappUrl },
    { icon: Globe, label: t("website"), value: "www.nelwasgelato.com", href: site.gelatoUrl },
  ]

  return (
    <section id="contact" className="bg-white py-20 sm:py-28">
      <div className="container-page grid items-start gap-14 lg:grid-cols-2 lg:gap-20">
        <Reveal className="min-w-0">
          <SectionLabel>{t("label")}</SectionLabel>
          <SectionTitle className="max-w-md">{t("title")}</SectionTitle>
          <p className="mt-4 mb-10 max-w-md text-[17px] leading-relaxed text-muted-foreground">
            {t("subtitle")}
          </p>
          <div className="space-y-4">
            {channels.map(({ icon: Icon, label, value, href }) => (
              <a
                key={label}
                href={href}
                target="_blank"
                rel="noreferrer"
                className="group flex items-center gap-4 rounded-2xl border border-border p-5 transition-all duration-300 hover:translate-x-1.5 hover:border-primary hover:bg-maroon-tint"
              >
                <span className="grid size-12 shrink-0 place-items-center rounded-xl bg-primary text-white">
                  <Icon className="size-5" />
                </span>
                <span className="min-w-0">
                  <span className="block text-[11px] font-bold tracking-widest text-muted-foreground uppercase">
                    {label}
                  </span>
                  <span className="block truncate text-[15px] font-semibold">{value}</span>
                </span>
              </a>
            ))}
          </div>
        </Reveal>

        <Reveal delay={0.15} className="min-w-0">
          <div className="rounded-[1.75rem] border border-border bg-cream p-6 sm:p-10">
            <h3 className="text-2xl font-extrabold tracking-tight">{t("formTitle")}</h3>
            <p className="mt-1.5 mb-7 text-sm text-muted-foreground">{t("formSubtitle")}</p>
            <ContactForm />
          </div>
        </Reveal>
      </div>
    </section>
  )
}
