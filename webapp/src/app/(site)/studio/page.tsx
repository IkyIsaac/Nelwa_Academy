import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { StudioDashboard } from "@/features/studio/components/studio-dashboard"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("studio")
  return { title: t("tabs.dashboard") }
}

export default function Page() {
  return <StudioDashboard />
}
