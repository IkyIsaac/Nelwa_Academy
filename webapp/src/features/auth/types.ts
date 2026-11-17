import type { DocumentData } from "firebase/firestore"
import { bool, date, refId, refList, str, strList } from "@/lib/firebase/fields"

/** A learner's progress through one course, stored on the user document. */
export type ContinueWatching = {
  courseId: string
  completedLessonIds: string[]
}

/** The `users/{uid}` document, shared with the mobile app. */
export type UserProfile = {
  uid: string
  email: string
  displayName: string
  photoUrl: string
  phoneNumber: string
  createdTime: Date | null
  dateOfBirth: Date | null
  country: string
  education: string
  experience: string
  useFor: string
  aboutUser: string
  specialty: string
  interests: string[]
  role: string
  instructor: boolean
  /** "", "pending", "approved" or "rejected" */
  instructorStatus: string
  purchasedCourseIds: string[]
  subscriptionIds: string[]
  continueWatching: ContinueWatching[]
}

export function toUserProfile(uid: string, d: DocumentData): UserProfile {
  return {
    uid,
    email: str(d.email),
    displayName: str(d.display_name),
    photoUrl: str(d.photo_url),
    phoneNumber: str(d.phone_number),
    createdTime: date(d.created_time),
    dateOfBirth: date(d.date_of_birth),
    country: str(d.country),
    education: str(d.education),
    experience: str(d.experience),
    useFor: str(d.use_for),
    aboutUser: str(d.about_user),
    specialty: str(d.specialty),
    interests: strList(d.interests),
    role: str(d.role),
    instructor: bool(d.instructor),
    instructorStatus: str(d.instructor_status),
    purchasedCourseIds: refList(d.purchased_courses).map((r) => r.id),
    subscriptionIds: refList(d.subscriptions).map((r) => r.id),
    continueWatching: Array.isArray(d.continue_watching)
      ? d.continue_watching.map((item: DocumentData) => ({
          courseId: refId(item?.courses),
          completedLessonIds: refList(item?.completed_lessons).map((r) => r.id),
        }))
      : [],
  }
}

/** True once the learner has finished the "complete your profile" step. */
export const hasCompletedProfile = (p: UserProfile) => p.displayName.trim().length > 0
