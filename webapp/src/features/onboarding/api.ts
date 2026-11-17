import { updateProfile } from "firebase/auth"
import { doc, Timestamp, updateDoc } from "firebase/firestore"
import { getDownloadURL, ref, uploadBytes } from "firebase/storage"
import { auth, db, storage } from "@/lib/firebase/client"
import { resizeImage } from "@/lib/image"

/** Uploads a profile photo to users/{uid}/uploads/ (same place as mobile) and returns its URL. */
export async function uploadAvatar(uid: string, file: File) {
  const blob = await resizeImage(file)
  const fileRef = ref(storage, `users/${uid}/uploads/avatar_${Date.now()}.jpg`)
  await uploadBytes(fileRef, blob, { contentType: "image/jpeg" })
  return getDownloadURL(fileRef)
}

export type ProfileDetails = {
  displayName: string
  photoUrl: string
  dateOfBirth: Date | null
  country: string
}

/** Saves "Complete your profile" to users/{uid} and to the Firebase account. */
export async function saveProfile(uid: string, details: ProfileDetails) {
  await updateDoc(doc(db, "users", uid), {
    display_name: details.displayName.trim(),
    photo_url: details.photoUrl,
    date_of_birth: details.dateOfBirth ? Timestamp.fromDate(details.dateOfBirth) : null,
    country: details.country,
  })
  if (auth.currentUser) {
    await updateProfile(auth.currentUser, {
      displayName: details.displayName.trim(),
      photoURL: details.photoUrl || null,
    })
  }
}

export type LearningPreferences = {
  interests: string[]
  experience: string
  useFor: string
}

/** Saves the interests questionnaire (used to personalise Home). */
export function saveLearningPreferences(uid: string, prefs: LearningPreferences) {
  return updateDoc(doc(db, "users", uid), {
    interests: prefs.interests,
    experience: prefs.experience,
    use_for: prefs.useFor,
  })
}
