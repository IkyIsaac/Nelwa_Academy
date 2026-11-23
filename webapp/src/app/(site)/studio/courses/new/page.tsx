import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { NewCourse } from "@/features/studio/components/course-editor"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("studio")
  return { title: t("editor.newTitle") }
}

export default function Page() {
  return <NewCourse />
}
