import type { Metadata } from "next"
import { notFound } from "next/navigation"
import { getTranslations } from "next-intl/server"
import { features } from "@/config/site"
import { RequireAuth } from "@/features/auth/components/guards"
import { RefundView } from "@/features/learning/components/refund-view"

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("learning")
  return { title: t("refund.title"), robots: { index: false } }
}

export default async function RefundPage({ params }: Props) {
  if (!features.refunds) notFound()
  const { id } = await params
  return (
    <RequireAuth>
      <RefundView courseId={id} />
    </RequireAuth>
  )
}
