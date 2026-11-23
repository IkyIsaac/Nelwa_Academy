import type { Metadata } from "next"
import { getLocale } from "next-intl/server"
import { CourseDetail } from "@/features/catalog/components/course-detail"
import { getCourseMeta } from "@/features/catalog/server"

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params
  const meta = await getCourseMeta(id, await getLocale())
  if (!meta?.title) return {}
  return {
    title: meta.title,
    description: meta.description,
    openGraph: { title: meta.title, description: meta.description, images: meta.image ? [meta.image] : [] },
  }
}

export default async function CoursePage({ params }: Props) {
  const { id } = await params
  return <CourseDetail id={id} />
}
