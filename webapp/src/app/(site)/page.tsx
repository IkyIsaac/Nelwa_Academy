import { ConsultCta } from "@/features/marketing/components/consult-cta"
import { ContactSection } from "@/features/marketing/components/contact-section"
import { CoursePaths } from "@/features/marketing/components/course-paths"
import { Hero } from "@/features/marketing/components/hero"
import { Wave } from "@/features/marketing/components/section"
import { Story } from "@/features/marketing/components/story"
import { TrustBar } from "@/features/marketing/components/trust-bar"
import { Values } from "@/features/marketing/components/values"
import { WhatWeDo } from "@/features/marketing/components/what-we-do"

/** nelwasacademy.com — the landing page from the original template. */
export default function LandingPage() {
  return (
    <>
      <Hero />
      <TrustBar />
      <WhatWeDo />
      <Wave from="#ffffff" to="#fff8f0" />
      <CoursePaths />
      <Wave from="#fff8f0" to="#ffffff" />
      <Story />
      <Values />
      <ConsultCta />
      <ContactSection />
    </>
  )
}
