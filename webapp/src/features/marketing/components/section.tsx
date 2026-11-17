import { cn } from "@/lib/utils"

/** Small pill above a section title ("OUR COURSES"). */
export function SectionLabel({
  children,
  tone = "maroon",
  className,
}: {
  children: React.ReactNode
  tone?: "maroon" | "gold" | "light"
  className?: string
}) {
  return (
    <span
      className={cn(
        "mb-5 inline-block rounded-full px-4 py-1.5 text-[11px] font-bold tracking-[0.2em] uppercase",
        tone === "maroon" && "bg-maroon-tint text-primary",
        tone === "gold" && "bg-gold-light text-[#a87400]",
        tone === "light" && "bg-cream/15 text-cream",
        className,
      )}
    >
      {children}
    </span>
  )
}

export function SectionTitle({
  children,
  light = false,
  className,
}: {
  children: React.ReactNode
  light?: boolean
  className?: string
}) {
  return (
    <h2
      className={cn(
        "text-[clamp(2rem,4vw,3.25rem)] leading-[1.1] font-extrabold tracking-[-0.03em] text-balance",
        light ? "text-white" : "text-foreground",
        className,
      )}
    >
      {children}
    </h2>
  )
}

/** Curved divider between two section colours, as in the template. */
export function Wave({ from, to, flip = false }: { from: string; to: string; flip?: boolean }) {
  return (
    <svg
      aria-hidden
      viewBox="0 0 1440 60"
      preserveAspectRatio="none"
      className="-my-px block h-10 w-full sm:h-[60px]"
      style={{ background: to }}
    >
      <path
        fill={from}
        d={
          flip ? "M0,60 C360,0 1080,0 1440,60 L1440,60 L0,60 Z" : "M0,0 C360,60 1080,60 1440,0 L1440,0 L0,0 Z"
        }
      />
    </svg>
  )
}
