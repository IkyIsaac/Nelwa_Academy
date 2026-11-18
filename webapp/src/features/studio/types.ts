import type { DocumentData } from "firebase/firestore"
import { date, num, refId, str } from "@/lib/firebase/fields"

/**
 * Course languages offered by the mobile app's course form (FFAppState
 * langList). Stored on the course as `language: {language, lang_code, flag}`,
 * so the same values are used here.
 */
export const COURSE_LANGUAGES = [
  {
    name: "English",
    code: "en",
    flag: "https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fgreat_britain.png?alt=media&token=4065decd-2928-4f87-ba81-6dabdd17dde1",
  },
  {
    name: "Swahili",
    code: "sw",
    flag: "https://seekflag.com/wp-content/uploads/2021/12/Tanzania-01-1.svg",
  },
  {
    name: "Français",
    code: "fr",
    flag: "https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Ffrance.png?alt=media&token=bd059836-7859-43a7-9600-0a0b7855ae80",
  },
  {
    name: "Italiano",
    code: "it",
    flag: "https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fitaly.png?alt=media&token=684ff3e6-b796-40ba-9e42-0fd5f9cc35b6",
  },
] as const

/** Home-screen shelves an instructor can place a course on (mobile dropdown values). */
export const COURSE_GROUPS = ["New Courses", "We Recommend"] as const

export type CourseInput = {
  title: string
  titleSw: string
  description: string
  descriptionSw: string
  category: string
  group: string
  languageCode: string
  tags: string[]
  audience: string[]
  price: number
  yearPrice: number
  image: string
  previewVideo: string
}

export type LessonInput = {
  title: string
  titleSw: string
  description: string
  descriptionSw: string
  videoUrl: string
  image: string
  /** Seconds, like every duration in the app. */
  seconds: number
  isFree: boolean
}

/** One entry of `payment_account.sales_reports`, written by the payment webhook. */
export type Sale = {
  amount: number
  currency: string
  status: string
  date: Date | null
  courseId: string
  courseName: string
  buyerId: string
}

export type PaymentAccount = { id: string; balance: number; currency: string; sales: Sale[] }

export function toPaymentAccount(id: string, d: DocumentData): PaymentAccount {
  const sales: Sale[] = Array.isArray(d.sales_reports)
    ? d.sales_reports.map((s: DocumentData) => ({
        amount: num(s?.amount),
        currency: str(s?.currency) || "TZS",
        status: str(s?.status),
        date: date(s?.date),
        courseId: refId(s?.courseRef),
        courseName: str(s?.course_name),
        buyerId: refId(s?.user_ref),
      }))
    : []
  sales.sort((a, b) => (b.date?.getTime() ?? 0) - (a.date?.getTime() ?? 0))
  return { id, balance: num(d.balance), currency: str(d.currency), sales }
}

/** `payouts/{id}`: created by the admin's createPayout function. */
export type Payout = { id: string; amount: number; currency: string; status: string; createdAt: Date | null }

export function toPayout(id: string, d: DocumentData): Payout {
  return {
    id,
    amount: num(d.amount),
    currency: str(d.currency) || "TZS",
    status: str(d.status),
    createdAt: date(d.createdAt),
  }
}

export type Follower = { id: string; name: string; photoUrl: string; specialty: string }

export type ConsultationRequest = {
  id: string
  name: string
  email: string
  phone: string
  department: string
  reason: string
  preferredDay: Date | null
  createdAt: Date | null
}

export function toConsultation(id: string, d: DocumentData): ConsultationRequest {
  return {
    id,
    name: str(d.display_name) || str(d.user_name),
    email: str(d.email),
    phone: str(d.phone_number),
    department: str(d.selected_department),
    reason: str(d.reason_for_visit),
    preferredDay: date(d.appointment_time),
    createdAt: date(d.created_time),
  }
}
