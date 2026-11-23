import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { CategoriesView } from "@/features/catalog/components/discover-views"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("catalog")
  return { title: t("categories"), description: t("categoriesSubtitle") }
}

export default function CategoriesPage() {
  return <CategoriesView />
}
