"use client"

import { Bookmark } from "lucide-react"
import { motion } from "motion/react"
import { useTranslations } from "next-intl"
import { cn } from "@/lib/utils"
import { useWishlist } from "../wishlist"

/** Bookmark toggle. Sits on top of a card link, so it stops the click there. */
export function WishlistButton({ courseId, className }: { courseId: string; className?: string }) {
  const t = useTranslations("catalog")
  const saved = useWishlist((s) => s.courseIds.includes(courseId))
  const toggle = useWishlist((s) => s.toggle)

  return (
    <motion.button
      type="button"
      whileTap={{ scale: 0.85 }}
      aria-pressed={saved}
      aria-label={saved ? t("removeFromWishlist") : t("addToWishlist")}
      onClick={(event) => {
        event.preventDefault()
        event.stopPropagation()
        toggle(courseId)
      }}
      className={cn(
        "grid size-9 place-items-center rounded-full bg-white/90 text-primary shadow-soft backdrop-blur transition-colors hover:bg-white",
        className,
      )}
    >
      <motion.span key={String(saved)} initial={{ scale: 0.6 }} animate={{ scale: 1 }}>
        <Bookmark className="size-4" fill={saved ? "currentColor" : "none"} />
      </motion.span>
    </motion.button>
  )
}
