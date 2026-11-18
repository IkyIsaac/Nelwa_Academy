"use client"

import { Users } from "lucide-react"
import { useTranslations } from "next-intl"
import { EmptyState } from "@/components/empty-state"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Skeleton } from "@/components/ui/skeleton"
import { useFollowers } from "../hooks"
import { StudioSection } from "./studio-shell"

export function FollowersView() {
  const t = useTranslations("studio.followers")
  const followers = useFollowers()

  if (followers.isPending) return <Skeleton className="h-48 rounded-3xl" />
  const list = followers.data ?? []
  if (list.length === 0) return <EmptyState icon={Users} title={t("emptyTitle")} body={t("emptyBody")} />

  return (
    <StudioSection title={t("title", { count: list.length })}>
      <ul className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
        {list.map((f) => (
          <li key={f.id} className="flex items-center gap-3 rounded-2xl border border-border bg-white p-4">
            <Avatar className="size-12">
              <AvatarImage src={f.photoUrl || undefined} alt="" />
              <AvatarFallback>{(f.name || "?").slice(0, 1).toUpperCase()}</AvatarFallback>
            </Avatar>
            <span className="min-w-0">
              <span className="block truncate font-semibold">{f.name || t("learner")}</span>
              {f.specialty && (
                <span className="block truncate text-xs text-muted-foreground">{f.specialty}</span>
              )}
            </span>
          </li>
        ))}
      </ul>
    </StudioSection>
  )
}
