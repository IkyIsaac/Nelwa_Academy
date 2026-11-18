"use client"

import { BookOpen, Heart, LogOut, Presentation, Receipt, User } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { routes } from "@/config/site"
import { signOut } from "@/features/auth/api"
import { useAuth } from "@/features/auth/components/auth-provider"
import { initials } from "@/lib/utils"

/** Avatar button with shortcuts to the learner's account pages. */
export function UserMenu() {
  const t = useTranslations("nav")
  const { user, profile } = useAuth()
  const router = useRouter()
  const name = profile?.displayName || user?.displayName || user?.email || ""
  const photo = profile?.photoUrl || user?.photoURL || undefined

  const logout = async () => {
    await signOut()
    router.replace(routes.signIn)
  }

  return (
    <DropdownMenu>
      <DropdownMenuTrigger
        aria-label={t("profile")}
        className="cursor-pointer rounded-full ring-offset-2 transition hover:ring-2 hover:ring-primary/30 focus-visible:ring-2 focus-visible:ring-primary/50"
      >
        <Avatar size="lg">
          <AvatarImage src={photo} alt="" />
          <AvatarFallback className="bg-primary font-semibold text-white">{initials(name)}</AvatarFallback>
        </Avatar>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-60">
        <div className="px-2 py-2">
          <p className="truncate text-sm font-semibold">{name}</p>
          <p className="truncate text-xs text-muted-foreground">{user?.email}</p>
        </div>
        <DropdownMenuSeparator />
        <DropdownMenuItem render={<Link href={routes.account} />}>
          <User /> {t("profile")}
        </DropdownMenuItem>
        {profile?.instructor && (
          <DropdownMenuItem render={<Link href={routes.studio} />}>
            <Presentation /> {t("studio")}
          </DropdownMenuItem>
        )}
        <DropdownMenuItem render={<Link href={routes.learn} />}>
          <BookOpen /> {t("myLearning")}
        </DropdownMenuItem>
        <DropdownMenuItem render={<Link href={routes.wishlist} />}>
          <Heart /> {t("wishlist")}
        </DropdownMenuItem>
        <DropdownMenuItem render={<Link href={routes.purchases} />}>
          <Receipt /> {t("purchases")}
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem variant="destructive" onClick={logout}>
          <LogOut /> {t("logout")}
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
