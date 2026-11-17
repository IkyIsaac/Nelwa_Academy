"use client"

import { Loader2 } from "lucide-react"
import { usePathname, useRouter, useSearchParams } from "next/navigation"
import { useEffect, useRef } from "react"
import { routes } from "@/config/site"
import { safeNext } from "../redirects"
import { useAuth } from "./auth-provider"

function FullPageSpinner() {
  return (
    <div className="grid min-h-[60dvh] place-items-center">
      <Loader2 className="size-7 animate-spin text-primary" aria-label="Loading" />
    </div>
  )
}

/**
 * Shows its content only to signed-in learners. Visitors are sent to Sign In
 * and brought back here afterwards.
 */
export function RequireAuth({ children }: { children: React.ReactNode }) {
  const { status } = useAuth()
  const router = useRouter()
  const pathname = usePathname()

  useEffect(() => {
    if (status === "signed-out") {
      router.replace(`${routes.signIn}?next=${encodeURIComponent(pathname)}`)
    }
  }, [status, router, pathname])

  if (status !== "signed-in") return <FullPageSpinner />
  return <>{children}</>
}

/**
 * For Sign In / Sign Up pages: someone who is already signed in when the page
 * opens is sent on to Home (or ?next=). Sign-ins that happen *on* the page are
 * left to the form, which decides where to go (e.g. onboarding).
 */
export function GuestOnly({ children }: { children: React.ReactNode }) {
  const { status } = useAuth()
  const router = useRouter()
  const searchParams = useSearchParams()
  const decided = useRef(false)

  useEffect(() => {
    if (decided.current || status === "loading") return
    decided.current = true
    if (status === "signed-in") router.replace(safeNext(searchParams.get("next")) ?? routes.home)
  }, [status, router, searchParams])

  if (status === "loading") return <FullPageSpinner />
  return <>{children}</>
}
