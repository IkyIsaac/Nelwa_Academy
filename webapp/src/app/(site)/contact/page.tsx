import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { ContactSection } from "@/features/marketing/components/contact-section"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("landing.contact")
  return { title: t("label"), description: t("subtitle") }
}

export default function ContactPage() {
  return (
    <div className="pt-16">
      <ContactSection />
    </div>
  )
}
