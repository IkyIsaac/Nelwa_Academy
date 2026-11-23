"use client"

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { useAuth } from "@/features/auth/components/auth-provider"
import {
  fetchCourse,
  fetchHomeAd,
  fetchInstructor,
  fetchLessons,
  fetchOptions,
  fetchPublishedCourses,
  fetchReviews,
  type Reaction,
  setFollowing,
  setReviewReaction,
} from "./api"
import type { Course, Instructor, Review } from "./types"

/** Query keys in one place so mutations can refresh the right data. */
export const catalogKeys = {
  courses: ["courses"] as const,
  course: (id: string) => ["course", id] as const,
  lessons: (id: string) => ["lessons", id] as const,
  reviews: (id: string) => ["reviews", id] as const,
  options: ["options"] as const,
  instructor: (id: string, signedIn: boolean) => ["instructor", id, signedIn] as const,
  ad: ["home-ad"] as const,
}

const FIVE_MINUTES = 5 * 60 * 1000

/** Waits for Firebase to restore the session so we don't query twice. */
function useAuthReady() {
  const { status, user } = useAuth()
  return { ready: status !== "loading", signedIn: status === "signed-in", uid: user?.uid ?? "" }
}

export function useCourses() {
  const { ready } = useAuthReady()
  return useQuery({
    queryKey: catalogKeys.courses,
    queryFn: fetchPublishedCourses,
    enabled: ready,
    staleTime: FIVE_MINUTES,
  })
}

export function useCourse(id: string) {
  const { ready } = useAuthReady()
  const client = useQueryClient()
  return useQuery({
    queryKey: catalogKeys.course(id),
    queryFn: () => fetchCourse(id),
    enabled: ready,
    staleTime: FIVE_MINUTES,
    // Show the card's data instantly when coming from a course list.
    initialData: () => client.getQueryData<Course[]>(catalogKeys.courses)?.find((c) => c.id === id),
  })
}

export function useLessons(courseId: string) {
  const { signedIn } = useAuthReady()
  return useQuery({
    queryKey: catalogKeys.lessons(courseId),
    queryFn: () => fetchLessons(courseId),
    enabled: signedIn,
    staleTime: FIVE_MINUTES,
  })
}

export function useReviews(courseId: string) {
  const { ready } = useAuthReady()
  return useQuery({
    queryKey: catalogKeys.reviews(courseId),
    queryFn: () => fetchReviews(courseId),
    enabled: ready,
  })
}

export function useCatalogOptions() {
  const { ready } = useAuthReady()
  return useQuery({
    queryKey: catalogKeys.options,
    queryFn: fetchOptions,
    enabled: ready,
    staleTime: FIVE_MINUTES,
  })
}

export function useInstructor(id: string) {
  const { ready, signedIn } = useAuthReady()
  return useQuery({
    queryKey: catalogKeys.instructor(id, signedIn),
    queryFn: () => fetchInstructor(id, signedIn),
    enabled: ready,
  })
}

export function useHomeAd() {
  const { signedIn } = useAuthReady()
  return useQuery({
    queryKey: catalogKeys.ad,
    queryFn: fetchHomeAd,
    enabled: signedIn,
    staleTime: FIVE_MINUTES,
  })
}

export function useFollow(instructor: Instructor | undefined) {
  const { uid, signedIn } = useAuthReady()
  const client = useQueryClient()
  const key = catalogKeys.instructor(instructor?.id ?? "", signedIn)

  return useMutation({
    mutationFn: (follow: boolean) => setFollowing(instructor!, uid, follow),
    // Update the button straight away; roll back if the write fails.
    onMutate: async (follow) => {
      await client.cancelQueries({ queryKey: key })
      const previous = client.getQueryData<Instructor>(key)
      if (previous) {
        const followerIds = follow
          ? [...previous.followerIds, uid]
          : previous.followerIds.filter((f) => f !== uid)
        client.setQueryData<Instructor>(key, { ...previous, followerIds })
      }
      return { previous }
    },
    onError: (_error, _follow, context) => context?.previous && client.setQueryData(key, context.previous),
  })
}

export function useReviewReaction(courseId: string) {
  const { uid } = useAuthReady()
  const client = useQueryClient()
  const key = catalogKeys.reviews(courseId)

  return useMutation({
    mutationFn: ({ reviewId, reaction }: { reviewId: string; reaction: Reaction }) =>
      setReviewReaction(courseId, reviewId, uid, reaction),
    onMutate: async ({ reviewId, reaction }) => {
      await client.cancelQueries({ queryKey: key })
      const previous = client.getQueryData<Review[]>(key)
      client.setQueryData<Review[]>(key, (reviews) =>
        reviews?.map((r) =>
          r.id !== reviewId
            ? r
            : {
                ...r,
                likedBy:
                  reaction === "like"
                    ? [...new Set([...r.likedBy, uid])]
                    : r.likedBy.filter((x) => x !== uid),
                dislikedBy:
                  reaction === "dislike"
                    ? [...new Set([...r.dislikedBy, uid])]
                    : r.dislikedBy.filter((x) => x !== uid),
              },
        ),
      )
      return { previous }
    },
    onError: (_error, _vars, context) => context?.previous && client.setQueryData(key, context.previous),
  })
}
