import {
  arrayRemove,
  arrayUnion,
  collection,
  doc,
  getDoc,
  getDocs,
  limit,
  orderBy,
  query,
  updateDoc,
  where,
} from "firebase/firestore"
import { db } from "@/lib/firebase/client"
import { num, refList, str, strList } from "@/lib/firebase/fields"
import { type Ad, type Course, type Instructor, toCourse, toLesson, toOptions, toReview } from "./types"

/**
 * Firestore reads and writes for browsing the catalog.
 *
 * The catalog is small (tens of courses), so we load every published course
 * once and filter/search in the browser — the same approach as the mobile app,
 * and it keeps search instant.
 */

export async function fetchPublishedCourses(): Promise<Course[]> {
  const snap = await getDocs(query(collection(db, "courses"), where("is_published", "==", true)))
  return snap.docs.map((d) => toCourse(d.id, d.data()))
}

export async function fetchCourse(id: string): Promise<Course | null> {
  try {
    const snap = await getDoc(doc(db, "courses", id))
    return snap.exists() ? toCourse(snap.id, snap.data()) : null
  } catch (error) {
    // Visitors may not read unpublished courses: treat that as "not found".
    if ((error as { code?: string }).code === "permission-denied") return null
    throw error
  }
}

/** Lessons hold the video links, so Firestore only lets signed-in users read them. */
export async function fetchLessons(courseId: string) {
  const snap = await getDocs(query(collection(db, "courses", courseId, "lessons"), orderBy("order")))
  return snap.docs.map((d) => toLesson(d.id, d.data()))
}

export async function fetchReviews(courseId: string) {
  const snap = await getDocs(
    query(collection(db, "courses", courseId, "courses_review"), orderBy("created_at", "desc")),
  )
  return snap.docs.map((d) => toReview(d.id, d.data()))
}

export async function fetchOptions() {
  const snap = await getDocs(query(collection(db, "options"), limit(1)))
  return toOptions(snap.docs[0]?.data())
}

/**
 * An instructor's public stats live in users/{id}/instructor_details. The
 * name and photo live on the user profile, which only signed-in learners may
 * read; visitors get the name from the instructor's courses instead.
 */
export async function fetchInstructor(id: string, signedIn: boolean): Promise<Instructor> {
  const [detailsSnap, userSnap] = await Promise.all([
    getDocs(query(collection(db, "users", id, "instructor_details"), limit(1))),
    signedIn ? getDoc(doc(db, "users", id)) : Promise.resolve(null),
  ])
  const details = detailsSnap.docs[0]
  const d = details?.data() ?? {}
  const user = userSnap?.exists() ? userSnap.data() : {}
  return {
    id,
    name: str(user.display_name),
    photoUrl: str(user.photo_url),
    specialty: str(d.specialty) || str(user.specialty),
    about: str(d.about_instructor) || str(user.about_user),
    education: str(d.education) || str(user.education),
    expertise: strList(d.expertise),
    rating: num(d.rating),
    lessons: num(d.lessons),
    studentIds: refList(d.students).map((r) => r.id),
    followerIds: refList(d.followers).map((r) => r.id),
    detailsId: details?.id ?? "",
  }
}

/** Follow or unfollow, writing both sides exactly like the mobile app. */
export async function setFollowing(instructor: Instructor, uid: string, follow: boolean) {
  const me = doc(db, "users", uid)
  const them = doc(db, "users", instructor.id)
  const change = follow ? arrayUnion : arrayRemove
  await Promise.all([
    instructor.detailsId &&
      updateDoc(doc(db, "users", instructor.id, "instructor_details", instructor.detailsId), {
        followers: change(me),
      }),
    updateDoc(me, { subscriptions: change(them) }),
  ])
}

export type Reaction = "like" | "dislike" | null

/** Sets the current user's thumbs up/down on a review (null clears it). */
export async function setReviewReaction(courseId: string, reviewId: string, uid: string, reaction: Reaction) {
  const me = doc(db, "users", uid)
  await updateDoc(doc(db, "courses", courseId, "courses_review", reviewId), {
    liked: reaction === "like" ? arrayUnion(me) : arrayRemove(me),
    disliked: reaction === "dislike" ? arrayUnion(me) : arrayRemove(me),
  })
}

/** Remembers that a signed-in learner watched the preview (an admin statistic). */
export async function recordPreviewView(courseId: string, uid: string) {
  await updateDoc(doc(db, "courses", courseId), { preview_views: arrayUnion(doc(db, "users", uid)) })
}

/** The home-screen banner. Ads are visible to signed-in learners only. */
export async function fetchHomeAd(): Promise<Ad | null> {
  const snap = await getDocs(query(collection(db, "ads"), limit(5)))
  const ad = snap.docs.find((d) => d.data().is_active !== false && str(d.data().image_url))
  if (!ad) return null
  const d = ad.data()
  return { id: ad.id, title: str(d.title), description: str(d.description), imageUrl: str(d.image_url) }
}
