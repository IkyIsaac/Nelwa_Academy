import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { ConsultBooking } from "@/features/account/components/consult-booking"
import { ConsultCta } from "@/features/marketing/components/consult-cta"
import { ContactSection } from "@/features/marketing/components/contact-section"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("landing.consult")
  return { title: t("label"), description: t("subtitle") }
}

export default function ConsultPage() {
  return (
    <div className="pt-16">
      <ConsultCta />
      <section className="bg-cream py-16 sm:py-20">
        <div className="container-page max-w-2xl">
          <ConsultBooking />
        </div>
      </section>
      <ContactSection />
    </div>
  )
}
