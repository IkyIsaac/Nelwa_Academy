import { ChevronLeft } from "lucide-react"
import Link from "next/link"
import { cn } from "@/lib/utils"

/**
 * The cream title band at the top of app pages. Leaves room for the fixed
 * site header, and offers an optional "back" link like the mobile app bar.
 */
export function PageHeader({
  title,
  eyebrow,
  description,
  back,
  children,
  className,
}: {
  title: React.ReactNode
  eyebrow?: string
  description?: React.ReactNode
  back?: { href: string; label: string }
  children?: React.ReactNode
  className?: string
}) {
  return (
    <div className={cn("relative overflow-hidden bg-cream pt-28 pb-10 sm:pt-32", className)}>
      <div className="pointer-events-none absolute -top-32 -right-24 size-96 rounded-full bg-gold-light/70 blur-3xl" />
      <div className="container-page relative">
        {back && (
          <Link
            href={back.href}
            className="mb-4 inline-flex items-center gap-1 text-sm font-semibold text-muted-foreground transition-colors hover:text-primary"
          >
            <ChevronLeft className="size-4" />
            {back.label}
          </Link>
        )}
        {eyebrow && <p className="mb-2 text-xs font-bold tracking-[0.2em] text-gold uppercase">{eyebrow}</p>}
        <h1 className="text-3xl font-extrabold text-balance sm:text-4xl lg:text-5xl">{title}</h1>
        {description && <p className="mt-3 max-w-2xl text-muted-foreground">{description}</p>}
        {children && <div className="mt-6">{children}</div>}
      </div>
    </div>
  )
}
