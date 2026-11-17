import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { RequireAuth } from "@/features/auth/components/guards"
import { MyCoursesView } from "@/features/learning/components/my-courses-view"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("learning")
  return { title: t("myCourses") }
}

export default function LearnPage() {
  return (
    <RequireAuth>
      <MyCoursesView />
    </RequireAuth>
  )
}
