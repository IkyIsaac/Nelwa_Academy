import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { RequireAuth } from "@/features/auth/components/guards"
import { HomeView } from "@/features/catalog/components/home-view"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("nav")
  return { title: t("home") }
}

export default function HomePage() {
  return (
    <RequireAuth>
      <HomeView />
    </RequireAuth>
  )
}
