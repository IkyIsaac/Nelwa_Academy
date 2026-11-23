import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { PageHeader } from "@/components/layout/page-header"
import { HelpView } from "@/features/help/components/help-view"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("help")
  return { title: t("title"), description: t("description") }
}

export default async function HelpPage() {
  const t = await getTranslations("help")
  return (
    <>
      <PageHeader eyebrow={t("eyebrow")} title={t("title")} description={t("description")} />
      <div className="container-page py-10">
        <HelpView />
      </div>
    </>
  )
}
