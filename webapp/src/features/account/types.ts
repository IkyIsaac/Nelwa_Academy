import type { DocumentData } from "firebase/firestore"
import { bool, date, num, refId, str } from "@/lib/firebase/fields"

/** `users/{uid}/notification/{id}`, written by other learners and Cloud Functions. */
export type AppNotification = {
  id: string
  title: string
  description: string
  /** "subscribed" (new follower), "comment" (new review), or others. */
  type: string
  image: string
  courseTitle: string
  seen: boolean
  at: Date | null
}

export const toNotification = (id: string, d: DocumentData): AppNotification => ({
  id,
  title: str(d.title),
  description: str(d.description),
  type: str(d.type),
  image: str(d.image),
  courseTitle: str(d.course_title),
  seen: bool(d.seen),
  at: date(d.time_stamp),
})

/** `users/{uid}/purchase_history/{id}`: a receipt line written by the payment webhook. */
export type PurchaseRecord = {
  id: string
  courseId: string
  courseName: string
  amount: number
  currency: string
  status: string
  method: string
  at: Date | null
}

export const toPurchaseRecord = (id: string, d: DocumentData): PurchaseRecord => ({
  id,
  courseId: refId(d.courses_ref),
  courseName: str(d.courses_name),
  amount: num(d.amount),
  currency: str(d.currency) || "TZS",
  status: str(d.status),
  method: str(d.transaction_type) || str(d.payment_method),
  at: date(d.date),
})

/** `users/{uid}/user_reviews/{id}`: the learner's own copy of a review. */
export type MyReview = {
  id: string
  courseTitle: string
  courseImage: string
  instructor: string
  rating: number
  comment: string
  at: Date | null
}

export const toMyReview = (id: string, d: DocumentData): MyReview => ({
  id,
  courseTitle: str(d.course_title),
  courseImage: str(d.course_image),
  instructor: str(d.course_instructor),
  rating: num(d.rating),
  comment: str(d.comment),
  at: date(d.created_at),
})

/** `support/{id}/support_message/{id}`. `fromLearner` is false for academy replies. */
export type SupportMessage = {
  id: string
  text: string
  image: string
  fromLearner: boolean
  at: Date | null
}

export const toSupportMessage = (id: string, d: DocumentData): SupportMessage => ({
  id,
  text: str(d.message),
  image: str(d.image),
  fromLearner: d.user_message !== false,
  at: date(d.time_stamp),
})

/** Followed instructor, from their (instructor-readable) user profile. */
export type FollowedInstructor = { id: string; name: string; photoUrl: string; specialty: string }

/** Consultation departments exactly as the mobile app stores them. */
export const DEPARTMENTS = [
  { id: "academy", stored: "Nelway's Academy" },
  { id: "iceCream", stored: "Nelway's Ice cream" },
  { id: "gelato", stored: "Nelway's Gelato" },
  { id: "consulting", stored: "Nelway's Consultaion" },
] as const
export type DepartmentId = (typeof DEPARTMENTS)[number]["id"]
