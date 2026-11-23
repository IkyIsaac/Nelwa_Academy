import {
  addDoc,
  arrayUnion,
  collection,
  doc,
  getDocs,
  query,
  runTransaction,
  serverTimestamp,
  updateDoc,
  where,
} from "firebase/firestore"
import type { Course } from "@/features/catalog/types"
import { refList } from "@/lib/firebase/fields"
import { db } from "@/lib/firebase/client"
import { resizeImage } from "@/lib/image"
import { type Purchase, type RefundRequest, toPurchase, toRefundRequest } from "./types"

const userDoc = (uid: string) => doc(db, "users", uid)
const courseDoc = (courseId: string) => doc(db, "courses", courseId)

export async function fetchPurchases(uid: string): Promise<Purchase[]> {
  const snap = await getDocs(collection(db, "users", uid, "purchased_courses"))
  return snap.docs
    .map((d) => toPurchase(d.id, d.data()))
    .sort((a, b) => (b.purchasedAt?.getTime() ?? 0) - (a.purchasedAt?.getTime() ?? 0))
}

/**
 * Records that a lesson was opened, exactly like the mobile app: on the
 * purchase (`watched_lessons`) and in the user's `continue_watching` list,
 * which feeds "Continue watching" on Home in both apps.
 */
/**
 * Hide or restore a bought course in My courses. Learners can't delete a
 * purchase (security rules), so the course is archived instead and stays
 * owned on web and mobile.
 */
export async function setPurchaseArchived(uid: string, purchaseId: string, archived: boolean) {
  await updateDoc(doc(db, "users", uid, "purchased_courses", purchaseId), { archived })
}

export async function markLessonWatched(
  uid: string,
  courseId: string,
  lessonId: string,
  purchaseId?: string,
) {
  const lessonRef = doc(db, "courses", courseId, "lessons", lessonId)
  const course = courseDoc(courseId)

  const onPurchase = purchaseId
    ? updateDoc(doc(db, "users", uid, "purchased_courses", purchaseId), {
        watched_lessons: arrayUnion(lessonRef),
      })
    : Promise.resolve()

  // Read-modify-write so the course's entry is updated in place, instead of
  // the add-then-remove dance the struct array would otherwise need.
  const onProfile = runTransaction(db, async (tx) => {
    const snap = await tx.get(userDoc(uid))
    const list: { courses: unknown; completed_lessons: unknown }[] = Array.isArray(
      snap.get("continue_watching"),
    )
      ? [...snap.get("continue_watching")]
      : []
    const index = list.findIndex((e) => refList([e?.courses])[0]?.path === course.path)
    const done = index === -1 ? [] : refList(list[index].completed_lessons)
    if (done.some((r) => r.path === lessonRef.path)) return
    if (index !== -1) list.splice(index, 1)
    // Most recent last, as mobile's arrayUnion leaves it.
    list.push({ courses: course, completed_lessons: [...done, lessonRef] })
    tx.update(userDoc(uid), { continue_watching: list })
  })

  await Promise.all([onPurchase, onProfile])
}

export type ReviewInput = {
  uid: string
  userName: string
  userImage: string
  course: Course
  purchaseId: string
  rating: number
  comment: string
}

/**
 * Publishes a review the way mobile does: the public review, the learner's
 * own copy, the course's average and count, and "reviewed" on the purchase,
 * all in one transaction. The average is a true running mean.
 */
export async function submitReview(input: ReviewInput) {
  const { uid, course, rating, comment } = input
  await runTransaction(db, async (tx) => {
    const ref = courseDoc(course.id)
    const snap = await tx.get(ref)
    const count = Number(snap.get("reviews_count")) || 0
    const average = Number(snap.get("rating")) || 0
    const next = Math.min(5, Math.max(0, (average * count + rating) / (count + 1)))

    tx.set(doc(collection(ref, "courses_review")), {
      user_name: input.userName,
      user_image: input.userImage,
      rating,
      comment,
      created_at: serverTimestamp(),
    })
    tx.set(doc(collection(db, "users", uid, "user_reviews")), {
      comment,
      course_title: course.title,
      course_image: course.image,
      course_instructor: course.instructorName,
      rating,
      created_at: serverTimestamp(),
    })
    tx.update(ref, { rating: next, reviews_count: count + 1 })
    tx.update(doc(db, "users", uid, "purchased_courses", input.purchaseId), { reviwed: true })
  })

  // Tells the instructor; the review is already saved if this fails.
  if (course.instructorId) {
    await addDoc(collection(db, "users", course.instructorId, "notification"), {
      title: input.userName,
      description: comment,
      type: "comment",
      time_stamp: serverTimestamp(),
      seen: false,
      image: input.userImage,
      course_title: course.title,
    }).catch(() => {})
  }
}

export async function fetchRefundRequest(uid: string, courseId: string): Promise<RefundRequest | null> {
  const snap = await getDocs(
    query(
      collection(db, "requesta_refund"),
      where("user_ref", "==", userDoc(uid)),
      where("coureses_ref", "==", courseDoc(courseId)),
    ),
  )
  const requests = snap.docs.map((d) => toRefundRequest(d.id, d.data()))
  return requests.sort((a, b) => (b.createdAt?.getTime() ?? 0) - (a.createdAt?.getTime() ?? 0))[0] ?? null
}

export async function uploadRefundScreenshot(uid: string, file: File) {
  const blob = await resizeImage(file, 1600)
  const { uploadBlob } = await import("@/lib/firebase/storage")
  return uploadBlob(`users/${uid}/uploads/refund_${Date.now()}.jpg`, blob, "image/jpeg")
}

export type RefundInput = {
  uid: string
  course: Course
  reason: string
  comment: string
  screenshotUrl: string
}

/**
 * Saves a refund request for the admin to review. Unlike the old mobile
 * flow it moves no money: balances change only when the admin refunds.
 */
export async function requestRefund({ uid, course, reason, comment, screenshotUrl }: RefundInput) {
  await addDoc(collection(db, "requesta_refund"), {
    amount: course.price,
    coureses_ref: courseDoc(course.id),
    user_ref: userDoc(uid),
    reason,
    comment,
    screenshot_url: screenshotUrl,
    status: "pending",
    created_at: serverTimestamp(),
  })
}
