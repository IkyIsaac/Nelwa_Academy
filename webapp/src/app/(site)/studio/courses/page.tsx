import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { StudioCourses } from "@/features/studio/components/studio-courses"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("studio")
  return { title: t("tabs.courses") }
}

export default function Page() {
  return <StudioCourses />
}
