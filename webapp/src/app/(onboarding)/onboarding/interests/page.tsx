import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { Suspense } from "react"
import { InterestsWizard } from "@/features/onboarding/components/interests-wizard"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("onboarding.interests")
  return { title: t("topicsTitle") }
}

export default function InterestsPage() {
  return (
    <Suspense>
      <InterestsWizard />
    </Suspense>
  )
}
