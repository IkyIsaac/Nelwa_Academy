"use client"

import { Check, Plus } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { usePathname, useRouter } from "next/navigation"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { initials } from "@/lib/utils"
import { useFollow, useInstructor } from "../hooks"

/** Follow / Following toggle. Visitors are sent to sign in first. */
export function FollowButton({
  instructorId,
  size = "sm",
}: {
  instructorId: string
  size?: "sm" | "default"
}) {
  const t = useTranslations("catalog.instructor")
  const { user } = useAuth()
  const router = useRouter()
  const pathname = usePathname()
  const instructor = useInstructor(instructorId)
  const follow = useFollow(instructor.data)

  // Instructors don't follow themselves.
  if (user?.uid === instructorId || !instructor.data?.detailsId) return null
  const following = !!user && instructor.data.followerIds.includes(user.uid)

  return (
    <Button
      size={size}
      variant={following ? "outline" : "default"}
      disabled={follow.isPending}
      onClick={() =>
        user
          ? follow.mutate(!following)
          : router.push(`${routes.signIn}?next=${encodeURIComponent(pathname)}`)
      }
    >
      {following ? <Check /> : <Plus />}
      {following ? t("following") : t("follow")}
    </Button>
  )
}

/** The "Your instructor" card on the course page. */
export function InstructorSummary({
  instructorId,
  fallbackName,
}: {
  instructorId: string
  fallbackName: string
}) {
  const t = useTranslations("catalog.instructor")
  const instructor = useInstructor(instructorId)
  const name = instructor.data?.name || fallbackName

  if (!instructorId) return null

  return (
    <div className="rounded-3xl border border-border bg-white p-5 sm:p-6">
      <div className="flex items-center gap-4">
        <Link href={routes.instructor(instructorId)} className="shrink-0">
          <Avatar className="size-16 ring-4 ring-maroon-tint">
            <AvatarImage src={instructor.data?.photoUrl || undefined} alt="" />
            <AvatarFallback className="bg-primary text-lg font-bold text-primary-foreground">
              {initials(name || "?")}
            </AvatarFallback>
          </Avatar>
        </Link>
        <div className="min-w-0 flex-1">
          <Link
            href={routes.instructor(instructorId)}
            className="block truncate text-lg font-bold hover:text-primary"
          >
            {name}
          </Link>
          {instructor.data?.specialty && (
            <p className="truncate text-sm text-muted-foreground">{instructor.data.specialty}</p>
          )}
        </div>
        <FollowButton instructorId={instructorId} />
      </div>
      {instructor.data?.about && (
        <p className="mt-4 line-clamp-4 text-sm leading-relaxed text-muted-foreground">
          {instructor.data.about}
        </p>
      )}
      <Link
        href={routes.instructor(instructorId)}
        className="mt-3 inline-block text-sm font-semibold text-primary hover:underline"
      >
        {t("viewProfile")}
      </Link>
    </div>
  )
}
