"use client"

import { useQuery, useQueryClient } from "@tanstack/react-query"
import { useEffect, useState } from "react"
import { useAuth } from "@/features/auth/components/auth-provider"
import { catalogKeys } from "@/features/catalog/hooks"
import { hasPurchased, watchOrder } from "./api"
import type { Order } from "./types"

export function usePurchased(courseId: string) {
  const { user } = useAuth()
  return useQuery({
    queryKey: ["purchased", user?.uid, courseId],
    queryFn: () => hasPurchased(user!.uid, courseId),
    enabled: !!user,
  })
}

type OrderState =
  { status: "loading" } | { status: "missing" } | { status: "error" } | { status: "ready"; order: Order }

/**
 * Follows an order live. When it completes, cached course data is refreshed
 * so every page shows the course as owned straight away.
 */
export function useOrder(orderId: string) {
  const { user } = useAuth()
  const client = useQueryClient()
  const [state, setState] = useState<OrderState>({ status: "loading" })

  useEffect(() => {
    if (!user) return
    return watchOrder(
      orderId,
      (order) => {
        setState(order ? { status: "ready", order } : { status: "missing" })
        if (order?.status === "completed") {
          client.invalidateQueries({ queryKey: catalogKeys.courses })
          client.invalidateQueries({ queryKey: ["purchased"] })
          for (const item of order.items)
            client.invalidateQueries({ queryKey: catalogKeys.course(item.courseId) })
        }
      },
      // Someone else's order (or a bad id) is refused by the security rules.
      (error) =>
        setState(
          (error as { code?: string }).code === "permission-denied"
            ? { status: "missing" }
            : { status: "error" },
        ),
    )
  }, [orderId, user, client])

  return state
}
