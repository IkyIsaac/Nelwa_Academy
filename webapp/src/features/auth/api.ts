import { signOut as firebaseSignOut } from "firebase/auth"
import { auth } from "@/lib/firebase/client"

/** Signs the learner out on this device. */
export function signOut() {
  return firebaseSignOut(auth)
}
