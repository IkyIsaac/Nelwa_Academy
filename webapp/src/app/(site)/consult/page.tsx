import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { ConsultCta } from "@/features/marketing/components/consult-cta"
import { ContactSection } from "@/features/marketing/components/contact-section"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("landing.consult")
  return { title: t("label"), description: t("subtitle") }
}

// Interim page: the in-app consultation booking form arrives in Phase 5.
export default function ConsultPage() {
  return (
    <div className="pt-16">
      <ConsultCta />
      <ContactSection />
    </div>
  )
}
