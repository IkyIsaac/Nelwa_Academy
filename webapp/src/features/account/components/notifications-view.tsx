"use client"

import { Bell, CheckCheck, MessageSquareText, UserPlus } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import { EmptyState } from "@/components/empty-state"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { LoadError } from "@/features/catalog/components/discover-views"
import { cn, initials } from "@/lib/utils"
import { useMarkSeen, useNotifications } from "../hooks"
import type { AppNotification } from "../types"

const isToday = (d: Date) => d.toDateString() === new Date().toDateString()

export function NotificationsView() {
  const t = useTranslations("account.notifications")
  const live = useNotifications()
  const markSeen = useMarkSeen()

  if (live.status === "error") return <LoadError onRetry={() => window.location.reload()} />
  if (live.status === "loading") {
    return (
      <div className="space-y-3">
        {Array.from({ length: 4 }, (_, i) => (
          <Skeleton key={i} className="h-20 rounded-2xl" />
        ))}
      </div>
    )
  }
  const list = live.data
  if (!list.length) return <EmptyState icon={Bell} title={t("emptyTitle")} body={t("emptyBody")} />

  const unread = list.filter((n) => !n.seen).map((n) => n.id)
  const groups = [
    { title: t("today"), items: list.filter((n) => n.at && isToday(n.at)) },
    { title: t("earlier"), items: list.filter((n) => !n.at || !isToday(n.at)) },
  ].filter((g) => g.items.length)

  return (
    <div className="space-y-8">
      {unread.length > 0 && (
        <div className="flex justify-end">
          <Button
            variant="outline"
            size="sm"
            onClick={() => markSeen.mutate(unread)}
            disabled={markSeen.isPending}
          >
            <CheckCheck />
            {t("markAll")}
          </Button>
        </div>
      )}
      {groups.map((group) => (
        <section key={group.title}>
          <h2 className="mb-3 text-xs font-bold tracking-[0.15em] text-gold uppercase">{group.title}</h2>
          <ul className="space-y-2">
            <AnimatePresence initial={false}>
              {group.items.map((n) => (
                <motion.li key={n.id} layout initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}>
                  <NotificationRow n={n} onOpen={() => !n.seen && markSeen.mutate([n.id])} />
                </motion.li>
              ))}
            </AnimatePresence>
          </ul>
        </section>
      ))}
    </div>
  )
}

function NotificationRow({ n, onOpen }: { n: AppNotification; onOpen: () => void }) {
  const t = useTranslations("account.notifications")
  const locale = useLocale()
  const Icon = n.type === "subscribed" ? UserPlus : n.type === "comment" ? MessageSquareText : Bell
  const headline =
    n.type === "subscribed"
      ? t("followed", { name: n.title })
      : n.type === "comment"
        ? t("reviewed", { name: n.title, course: n.courseTitle })
        : n.title
  const time = n.at
    ? new Intl.DateTimeFormat(
        locale,
        isToday(n.at) ? { timeStyle: "short" } : { dateStyle: "medium" },
      ).format(n.at)
    : ""

  return (
    <button
      type="button"
      onClick={onOpen}
      className={cn(
        "flex w-full items-start gap-4 rounded-2xl border px-4 py-3.5 text-left transition-colors",
        n.seen ? "border-border bg-white" : "border-primary/20 bg-maroon-tint",
      )}
    >
      <span className="relative">
        <Avatar className="size-11">
          <AvatarImage src={n.image || undefined} alt="" />
          <AvatarFallback className="bg-primary text-sm font-bold text-white">
            {initials(n.title) || "N"}
          </AvatarFallback>
        </Avatar>
        <span className="absolute -right-1 -bottom-1 grid size-5 place-items-center rounded-full bg-white text-primary shadow">
          <Icon className="size-3" />
        </span>
      </span>
      <span className="min-w-0 flex-1">
        <span className="block text-sm font-semibold">{headline}</span>
        {n.type !== "subscribed" && n.description && (
          <span className="mt-0.5 line-clamp-2 block text-sm text-muted-foreground">{n.description}</span>
        )}
        <span className="mt-1 block text-xs text-muted-foreground">{time}</span>
      </span>
      {!n.seen && (
        <span className="mt-2 size-2.5 shrink-0 rounded-full bg-primary" aria-label={t("unread")} />
      )}
    </button>
  )
}
