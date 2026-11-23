import { authErrorCode } from "./api"

/**
 * Turns a Firebase Auth error into a key under `auth.errors` in messages/*.json,
 * so learners see a friendly, translated message instead of a raw code.
 */
export function authErrorKey(error: unknown) {
  switch (authErrorCode(error)) {
    case "auth/invalid-credential":
    case "auth/wrong-password":
    case "auth/user-not-found":
    case "auth/invalid-email":
      return "invalidCredential"
    case "auth/email-already-in-use":
      return "emailInUse"
    case "auth/weak-password":
      return "weakPassword"
    case "auth/too-many-requests":
      return "tooManyRequests"
    case "auth/network-request-failed":
      return "network"
    case "auth/popup-closed-by-user":
    case "auth/cancelled-popup-request":
      return "popupClosed"
    case "auth/account-exists-with-different-credential":
      return "differentProvider"
    case "auth/expired-action-code":
    case "auth/invalid-action-code":
      return "linkExpired"
    default:
      return "generic"
  }
}

/** Errors that just mean "the user changed their mind": no toast needed. */
export const isSilentAuthError = (error: unknown) => authErrorKey(error) === "popupClosed"
