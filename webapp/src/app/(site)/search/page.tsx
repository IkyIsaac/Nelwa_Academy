import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { Suspense } from "react"
import { SearchView } from "@/features/catalog/components/discover-views"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("catalog.search")
  return { title: t("title") }
}

export default function SearchPage() {
  return (
    <Suspense>
      <SearchView />
    </Suspense>
  )
}
