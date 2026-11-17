"use client"

import { useLocale, useTranslations } from "next-intl"
import type { LegalDoc } from "../legal"

export function LegalView({ doc }: { doc: LegalDoc }) {
  const t = useTranslations("help")
  const locale = useLocale()
  return (
    <article className="rounded-3xl border border-border bg-white p-6 sm:p-10">
      {locale !== "en" && (
        <p className="mb-6 rounded-2xl bg-cream px-4 py-3 text-sm text-muted-foreground">
          {t("englishOnly")}
        </p>
      )}
      <p className="text-xs font-semibold text-muted-foreground">{t("updated", { date: doc.updated })}</p>
      <p className="mt-4 leading-relaxed">{doc.intro}</p>
      {doc.sections.map((s) => (
        <section key={s.heading} className="mt-8">
          <h2 className="font-sans text-lg font-bold">{s.heading}</h2>
          {s.paragraphs.map((p) => (
            <p key={p} className="mt-3 leading-relaxed text-muted-foreground">
              {p}
            </p>
          ))}
        </section>
      ))}
    </article>
  )
}
