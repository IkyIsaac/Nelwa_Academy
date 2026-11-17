"use client"

import { onAuthStateChanged, type User } from "firebase/auth"
import { doc, onSnapshot } from "firebase/firestore"
import { createContext, useContext, useEffect, useState } from "react"
import { auth, db } from "@/lib/firebase/client"
import { toUserProfile, type UserProfile } from "../types"

type AuthState =
  | { status: "loading"; user: null; profile: null }
  | { status: "signed-out"; user: null; profile: null }
  | { status: "signed-in"; user: User; profile: UserProfile | null }

const AuthContext = createContext<AuthState>({ status: "loading", user: null, profile: null })

/**
 * Tracks the Firebase session and keeps the learner's `users/{uid}` document
 * live, so profile edits made on mobile show up here straight away.
 */
export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState<AuthState>({ status: "loading", user: null, profile: null })

  useEffect(() => {
    let stopProfile: (() => void) | undefined

    const stopAuth = onAuthStateChanged(auth, (user) => {
      stopProfile?.()
      if (!user) {
        setState({ status: "signed-out", user: null, profile: null })
        return
      }
      setState({ status: "signed-in", user, profile: null })
      stopProfile = onSnapshot(
        doc(db, "users", user.uid),
        (snap) =>
          setState({
            status: "signed-in",
            user,
            profile: snap.exists() ? toUserProfile(user.uid, snap.data()) : null,
          }),
        () => setState({ status: "signed-in", user, profile: null }),
      )
    })

    return () => {
      stopProfile?.()
      stopAuth()
    }
  }, [])

  return <AuthContext.Provider value={state}>{children}</AuthContext.Provider>
}

/** The current session: `status`, the Firebase `user` and their `profile`. */
export const useAuth = () => useContext(AuthContext)
