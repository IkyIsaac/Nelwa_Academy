import type { Metadata } from "next"
import { getLocale } from "next-intl/server"
import { Suspense } from "react"
import { RequireAuth } from "@/features/auth/components/guards"
import { getCourseMeta } from "@/features/catalog/server"
import { CoursePlayer } from "@/features/learning/components/course-player"

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params
  const meta = await getCourseMeta(id, await getLocale())
  return { title: meta?.title, robots: { index: false } }
}

export default async function LearnCoursePage({ params }: Props) {
  const { id } = await params
  return (
    <RequireAuth>
      <Suspense>
        <CoursePlayer courseId={id} />
      </Suspense>
    </RequireAuth>
  )
}
