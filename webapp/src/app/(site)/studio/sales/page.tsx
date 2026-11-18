import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { SalesView } from "@/features/studio/components/sales-view"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("studio")
  return { title: t("tabs.sales") }
}

export default function Page() {
  return <SalesView />
}
