"use client"

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { useAuth } from "@/features/auth/components/auth-provider"
import { fetchInstructor, fetchLessons } from "@/features/catalog/api"
import { catalogKeys } from "@/features/catalog/hooks"
import type { Course } from "@/features/catalog/types"
import {
  addLesson,
  createCourse,
  deleteCourse,
  deleteLesson,
  fetchConsultations,
  fetchFollowers,
  fetchMyCourses,
  fetchPaymentAccount,
  fetchPayouts,
  reorderLessons,
  setCoursePublished,
  updateCourse,
  updateLesson,
} from "./api"
import type { CourseInput, LessonInput } from "./types"

export const studioKeys = {
  courses: (uid: string) => ["studio", "courses", uid] as const,
  lessons: (courseId: string) => ["studio", "lessons", courseId] as const,
  account: (uid: string) => ["studio", "account", uid] as const,
  payouts: (uid: string) => ["studio", "payouts", uid] as const,
  me: (uid: string) => ["studio", "me", uid] as const,
  followers: (uid: string) => ["studio", "followers", uid] as const,
  consultations: ["studio", "consultations"] as const,
}

/** Approved instructors only: the admin sets `instructor` when approving. */
export function useIsInstructor() {
  const { status, profile } = useAuth()
  return {
    loading: status === "loading" || (status === "signed-in" && !profile),
    allowed: !!profile?.instructor,
  }
}

function useUid() {
  const { user } = useAuth()
  return user?.uid ?? ""
}

export function useMyCourses() {
  const uid = useUid()
  return useQuery({ queryKey: studioKeys.courses(uid), queryFn: () => fetchMyCourses(uid), enabled: !!uid })
}

export function useMyCourse(courseId: string) {
  const courses = useMyCourses()
  return { ...courses, data: courses.data?.find((c) => c.id === courseId) }
}

export function useStudioLessons(courseId: string) {
  return useQuery({
    queryKey: studioKeys.lessons(courseId),
    queryFn: () => fetchLessons(courseId),
    enabled: !!courseId,
  })
}

/** Refresh the studio and the public catalog after a course or lesson change. */
function useRefresh() {
  const client = useQueryClient()
  const uid = useUid()
  return (courseId?: string) =>
    Promise.all([
      client.invalidateQueries({ queryKey: studioKeys.courses(uid) }),
      courseId && client.invalidateQueries({ queryKey: studioKeys.lessons(courseId) }),
      client.invalidateQueries({ queryKey: catalogKeys.courses }),
      courseId && client.invalidateQueries({ queryKey: catalogKeys.course(courseId) }),
      courseId && client.invalidateQueries({ queryKey: catalogKeys.lessons(courseId) }),
    ])
}

export function useSaveCourse() {
  const { user, profile } = useAuth()
  const refresh = useRefresh()
  return useMutation({
    mutationFn: async ({ id, input, publish }: { id?: string; input: CourseInput; publish?: boolean }) => {
      if (id) {
        await updateCourse(id, input)
        return id
      }
      return createCourse(user!.uid, profile?.displayName || user?.displayName || "", input, !!publish)
    },
    onSuccess: (id) => refresh(id),
  })
}

export function usePublishCourse() {
  const refresh = useRefresh()
  return useMutation({
    mutationFn: ({ id, publish }: { id: string; publish: boolean }) => setCoursePublished(id, publish),
    onSuccess: (_d, v) => refresh(v.id),
  })
}

export function useDeleteCourse() {
  const uid = useUid()
  const refresh = useRefresh()
  return useMutation({
    mutationFn: (course: Course) => deleteCourse(uid, course),
    onSuccess: () => refresh(),
  })
}

export function useSaveLesson(courseId: string) {
  const uid = useUid()
  const refresh = useRefresh()
  return useMutation({
    mutationFn: ({ id, input, order }: { id?: string; input: LessonInput; order: number }) =>
      id ? updateLesson(courseId, id, input) : addLesson(uid, courseId, input, order),
    onSuccess: () => refresh(courseId),
  })
}

export function useDeleteLesson(courseId: string) {
  const uid = useUid()
  const refresh = useRefresh()
  return useMutation({
    mutationFn: (lessonId: string) => deleteLesson(uid, courseId, lessonId),
    onSuccess: () => refresh(courseId),
  })
}

export function useReorderLessons(courseId: string) {
  const refresh = useRefresh()
  return useMutation({
    mutationFn: (ids: string[]) => reorderLessons(courseId, ids),
    onSettled: () => refresh(courseId),
  })
}

export function usePaymentAccount() {
  const uid = useUid()
  return useQuery({
    queryKey: studioKeys.account(uid),
    queryFn: () => fetchPaymentAccount(uid),
    enabled: !!uid,
  })
}

export function usePayouts() {
  const uid = useUid()
  return useQuery({ queryKey: studioKeys.payouts(uid), queryFn: () => fetchPayouts(uid), enabled: !!uid })
}

/** The instructor's public stats (followers, students, rating). */
export function useMyInstructorProfile() {
  const uid = useUid()
  return useQuery({ queryKey: studioKeys.me(uid), queryFn: () => fetchInstructor(uid, true), enabled: !!uid })
}

export function useFollowers() {
  const uid = useUid()
  const me = useMyInstructorProfile()
  const ids = me.data?.followerIds ?? []
  return useQuery({
    queryKey: [...studioKeys.followers(uid), ids.join(",")],
    queryFn: () => fetchFollowers(ids),
    enabled: !!me.data,
  })
}

export function useConsultations() {
  return useQuery({ queryKey: studioKeys.consultations, queryFn: fetchConsultations })
}
