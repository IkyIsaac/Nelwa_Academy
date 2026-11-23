import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { AccountHub } from "@/features/account/components/account-hub"
import { RequireAuth } from "@/features/auth/components/guards"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("account")
  return { title: t("title"), robots: { index: false } }
}

export default function AccountPage() {
  return (
    <RequireAuth>
      <AccountHub />
    </RequireAuth>
  )
}
