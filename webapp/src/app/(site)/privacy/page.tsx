import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { PageHeader } from "@/components/layout/page-header"
import { LegalView } from "@/features/help/components/legal-view"
import { privacy } from "@/features/help/legal"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("help")
  return { title: t("privacy") }
}

export default async function Page() {
  const t = await getTranslations("help")
  return (
    <>
      <PageHeader title={t("privacy")} />
      <div className="container-page max-w-3xl py-10">
        <LegalView doc={privacy} />
      </div>
    </>
  )
}
