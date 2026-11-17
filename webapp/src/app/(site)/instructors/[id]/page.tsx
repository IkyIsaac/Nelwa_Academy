import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { InstructorView } from "@/features/catalog/components/instructor-view"

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("catalog.instructor")
  return { title: t("eyebrow") }
}

export default async function InstructorPage({ params }: Props) {
  const { id } = await params
  return <InstructorView id={id} />
}
