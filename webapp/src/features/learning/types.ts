import type { DocumentData } from "firebase/firestore"
import { bool, date, num, refId, refList, str } from "@/lib/firebase/fields"

/**
 * `users/{uid}/purchased_courses/{id}`: one course the learner owns.
 * Created only by the payment webhook; the learner updates progress.
 */
export type Purchase = {
  id: string
  courseId: string
  purchasedAt: Date | null
  /** Set once the learner has reviewed the course (field is spelled `reviwed`). */
  reviewed: boolean
  watchedLessonIds: string[]
  /** Lesson count when bought; the course may have more now. */
  lessons: number
}

export function toPurchase(id: string, d: DocumentData): Purchase {
  return {
    id,
    courseId: refId(d.courses_ref),
    purchasedAt: date(d.purchase_date),
    reviewed: bool(d.reviwed),
    watchedLessonIds: refList(d.watched_lessons).map((r) => r.id),
    lessons: num(d.lessons),
  }
}

/** `requesta_refund/{id}` (collection and field names as the mobile app wrote them). */
export type RefundRequest = {
  id: string
  status: string
  reason: string
  createdAt: Date | null
}

export function toRefundRequest(id: string, d: DocumentData): RefundRequest {
  return { id, status: str(d.status) || "pending", reason: str(d.reason), createdAt: date(d.created_at) }
}

/** Same choices as the mobile refund screen; the English text is what gets stored. */
export const REFUND_REASONS = [
  { id: "mistake", stored: "I purchased this by mistake" },
  { id: "expectations", stored: "The content didn’t meet my expectations" },
  { id: "technical", stored: "Technical issues with the course" },
  { id: "cancel", stored: "I want to cancel the purchase" },
  { id: "other", stored: "Other" },
] as const

export type RefundReasonId = (typeof REFUND_REASONS)[number]["id"]
