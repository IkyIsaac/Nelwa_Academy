import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { ConsultationsView } from "@/features/studio/components/consultations-view"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("studio")
  return { title: t("tabs.consultations") }
}

export default function Page() {
  return <ConsultationsView />
}
