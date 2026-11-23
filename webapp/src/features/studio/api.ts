import {
  addDoc,
  arrayRemove,
  arrayUnion,
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  increment,
  limit,
  orderBy,
  query,
  serverTimestamp,
  updateDoc,
  where,
  writeBatch,
} from "firebase/firestore"
import { getDownloadURL, ref, uploadBytes, uploadBytesResumable } from "firebase/storage"
import { fetchLessons } from "@/features/catalog/api"
import { type Course, toCourse } from "@/features/catalog/types"
import { db } from "@/lib/firebase/client"
import { storage } from "@/lib/firebase/storage"
import { str } from "@/lib/firebase/fields"
import { resizeImage } from "@/lib/image"
import {
  COURSE_LANGUAGES,
  type ConsultationRequest,
  type CourseInput,
  type Follower,
  type LessonInput,
  type PaymentAccount,
  type Payout,
  toConsultation,
  toPaymentAccount,
  toPayout,
} from "./types"

/*
 * Everything the instructor studio reads and writes. Field names and shapes
 * match the mobile app's create-course / add-lesson screens, so courses made
 * on the web look the same on the phone. The security rules let an approved
 * instructor create courses with `instructor_ref` = themselves and edit or
 * delete only their own courses and lessons.
 */

const userDoc = (uid: string) => doc(db, "users", uid)
const courseDoc = (id: string) => doc(db, "courses", id)
const lessonsCol = (courseId: string) => collection(db, "courses", courseId, "lessons")

// ------------------------------------------------------------------ courses

export async function fetchMyCourses(uid: string): Promise<Course[]> {
  const snap = await getDocs(query(collection(db, "courses"), where("instructor_ref", "==", userDoc(uid))))
  return snap.docs
    .map((d) => toCourse(d.id, d.data()))
    .sort((a, b) => (b.publishedAt?.getTime() ?? 0) - (a.publishedAt?.getTime() ?? 0))
}

function courseFields(input: CourseInput) {
  const language = COURSE_LANGUAGES.find((l) => l.code === input.languageCode) ?? COURSE_LANGUAGES[0]
  return {
    title: input.title,
    title_sw: input.titleSw,
    description: input.description,
    description_sw: input.descriptionSw,
    category: input.category,
    group: input.group,
    language: { language: language.name, lang_code: language.code, flag: language.flag },
    tags: input.tags,
    audience: input.audience,
    price: input.price,
    year_price: input.yearPrice,
    image: input.image,
    video_preview: input.previewVideo,
  }
}

/** The instructor's own instructor_details doc (stats shown on their public page). */
async function instructorDetailsRef(uid: string) {
  const snap = await getDocs(query(collection(db, "users", uid, "instructor_details"), limit(1)))
  return snap.docs[0]?.ref ?? null
}

/**
 * New course, as the mobile form creates it. It starts unpublished on the
 * web so lessons can be added first (mobile publishes straight away).
 */
export async function createCourse(uid: string, name: string, input: CourseInput, publish: boolean) {
  const created = await addDoc(collection(db, "courses"), {
    ...courseFields(input),
    instructor_ref: userDoc(uid),
    instructor_name: name,
    is_published: publish,
    published_date: serverTimestamp(),
    level: "",
    discount: 0,
    total_lessons: 0,
    total_duration: 0,
    rating: 0,
    reviews_count: 0,
  })
  await updateDoc(created, { courses_id: created })
  const details = await instructorDetailsRef(uid)
  if (details) {
    await updateDoc(details, {
      courses: arrayUnion(created),
      categories: arrayUnion({ category: input.category }),
    }).catch(() => {})
  }
  return created.id
}

export async function updateCourse(courseId: string, input: CourseInput) {
  await updateDoc(courseDoc(courseId), courseFields(input))
}

export async function setCoursePublished(courseId: string, publish: boolean) {
  await updateDoc(courseDoc(courseId), {
    is_published: publish,
    ...(publish ? { published_date: serverTimestamp() } : {}),
  })
}

/**
 * Deletes a course and its lessons. Only allowed while nobody has bought it:
 * learners' purchases point at the course, so a sold course is unpublished
 * instead (the UI enforces this; buyers keep access to unpublished courses).
 */
export async function deleteCourse(uid: string, course: Course) {
  if (course.studentIds.length > 0) throw new Error("course-has-students")
  const lessons = await getDocs(lessonsCol(course.id))
  const batch = writeBatch(db)
  lessons.docs.forEach((d) => batch.delete(d.ref))
  batch.delete(courseDoc(course.id))
  await batch.commit()
  const details = await instructorDetailsRef(uid)
  if (details) {
    await updateDoc(details, {
      courses: arrayRemove(courseDoc(course.id)),
      lessons: increment(-lessons.size),
    }).catch(() => {})
  }
}

// ------------------------------------------------------------------ lessons

/** Keep the course's lesson count and total length (seconds) exact. */
async function recount(courseId: string) {
  const lessons = await fetchLessons(courseId)
  await updateDoc(courseDoc(courseId), {
    total_lessons: lessons.length,
    total_duration: lessons.reduce((sum, l) => sum + l.seconds, 0),
  })
}

function lessonFields(input: LessonInput) {
  return {
    title: input.title,
    title_sw: input.titleSw,
    description: input.description,
    description_sw: input.descriptionSw,
    video_url: input.videoUrl,
    image: input.image,
    duration: Math.round(input.seconds),
    is_free: input.isFree,
  }
}

export async function addLesson(uid: string, courseId: string, input: LessonInput, order: number) {
  await addDoc(lessonsCol(courseId), { ...lessonFields(input), order })
  await recount(courseId)
  const details = await instructorDetailsRef(uid)
  if (details) await updateDoc(details, { lessons: increment(1) }).catch(() => {})
}

export async function updateLesson(courseId: string, lessonId: string, input: LessonInput) {
  await updateDoc(doc(lessonsCol(courseId), lessonId), lessonFields(input))
  await recount(courseId)
}

export async function deleteLesson(uid: string, courseId: string, lessonId: string) {
  await deleteDoc(doc(lessonsCol(courseId), lessonId))
  await recount(courseId)
  const details = await instructorDetailsRef(uid)
  if (details) await updateDoc(details, { lessons: increment(-1) }).catch(() => {})
}

/** Renumber lessons 1..n in the given order. */
export async function reorderLessons(courseId: string, lessonIds: string[]) {
  const batch = writeBatch(db)
  lessonIds.forEach((id, i) => batch.update(doc(lessonsCol(courseId), id), { order: i + 1 }))
  await batch.commit()
}

// ------------------------------------------------------------------ media

/**
 * Uploads go to the instructor's own Storage folder, like the mobile app's
 * (`users/{uid}/uploads/…`); the Storage rules let only them write there.
 */
export async function uploadStudioImage(uid: string, file: File, kind: "course" | "lesson") {
  const blob = await resizeImage(file, 1600)
  const fileRef = ref(storage, `users/${uid}/uploads/${kind}_${Date.now()}.jpg`)
  await uploadBytes(fileRef, blob, { contentType: "image/jpeg" })
  return getDownloadURL(fileRef)
}

export function uploadStudioVideo(
  uid: string,
  file: File,
  kind: "preview" | "lesson",
  onProgress: (fraction: number) => void,
) {
  const ext = file.name.split(".").pop()?.toLowerCase() || "mp4"
  const fileRef = ref(storage, `users/${uid}/uploads/${kind}_${Date.now()}.${ext}`)
  const task = uploadBytesResumable(fileRef, file, { contentType: file.type || "video/mp4" })
  const done = new Promise<string>((resolve, reject) => {
    task.on(
      "state_changed",
      (s) => onProgress(s.totalBytes ? s.bytesTransferred / s.totalBytes : 0),
      reject,
      () => resolve(getDownloadURL(fileRef)),
    )
  })
  return { done, cancel: () => task.cancel() }
}

/** A video's length in seconds, read from the file in the browser. */
export function videoSeconds(source: File | string): Promise<number> {
  return new Promise((resolve) => {
    const video = document.createElement("video")
    const url = typeof source === "string" ? source : URL.createObjectURL(source)
    const finish = (value: number) => {
      if (typeof source !== "string") URL.revokeObjectURL(url)
      resolve(Number.isFinite(value) ? Math.round(value) : 0)
    }
    video.preload = "metadata"
    video.onloadedmetadata = () => finish(video.duration)
    video.onerror = () => finish(0)
    video.src = url
  })
}

// ------------------------------------------------------------------ money

/** The payout account the payment webhook credits (first one, as the server picks). */
export async function fetchPaymentAccount(uid: string): Promise<PaymentAccount | null> {
  const snap = await getDocs(query(collection(db, "users", uid, "payment_account"), limit(1)))
  const d = snap.docs[0]
  return d ? toPaymentAccount(d.id, d.data()) : null
}

export async function fetchPayouts(uid: string): Promise<Payout[]> {
  // Sorted here: ordering in the query would need a composite index.
  const snap = await getDocs(query(collection(db, "payouts"), where("instructorUserId", "==", uid)))
  return snap.docs
    .map((d) => toPayout(d.id, d.data()))
    .sort((a, b) => (b.createdAt?.getTime() ?? 0) - (a.createdAt?.getTime() ?? 0))
}

// ------------------------------------------------------------------ people

export async function fetchFollowers(ids: string[]): Promise<Follower[]> {
  const people = await Promise.all(
    ids.map(async (id) => {
      try {
        const snap = await getDoc(userDoc(id))
        if (!snap.exists()) return null
        const d = snap.data()
        return {
          id,
          name: str(d.display_name),
          photoUrl: str(d.photo_url),
          specialty: str(d.specialty),
        }
      } catch {
        return null
      }
    }),
  )
  return people.filter((p): p is Follower => p !== null)
}

/** Every booking; the rules let approved instructors read them, as on mobile. */
export async function fetchConsultations(): Promise<ConsultationRequest[]> {
  const snap = await getDocs(query(collection(db, "consultation"), orderBy("created_time", "desc")))
  return snap.docs.map((d) => toConsultation(d.id, d.data()))
}
