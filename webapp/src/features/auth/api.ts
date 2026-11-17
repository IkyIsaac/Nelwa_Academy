import {
  browserLocalPersistence,
  browserSessionPersistence,
  confirmPasswordReset,
  createUserWithEmailAndPassword,
  signOut as firebaseSignOut,
  GoogleAuthProvider,
  sendPasswordResetEmail,
  setPersistence,
  signInWithEmailAndPassword,
  signInWithPopup,
  signInWithRedirect,
  verifyPasswordResetCode,
  type User,
} from "firebase/auth"
import { doc, getDoc, serverTimestamp, setDoc } from "firebase/firestore"
import { auth, db } from "@/lib/firebase/client"

/**
 * Creates the `users/{uid}` document the first time someone signs in,
 * with the same fields the mobile app writes (see maybeCreateUser in
 * lib/backend/backend.dart). Creating it also triggers the welcome email,
 * which is sent in `language` (Swahili or English).
 */
export async function ensureUserDocument(user: User, locale: string) {
  const ref = doc(db, "users", user.uid)
  if ((await getDoc(ref)).exists()) return

  await setDoc(ref, {
    email: user.email ?? user.providerData[0]?.email ?? "",
    display_name: user.displayName ?? "",
    photo_url: user.photoURL ?? "",
    uid: user.uid,
    phone_number: user.phoneNumber ?? "",
    created_time: serverTimestamp(),
    language: locale === "sw" ? "sw" : "en",
  })
}

/** Email + password sign-in. "Remember me" keeps the session after the browser closes. */
export async function signInWithEmail(email: string, password: string, rememberMe: boolean, locale: string) {
  await setPersistence(auth, rememberMe ? browserLocalPersistence : browserSessionPersistence)
  const { user } = await signInWithEmailAndPassword(auth, email.trim(), password)
  await ensureUserDocument(user, locale)
  return user
}

export async function signUpWithEmail(email: string, password: string, locale: string) {
  await setPersistence(auth, browserLocalPersistence)
  const { user } = await createUserWithEmailAndPassword(auth, email.trim(), password)
  await ensureUserDocument(user, locale)
  return user
}

/**
 * Google sign-in in a popup. If the browser blocks popups we fall back to a
 * full-page redirect; AuthProvider picks the session up when the page returns.
 */
export async function signInWithGoogle(locale: string) {
  const provider = new GoogleAuthProvider()
  provider.setCustomParameters({ prompt: "select_account" })
  await setPersistence(auth, browserLocalPersistence)
  try {
    const { user } = await signInWithPopup(auth, provider)
    await ensureUserDocument(user, locale)
    return user
  } catch (error) {
    if (authErrorCode(error) === "auth/popup-blocked") {
      await signInWithRedirect(auth, provider)
      return null
    }
    throw error
  }
}

/** Emails a password-reset link. The link opens our /auth/action page. */
export function sendResetEmail(email: string) {
  return sendPasswordResetEmail(auth, email.trim(), {
    url: `${window.location.origin}/sign-in`,
  })
}

/** Checks a reset link's code and returns the email it belongs to. */
export function checkResetCode(code: string) {
  return verifyPasswordResetCode(auth, code)
}

export function setNewPassword(code: string, password: string) {
  return confirmPasswordReset(auth, code, password)
}

export function signOut() {
  return firebaseSignOut(auth)
}

/** The Firebase error code (e.g. "auth/invalid-credential"), or "" for other errors. */
export function authErrorCode(error: unknown): string {
  return typeof error === "object" && error && "code" in error ? String(error.code) : ""
}
