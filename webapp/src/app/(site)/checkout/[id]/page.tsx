import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { RequireAuth } from "@/features/auth/components/guards"
import { CheckoutView } from "@/features/checkout/components/checkout-view"

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("checkout")
  return { title: t("title"), robots: { index: false } }
}

export default async function CheckoutPage({ params }: Props) {
  const { id } = await params
  return (
    <RequireAuth>
      <CheckoutView courseId={id} />
    </RequireAuth>
  )
}
