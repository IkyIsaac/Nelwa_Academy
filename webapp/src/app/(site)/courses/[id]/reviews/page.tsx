import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { ReviewsView } from "@/features/catalog/components/reviews-view"

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("catalog.reviews")
  return { title: t("title") }
}

export default async function CourseReviewsPage({ params }: Props) {
  const { id } = await params
  return <ReviewsView courseId={id} />
}
