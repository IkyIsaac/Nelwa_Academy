import type { DocumentData } from "firebase/firestore"
import { date, num, str } from "@/lib/firebase/fields"

/**
 * An order created by the `createOrder` Cloud Function. Only the server
 * writes orders: Snippe's signed webhook moves `status` from "pending" to
 * "completed" (course granted) or one of the failure states.
 */
export type OrderStatus = "pending" | "completed" | "failed" | "expired" | "voided"

export type OrderItem = { courseId: string; title: string; price: number }

export type Order = {
  id: string
  status: OrderStatus
  amount: number
  currency: string
  checkoutUrl: string
  items: OrderItem[]
  createdAt: Date | null
}

const STATUSES: OrderStatus[] = ["pending", "completed", "failed", "expired", "voided"]

export function toOrder(id: string, d: DocumentData): Order {
  const status = STATUSES.includes(d.status) ? (d.status as OrderStatus) : "pending"
  const items = Array.isArray(d.lineItems)
    ? d.lineItems.map((i: DocumentData) => ({
        courseId: str(i?.courseId),
        title: str(i?.title),
        price: num(i?.price),
      }))
    : []
  return {
    id,
    status,
    amount: num(d.amount),
    currency: str(d.currency) || "TZS",
    checkoutUrl: str(d.checkoutUrl),
    items,
    createdAt: date(d.createdAt),
  }
}

/** Why starting a checkout failed, from the Cloud Function's error code. */
export type CheckoutError = "owned" | "notForSale" | "signedOut" | "unavailable"
