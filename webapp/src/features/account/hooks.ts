"use client"

import { useMutation, useQuery } from "@tanstack/react-query"
import { useEffect, useState } from "react"
import { useAuth } from "@/features/auth/components/auth-provider"
import {
  fetchFollowedInstructors,
  fetchMyReviews,
  fetchPurchaseHistory,
  markNotificationsSeen,
  watchNotifications,
  watchSupportMessages,
} from "./api"
import type { AppNotification, SupportMessage } from "./types"

type Live<T> = { status: "loading" } | { status: "error" } | { status: "ready"; data: T }

/** Subscribes to a Firestore listener while `key` is set. */
function useLive<T>(
  key: string,
  subscribe: (onChange: (data: T) => void, onError: () => void) => () => void,
): Live<T> {
  const [state, setState] = useState<{ key: string; live: Live<T> }>({ key: "", live: { status: "loading" } })
  useEffect(() => {
    if (!key) return
    return subscribe(
      (data) => setState({ key, live: { status: "ready", data } }),
      () => setState({ key, live: { status: "error" } }),
    )
    // `subscribe` is recreated each render; `key` captures what it depends on.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [key])
  return state.key === key ? state.live : { status: "loading" }
}

export function useNotifications() {
  const { user } = useAuth()
  const uid = user?.uid ?? ""
  return useLive<AppNotification[]>(uid, (onChange, onError) => watchNotifications(uid, onChange, onError))
}

export function useUnreadCount() {
  const live = useNotifications()
  return live.status === "ready" ? live.data.filter((n) => !n.seen).length : 0
}

export function useMarkSeen() {
  const { user } = useAuth()
  return useMutation({ mutationFn: (ids: string[]) => markNotificationsSeen(user!.uid, ids) })
}

export function useSupportMessages(supportId: string) {
  return useLive<SupportMessage[]>(supportId, (onChange, onError) =>
    watchSupportMessages(supportId, onChange, onError),
  )
}

export function usePurchaseHistory() {
  const { user } = useAuth()
  const uid = user?.uid ?? ""
  return useQuery({ queryKey: ["purchase-history", uid], queryFn: () => fetchPurchaseHistory(uid), enabled: !!uid })
}

export function useMyReviews() {
  const { user } = useAuth()
  const uid = user?.uid ?? ""
  return useQuery({ queryKey: ["my-reviews", uid], queryFn: () => fetchMyReviews(uid), enabled: !!uid })
}

export function useFollowedInstructors() {
  const { profile } = useAuth()
  const ids = profile?.subscriptionIds ?? []
  return useQuery({
    queryKey: ["followed", ids],
    queryFn: () => fetchFollowedInstructors(ids),
    enabled: !!profile,
  })
}
