import { Star } from "lucide-react"
import { cn } from "@/lib/utils"
import { formatRating } from "../format"

/** Five stars, filled to the nearest half. */
export function Stars({ value, className }: { value: number; className?: string }) {
  return (
    <span className={cn("inline-flex items-center gap-0.5", className)} aria-hidden>
      {[1, 2, 3, 4, 5].map((n) => {
        const fill = Math.max(0, Math.min(1, value - n + 1))
        return (
          <span key={n} className="relative inline-block size-[1em]">
            <Star className="absolute inset-0 size-full text-gold/30" fill="currentColor" strokeWidth={0} />
            {fill > 0 && (
              <span
                className="absolute inset-0 overflow-hidden"
                style={{ width: `${fill >= 0.75 ? 100 : 50}%` }}
              >
                <Star className="size-[1em] text-gold" fill="currentColor" strokeWidth={0} />
              </span>
            )}
          </span>
        )
      })}
    </span>
  )
}

/** "★ 4.5 (12)" — compact rating used on cards. */
export function RatingBadge({
  rating,
  count,
  className,
}: {
  rating: number
  count?: number
  className?: string
}) {
  if (!rating) return null
  return (
    <span className={cn("inline-flex items-center gap-1 text-xs font-semibold", className)}>
      <Star className="size-3.5 text-gold" fill="currentColor" strokeWidth={0} />
      {formatRating(rating)}
      {count !== undefined && <span className="font-medium text-muted-foreground">({count})</span>}
    </span>
  )
}
