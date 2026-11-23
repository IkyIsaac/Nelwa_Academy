"use client"

import { useState } from "react"
import { cn } from "@/lib/utils"

/**
 * An image uploaded by instructors or admins. These can live on any host, so
 * we use a plain <img> (next/image would need every host listed up front).
 * Missing or broken images fall back to a soft brand-coloured panel.
 */
export function CoverImage({
  src,
  alt,
  className,
  priority = false,
}: {
  src: string
  alt: string
  className?: string
  /** Load straight away instead of when scrolled near (use for the first screen). */
  priority?: boolean
}) {
  const [broken, setBroken] = useState(false)

  if (!src || broken) {
    return (
      <div
        role="img"
        aria-label={alt}
        className={cn(
          "grid place-items-center bg-[radial-gradient(circle_at_30%_20%,var(--maroon-light),var(--maroon)_60%,var(--maroon-dark))]",
          className,
        )}
      >
        {/* eslint-disable-next-line @next/next/no-img-element -- local brand asset */}
        <img src="/brand/logo-light.png" alt="" className="w-2/5 max-w-32 opacity-25" />
      </div>
    )
  }

  return (
    // eslint-disable-next-line @next/next/no-img-element -- see comment above
    <img
      src={src}
      alt={alt}
      loading={priority ? "eager" : "lazy"}
      decoding="async"
      onError={() => setBroken(true)}
      className={cn("object-cover", className)}
    />
  )
}
