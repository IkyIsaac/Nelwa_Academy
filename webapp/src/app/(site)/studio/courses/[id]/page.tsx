import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { CourseEditor } from "@/features/studio/components/course-editor"

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("studio")
  return { title: t("editor.editTitle") }
}

export default async function Page({ params }: Props) {
  const { id } = await params
  return <CourseEditor courseId={id} />
}
