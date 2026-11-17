import type { User } from "firebase/auth"
import { doc, getDoc } from "firebase/firestore"
import { routes } from "@/config/site"
import { db } from "@/lib/firebase/client"

/**
 * Only allow redirects back into this site ("/learn", not "//evil.com" or
 * "https://…"), so a crafted ?next= link can't send people elsewhere.
 */
export function safeNext(next: string | null | undefined): string | null {
  if (!next || !next.startsWith("/") || next.startsWith("//")) return null
  return next
}

/**
 * Where to send someone right after they sign in or sign up:
 * new accounts without a name go through onboarding first, everyone else
 * returns to the page they came from (or Home).
 */
export async function destinationAfterSignIn(user: User, next: string | null) {
  const snap = await getDoc(doc(db, "users", user.uid))
  const name = snap.get("display_name")
  if (typeof name !== "string" || !name.trim()) {
    const target = safeNext(next)
    return target ? `${routes.completeProfile}?next=${encodeURIComponent(target)}` : routes.completeProfile
  }
  return safeNext(next) ?? routes.home
}
