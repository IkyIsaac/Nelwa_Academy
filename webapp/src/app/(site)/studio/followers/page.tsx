import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { FollowersView } from "@/features/studio/components/followers-view"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("studio")
  return { title: t("tabs.followers") }
}

export default function Page() {
  return <FollowersView />
}
