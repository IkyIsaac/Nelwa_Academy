"use client"

import { CalendarClock, Mail, MessageCircle, MessagesSquare } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion"
import { routes, site } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"

const QUESTIONS = [
  "what",
  "account",
  "pay",
  "access",
  "devices",
  "refund",
  "free",
  "offline",
  "instructor",
] as const

export function HelpView() {
  const t = useTranslations("help")
  const { status } = useAuth()

  const channels = [
    status === "signed-in"
      ? {
          href: routes.support,
          icon: MessagesSquare,
          title: t("channels.chat"),
          body: t("channels.chatBody"),
        }
      : {
          href: routes.contact,
          icon: MessagesSquare,
          title: t("channels.form"),
          body: t("channels.formBody"),
        },
    {
      href: site.whatsappUrl,
      icon: MessageCircle,
      title: "WhatsApp",
      body: site.whatsappNumber,
      external: true,
    },
    {
      href: `mailto:${site.email}`,
      icon: Mail,
      title: t("channels.email"),
      body: site.email,
      external: true,
    },
    {
      href: `${routes.consult}#book`,
      icon: CalendarClock,
      title: t("channels.consult"),
      body: t("channels.consultBody"),
    },
  ]

  return (
    <div className="grid items-start gap-10 lg:grid-cols-[1fr_340px]">
      <section>
        <h2 className="mb-4 font-sans text-xl font-bold">{t("faqTitle")}</h2>
        <Accordion className="rounded-3xl border border-border bg-white px-5">
          {QUESTIONS.map((q) => (
            <AccordionItem key={q} value={q}>
              <AccordionTrigger className="py-4 text-left text-base font-semibold">
                {t(`faq.${q}.q`)}
              </AccordionTrigger>
              <AccordionContent className="pb-4 leading-relaxed text-muted-foreground">
                {t(`faq.${q}.a`)}
              </AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
      </section>

      <aside className="space-y-3 lg:sticky lg:top-28">
        <h2 className="mb-1 font-sans text-xl font-bold">{t("stillNeedHelp")}</h2>
        {channels.map((c) => {
          const inner = (
            <>
              <span className="grid size-10 shrink-0 place-items-center rounded-xl bg-maroon-tint text-primary">
                <c.icon className="size-5" />
              </span>
              <span className="min-w-0">
                <span className="block font-semibold">{c.title}</span>
                <span className="block truncate text-sm text-muted-foreground">{c.body}</span>
              </span>
            </>
          )
          const cls =
            "flex items-center gap-3 rounded-2xl border border-border bg-white p-4 transition-all hover:border-primary/20 hover:shadow-soft"
          return c.external ? (
            <a key={c.title} href={c.href} target="_blank" rel="noopener noreferrer" className={cls}>
              {inner}
            </a>
          ) : (
            <Link key={c.title} href={c.href} className={cls}>
              {inner}
            </Link>
          )
        })}
      </aside>
    </div>
  )
}
