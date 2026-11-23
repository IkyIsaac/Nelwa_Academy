import Image from "next/image"
import Link from "next/link"
import { cn } from "@/lib/utils"

/** The Nelwa's Academy wordmark. `light` is the white version for maroon backgrounds. */
export function Logo({ light = false, className }: { light?: boolean; className?: string }) {
  return (
    <Link href="/" aria-label="Nelwa's Academy home" className={cn("inline-flex shrink-0", className)}>
      <Image
        src={light ? "/brand/logo-light.png" : "/brand/logo-maroon.png"}
        alt="Nelwa's Academy"
        width={1205}
        height={379}
        priority
        className="h-9 w-auto"
      />
    </Link>
  )
}
