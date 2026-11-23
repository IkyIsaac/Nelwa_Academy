import type { LucideIcon } from "lucide-react"
import { cn } from "@/lib/utils"

/** Friendly message for empty lists, errors and "sign in to see this" panels. */
export function EmptyState({
  icon: Icon,
  title,
  body,
  action,
  className,
}: {
  icon: LucideIcon
  title: string
  body?: string
  action?: React.ReactNode
  className?: string
}) {
  return (
    <div
      className={cn(
        "flex flex-col items-center rounded-3xl border border-dashed border-border bg-cream/60 px-6 py-14 text-center",
        className,
      )}
    >
      <span className="mb-4 grid size-14 place-items-center rounded-2xl bg-maroon-tint text-primary">
        <Icon className="size-6" />
      </span>
      <h3 className="font-sans text-lg font-bold">{title}</h3>
      {body && <p className="mt-1.5 max-w-sm text-sm leading-relaxed text-muted-foreground">{body}</p>}
      {action && <div className="mt-6">{action}</div>}
    </div>
  )
}
