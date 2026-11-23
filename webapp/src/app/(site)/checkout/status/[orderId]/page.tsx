import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { RequireAuth } from "@/features/auth/components/guards"
import { OrderStatusView } from "@/features/checkout/components/order-status-view"

type Props = { params: Promise<{ orderId: string }> }

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("checkout")
  return { title: t("orderTitle"), robots: { index: false } }
}

export default async function OrderStatusPage({ params }: Props) {
  const { orderId } = await params
  return (
    <RequireAuth>
      <OrderStatusView orderId={orderId} />
    </RequireAuth>
  )
}
