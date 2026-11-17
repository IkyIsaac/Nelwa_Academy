import { Button as ButtonPrimitive } from "@base-ui/react/button"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

/**
 * Pill-shaped buttons from the landing template.
 * Hover lifts the button slightly; press pushes it back down.
 */
const buttonVariants = cva(
  "group/button inline-flex shrink-0 cursor-pointer items-center justify-center gap-2 rounded-full border-2 border-transparent font-semibold whitespace-nowrap transition-all duration-300 ease-(--ease-out-expo) outline-none select-none focus-visible:ring-4 focus-visible:ring-ring/30 active:translate-y-0 disabled:pointer-events-none disabled:opacity-50 aria-invalid:border-destructive [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
  {
    variants: {
      variant: {
        default:
          "bg-primary text-primary-foreground hover:-translate-y-0.5 hover:bg-maroon-dark hover:shadow-[0_10px_28px_rgb(93_8_11/0.25)]",
        cream:
          "bg-cream text-maroon hover:-translate-y-0.5 hover:border-cream hover:bg-transparent hover:text-cream",
        gold: "bg-gold text-white hover:-translate-y-0.5 hover:shadow-[0_10px_28px_rgb(224_158_0/0.35)] hover:brightness-105",
        outline:
          "border-primary bg-transparent text-primary hover:-translate-y-0.5 hover:bg-primary hover:text-primary-foreground",
        "outline-light":
          "border-white/70 bg-transparent text-white hover:-translate-y-0.5 hover:border-white hover:bg-white/10",
        secondary: "bg-secondary text-secondary-foreground hover:bg-cream-deep aria-expanded:bg-cream-deep",
        ghost: "text-foreground hover:bg-muted aria-expanded:bg-muted",
        destructive: "bg-destructive/10 text-destructive hover:bg-destructive/20",
        link: "rounded-md border-0 px-0 text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-11 px-6 text-sm",
        sm: "h-9 px-4 text-[0.8rem]",
        lg: "h-13 px-8 text-[0.95rem]",
        icon: "size-10",
        "icon-sm": "size-8 [&_svg:not([class*='size-'])]:size-3.5",
        "icon-lg": "size-12",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  },
)

function Button({
  className,
  variant = "default",
  size = "default",
  render,
  nativeButton,
  ...props
}: ButtonPrimitive.Props & VariantProps<typeof buttonVariants>) {
  return (
    <ButtonPrimitive
      data-slot="button"
      render={render}
      // A button rendered as a link (render={<Link />}) is not a native <button>.
      nativeButton={nativeButton ?? !render}
      className={cn(buttonVariants({ variant, size, className }))}
      {...props}
    />
  )
}

export { Button, buttonVariants }
