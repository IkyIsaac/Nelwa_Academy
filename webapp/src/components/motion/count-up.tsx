"use client"

import { animate, useInView, useReducedMotion } from "motion/react"
import { useEffect, useRef } from "react"

/**
 * Counts from 0 to `to` the first time the number scrolls into view.
 * Pass `grouping={false}` for years, so 2013 isn't shown as "2,012".
 */
export function CountUp({
  to,
  duration = 1.6,
  grouping = true,
  className,
}: {
  to: number
  duration?: number
  grouping?: boolean
  className?: string
}) {
  const ref = useRef<HTMLSpanElement>(null)
  const inView = useInView(ref, { once: true, margin: "0px 0px -60px 0px" })
  const reduceMotion = useReducedMotion()
  const format = (n: number) => (grouping ? n.toLocaleString("en-US") : String(n))

  useEffect(() => {
    const node = ref.current
    if (!node || !inView) return
    if (reduceMotion) {
      node.textContent = format(to)
      return
    }
    const controls = animate(0, to, {
      duration,
      ease: [0.16, 1, 0.3, 1],
      onUpdate: (value) => (node.textContent = format(Math.round(value))),
    })
    return () => controls.stop()
  }, [inView, to, duration, reduceMotion]) // eslint-disable-line react-hooks/exhaustive-deps -- format only depends on `grouping`

  // Server HTML shows the final number, so it reads correctly without JavaScript.
  return (
    <span ref={ref} className={className}>
      {format(to)}
    </span>
  )
}
