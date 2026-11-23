import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { RequireAuth } from "@/features/auth/components/guards"
import { AccountPage } from "@/features/account/components/account-page"
import { LanguageView } from "@/features/account/components/language-view"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("account.language")
  return { title: t("title"), robots: { index: false } }
}

export default async function Page() {
  const t = await getTranslations("account.language")
  return (
    <RequireAuth>
      <AccountPage title={t("title")} description={t("description")}>
        <LanguageView />
      </AccountPage>
    </RequireAuth>
  )
}
