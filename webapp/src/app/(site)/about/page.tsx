import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { ConsultCta } from "@/features/marketing/components/consult-cta"
import { Story } from "@/features/marketing/components/story"
import { Testimonials } from "@/features/marketing/components/testimonials"
import { Values } from "@/features/marketing/components/values"
import { WhatWeDo } from "@/features/marketing/components/what-we-do"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("landing.story")
  return { title: t("label"), description: t("p1") }
}

export default function AboutPage() {
  return (
    <div className="pt-16">
      <Story />
      <Values />
      <WhatWeDo />
      <Testimonials />
      <ConsultCta />
    </div>
  )
}
