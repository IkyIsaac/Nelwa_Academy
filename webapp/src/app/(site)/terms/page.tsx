import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { PageHeader } from "@/components/layout/page-header"
import { LegalView } from "@/features/help/components/legal-view"
import { terms } from "@/features/help/legal"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("help")
  return { title: t("terms") }
}

export default async function Page() {
  const t = await getTranslations("help")
  return (
    <>
      <PageHeader title={t("terms")} />
      <div className="container-page max-w-3xl py-10">
        <LegalView doc={terms} />
      </div>
    </>
  )
}
