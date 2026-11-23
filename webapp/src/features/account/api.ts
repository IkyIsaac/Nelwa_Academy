import {
  EmailAuthProvider,
  GoogleAuthProvider,
  deleteUser,
  reauthenticateWithCredential,
  reauthenticateWithPopup,
  updatePassword,
  updateProfile,
  type User,
} from "firebase/auth"
import {
  addDoc,
  collection,
  doc,
  getDoc,
  getDocs,
  onSnapshot,
  orderBy,
  query,
  serverTimestamp,
  Timestamp,
  updateDoc,
  writeBatch,
} from "firebase/firestore"
import { str } from "@/lib/firebase/fields"
import { db } from "@/lib/firebase/client"
import { resizeImage } from "@/lib/image"
import {
  type AppNotification,
  type FollowedInstructor,
  type MyReview,
  type PurchaseRecord,
  type SupportMessage,
  toMyReview,
  toNotification,
  toPurchaseRecord,
  toSupportMessage,
} from "./types"

const userDoc = (uid: string) => doc(db, "users", uid)

// ---------------------------------------------------------------- profile

export type PersonalInfo = {
  displayName: string
  photoUrl: string
  aboutUser: string
  specialty: string
  phoneNumber: string
  dateOfBirth: Date | null
  country: string
  education: string
}

/** Same `users/{uid}` fields as the mobile Personal Info screen. */
export async function savePersonalInfo(user: User, info: PersonalInfo) {
  await updateDoc(userDoc(user.uid), {
    display_name: info.displayName.trim(),
    photo_url: info.photoUrl,
    about_user: info.aboutUser.trim(),
    specialty: info.specialty.trim(),
    phone_number: info.phoneNumber.trim(),
    date_of_birth: info.dateOfBirth ? Timestamp.fromDate(info.dateOfBirth) : null,
    country: info.country,
    education: info.education.trim(),
  })
  await updateProfile(user, { displayName: info.displayName.trim(), photoURL: info.photoUrl || null })
}

// ---------------------------------------------------------------- security

export const signsInWithPassword = (user: User) => user.providerData.some((p) => p.providerId === "password")

/** Firebase needs a recent sign-in before sensitive changes. */
async function reauthenticate(user: User, password?: string) {
  if (signsInWithPassword(user)) {
    await reauthenticateWithCredential(user, EmailAuthProvider.credential(user.email ?? "", password ?? ""))
  } else {
    await reauthenticateWithPopup(user, new GoogleAuthProvider())
  }
}

export async function changePassword(user: User, current: string, next: string) {
  await reauthenticate(user, current)
  await updatePassword(user, next)
}

/**
 * Deletes the Firebase account. The `onUserDeleted` Cloud Function then
 * removes the profile document, as when deleting from the app.
 */
export async function deleteAccount(user: User, password?: string) {
  await reauthenticate(user, password)
  await deleteUser(user)
}

// ---------------------------------------------------------------- activity

export async function fetchPurchaseHistory(uid: string): Promise<PurchaseRecord[]> {
  const snap = await getDocs(query(collection(db, "users", uid, "purchase_history"), orderBy("date", "desc")))
  return snap.docs.map((d) => toPurchaseRecord(d.id, d.data()))
}

export async function fetchMyReviews(uid: string): Promise<MyReview[]> {
  const snap = await getDocs(
    query(collection(db, "users", uid, "user_reviews"), orderBy("created_at", "desc")),
  )
  return snap.docs.map((d) => toMyReview(d.id, d.data()))
}

/** Profiles of followed instructors (instructor profiles are readable by learners). */
export async function fetchFollowedInstructors(ids: string[]): Promise<FollowedInstructor[]> {
  const snaps = await Promise.all(ids.map((id) => getDoc(userDoc(id)).catch(() => null)))
  return snaps
    .filter((s) => s?.exists())
    .map((s) => ({
      id: s!.id,
      name: str(s!.get("display_name")),
      photoUrl: str(s!.get("photo_url")),
      specialty: str(s!.get("specialty")),
    }))
}

// ---------------------------------------------------------------- notifications

export function watchNotifications(
  uid: string,
  onChange: (list: AppNotification[]) => void,
  onError: () => void,
) {
  return onSnapshot(
    query(collection(db, "users", uid, "notification"), orderBy("time_stamp", "desc")),
    (snap) => onChange(snap.docs.map((d) => toNotification(d.id, d.data()))),
    onError,
  )
}

export async function markNotificationsSeen(uid: string, ids: string[]) {
  const batch = writeBatch(db)
  ids.forEach((id) => batch.update(doc(db, "users", uid, "notification", id), { seen: true }))
  await batch.commit()
}

// ---------------------------------------------------------------- support chat

export function watchSupportMessages(
  supportId: string,
  onChange: (list: SupportMessage[]) => void,
  onError: () => void,
) {
  return onSnapshot(
    query(collection(db, "support", supportId, "support_message"), orderBy("time_stamp", "asc")),
    (snap) => onChange(snap.docs.map((d) => toSupportMessage(d.id, d.data()))),
    onError,
  )
}

export async function uploadSupportImage(uid: string, file: File) {
  const blob = await resizeImage(file, 1600)
  const { uploadBlob } = await import("@/lib/firebase/storage")
  return uploadBlob(`users/${uid}/uploads/support_${Date.now()}.jpg`, blob, "image/jpeg")
}

/**
 * Sends a message to the academy. The first message opens the learner's
 * thread (`support/{id}` with `user` = them) and links it from their
 * profile, in that order: the security rules check the thread's owner
 * before allowing messages in it.
 */
export async function sendSupportMessage(uid: string, supportId: string, text: string, image: string) {
  let threadId = supportId
  if (!threadId) {
    const thread = await addDoc(collection(db, "support"), {
      user: userDoc(uid),
      start_date: serverTimestamp(),
    })
    threadId = thread.id
    await updateDoc(userDoc(uid), { support: thread })
  }
  await addDoc(collection(db, "support", threadId, "support_message"), {
    message: text,
    image,
    time_stamp: serverTimestamp(),
    seen: false,
    user_message: true,
  })
  return threadId
}

// ---------------------------------------------------------------- consultation

export type ConsultationInput = {
  uid: string
  name: string
  email: string
  phone: string
  department: string
  reason: string
  date: Date
}

/** Same `consultation` fields as the mobile booking form. Visitors may book too. */
export async function bookConsultation(input: ConsultationInput) {
  await addDoc(collection(db, "consultation"), {
    uid: input.uid,
    display_name: input.name.trim(),
    user_name: input.name.trim(),
    email: input.email.trim(),
    phone_number: input.phone.trim(),
    selected_department: input.department,
    reason_for_visit: input.reason.trim(),
    appointment_time: Timestamp.fromDate(input.date),
    created_time: serverTimestamp(),
    edited_time: serverTimestamp(),
  })
}
