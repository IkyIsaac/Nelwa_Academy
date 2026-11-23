"use client"

import { motion, type HTMLMotionProps } from "motion/react"

const EASE = [0.16, 1, 0.3, 1] as const

type RevealProps = HTMLMotionProps<"div"> & {
  /** Seconds to wait before animating, for staggering siblings by hand. */
  delay?: number
  /** Distance in px the content rises from. */
  y?: number
}

/**
 * Fades and lifts its content into place the first time it scrolls into view
 * (the template's `.reveal` effect). Turns itself off for reduced motion.
 */
export function Reveal({ delay = 0, y = 32, children, ...props }: RevealProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "0px 0px -80px 0px" }}
      transition={{ duration: 0.7, ease: EASE, delay }}
      {...props}
    >
      {children}
    </motion.div>
  )
}

/** A list whose children (wrapped in <StaggerItem>) reveal one after another. */
export function Stagger({ children, ...props }: HTMLMotionProps<"div">) {
  return (
    <motion.div
      initial="hidden"
      whileInView="shown"
      viewport={{ once: true, margin: "0px 0px -60px 0px" }}
      variants={{ hidden: {}, shown: { transition: { staggerChildren: 0.07 } } }}
      {...props}
    >
      {children}
    </motion.div>
  )
}

export function StaggerItem({ children, ...props }: HTMLMotionProps<"div">) {
  return (
    <motion.div
      variants={{
        hidden: { opacity: 0, y: 24 },
        shown: { opacity: 1, y: 0, transition: { duration: 0.55, ease: EASE } },
      }}
      {...props}
    >
      {children}
    </motion.div>
  )
}
