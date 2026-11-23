"use client"

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { useAuth } from "@/features/auth/components/auth-provider"
import { catalogKeys } from "@/features/catalog/hooks"
import type { Course, Lesson } from "@/features/catalog/types"
import {
  fetchPurchases,
  fetchRefundRequest,
  markLessonWatched,
  type RefundInput,
  requestRefund,
  setPurchaseArchived,
  type ReviewInput,
  submitReview,
} from "./api"
import type { Purchase } from "./types"

export const learningKeys = {
  purchases: (uid: string) => ["purchases", uid] as const,
  refund: (uid: string, courseId: string) => ["refund", uid, courseId] as const,
}

export function usePurchases() {
  const { user } = useAuth()
  const uid = user?.uid ?? ""
  return useQuery({
    queryKey: learningKeys.purchases(uid),
    queryFn: () => fetchPurchases(uid),
    enabled: !!uid,
  })
}

/** Archive or unarchive a purchase, updating My courses straight away. */
export function useArchivePurchase() {
  const { user } = useAuth()
  const uid = user?.uid ?? ""
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ purchaseId, archived }: { purchaseId: string; archived: boolean }) =>
      setPurchaseArchived(uid, purchaseId, archived),
    onMutate: async ({ purchaseId, archived }) => {
      await client.cancelQueries({ queryKey: learningKeys.purchases(uid) })
      const previous = client.getQueryData<Purchase[]>(learningKeys.purchases(uid))
      client.setQueryData<Purchase[]>(learningKeys.purchases(uid), (list) =>
        list?.map((p) => (p.id === purchaseId ? { ...p, archived } : p)),
      )
      return { previous }
    },
    onError: (_e, _v, ctx) => client.setQueryData(learningKeys.purchases(uid), ctx?.previous),
    onSettled: () => client.invalidateQueries({ queryKey: learningKeys.purchases(uid) }),
  })
}

/**
 * What the learner may watch in a course. Owners (a purchase, or listed as
 * a student), the course's own instructor, every lesson of a free course,
 * and lessons marked free.
 */
export function useCourseAccess(course: Course | undefined) {
  const { user } = useAuth()
  const purchases = usePurchases()
  const purchase = course ? purchases.data?.find((p) => p.courseId === course.id) : undefined
  const uid = user?.uid ?? ""
  const owned = !!purchase || (!!course && course.studentIds.includes(uid))
  const teaches = !!course && course.instructorId === uid
  const free = !!course && course.price <= 0
  return {
    loading: purchases.isPending,
    purchase,
    owned,
    teaches,
    canWatch: (lesson: Lesson) => owned || teaches || free || lesson.isFree,
  }
}

export function useMarkWatched(courseId: string) {
  const { user } = useAuth()
  const client = useQueryClient()
  const uid = user?.uid ?? ""
  return useMutation({
    mutationFn: ({ lessonId, purchaseId }: { lessonId: string; purchaseId?: string }) =>
      markLessonWatched(uid, courseId, lessonId, purchaseId),
    onMutate: ({ lessonId, purchaseId }) => {
      if (!purchaseId) return
      client.setQueryData<Purchase[]>(learningKeys.purchases(uid), (list) =>
        list?.map((p) =>
          p.id === purchaseId && !p.watchedLessonIds.includes(lessonId)
            ? { ...p, watchedLessonIds: [...p.watchedLessonIds, lessonId] }
            : p,
        ),
      )
    },
  })
}

export function useSubmitReview() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (input: ReviewInput) => submitReview(input),
    onSuccess: (_data, input) => {
      client.invalidateQueries({ queryKey: learningKeys.purchases(input.uid) })
      client.invalidateQueries({ queryKey: ["my-reviews", input.uid] })
      client.invalidateQueries({ queryKey: catalogKeys.reviews(input.course.id) })
      client.invalidateQueries({ queryKey: catalogKeys.course(input.course.id) })
      client.invalidateQueries({ queryKey: catalogKeys.courses })
    },
  })
}

export function useRefundRequest(courseId: string) {
  const { user } = useAuth()
  const uid = user?.uid ?? ""
  return useQuery({
    queryKey: learningKeys.refund(uid, courseId),
    queryFn: () => fetchRefundRequest(uid, courseId),
    enabled: !!uid && !!courseId,
  })
}

export function useRequestRefund() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (input: RefundInput) => requestRefund(input),
    onSuccess: (_data, input) =>
      client.invalidateQueries({ queryKey: learningKeys.refund(input.uid, input.course.id) }),
  })
}
