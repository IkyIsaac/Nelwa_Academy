import { getStorage } from "firebase/storage"
import { app } from "./client"

/** File uploads (profile photos, course media). Kept apart so other pages stay light. */
export const storage = getStorage(app)

/**
 * Uploads a file and returns its download URL. Modules that every page loads
 * (the header's notification hook, the course page) reach this with
 * `await import("@/lib/firebase/storage")`, so the Storage SDK is fetched
 * only when someone actually attaches a file.
 */
export async function uploadBlob(path: string, blob: Blob, contentType: string) {
  const { getDownloadURL, ref, uploadBytes } = await import("firebase/storage")
  const fileRef = ref(storage, path)
  await uploadBytes(fileRef, blob, { contentType })
  return getDownloadURL(fileRef)
}
