import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { Suspense } from "react"
import { ExploreView } from "@/features/catalog/components/discover-views"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("catalog.explore")
  return { title: t("title"), description: t("subtitle") }
}

export default function ExplorePage() {
  return (
    <Suspense>
      <ExploreView />
    </Suspense>
  )
}
