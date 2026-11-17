"use client"

import { Users } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { EmptyState } from "@/components/empty-state"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { LoadError } from "@/features/catalog/components/discover-views"
import { initials } from "@/lib/utils"
import { useFollowedInstructors } from "../hooks"

/** Instructors the learner follows (mobile "Subscriptions"). */
export function FollowingView() {
  const t = useTranslations("account.following")
  const instructors = useFollowedInstructors()

  if (instructors.isError) return <LoadError onRetry={() => instructors.refetch()} />
  if (instructors.isPending) return <Skeleton className="h-40 rounded-3xl" />
  if (!instructors.data.length) {
    return (
      <EmptyState
        icon={Users}
        title={t("emptyTitle")}
        body={t("emptyBody")}
        action={<Button render={<Link href={routes.explore} />}>{t("browse")}</Button>}
      />
    )
  }
  return (
    <ul className="grid gap-3 sm:grid-cols-2">
      {instructors.data.map((i) => (
        <li key={i.id}>
          <Link
            href={routes.instructor(i.id)}
            className="flex items-center gap-4 rounded-3xl border border-border bg-white p-4 transition-all hover:border-primary/20 hover:shadow-soft"
          >
            <Avatar className="size-14">
              <AvatarImage src={i.photoUrl || undefined} alt="" />
              <AvatarFallback className="bg-primary font-bold text-white">{initials(i.name)}</AvatarFallback>
            </Avatar>
            <div className="min-w-0">
              <p className="truncate font-bold">{i.name}</p>
              {i.specialty && <p className="truncate text-sm text-muted-foreground">{i.specialty}</p>}
            </div>
          </Link>
        </li>
      ))}
    </ul>
  )
}
