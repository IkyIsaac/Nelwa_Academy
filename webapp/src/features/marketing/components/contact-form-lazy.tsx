"use client"

import dynamic from "next/dynamic"
import { useEffect, useRef, useState } from "react"
import { Skeleton } from "@/components/ui/skeleton"

const placeholder = (
  <div className="space-y-4" aria-hidden>
    <Skeleton className="h-11 w-full rounded-xl" />
    <Skeleton className="h-11 w-full rounded-xl" />
    <Skeleton className="h-32 w-full rounded-xl" />
    <Skeleton className="h-12 w-40 rounded-full" />
  </div>
)

const ContactForm = dynamic(() => import("./contact-form").then((m) => m.ContactForm), {
  ssr: false,
  loading: () => placeholder,
})

/**
 * The contact form sits at the very bottom of the landing page, and its form
 * and validation libraries are about 100 KB. Load them only when the visitor
 * scrolls near it, so the first screen arrives sooner on mobile data.
 */
export function LazyContactForm() {
  const ref = useRef<HTMLDivElement>(null)
  const [near, setNear] = useState(false)

  useEffect(() => {
    const el = ref.current
    if (!el || near) return
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries.some((e) => e.isIntersecting)) setNear(true)
      },
      { rootMargin: "600px 0px" },
    )
    observer.observe(el)
    return () => observer.disconnect()
  }, [near])

  return <div ref={ref}>{near ? <ContactForm /> : placeholder}</div>
}
