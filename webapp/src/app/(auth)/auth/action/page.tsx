import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import Link from "next/link"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"
import { AuthHeading } from "@/features/auth/components/auth-heading"
import { ResetPasswordForm } from "@/features/auth/components/reset-password-form"

export const metadata: Metadata = { robots: { index: false } }

/**
 * Handles links in Firebase Auth emails (set as the "action URL" in the
 * Firebase console → Authentication → Templates). Today that's password reset.
 */
export default async function AuthActionPage({
  searchParams,
}: {
  searchParams: Promise<{ mode?: string; oobCode?: string }>
}) {
  const { mode, oobCode } = await searchParams
  const t = await getTranslations("auth")

  if (mode === "resetPassword" && oobCode) return <ResetPasswordForm code={oobCode} />

  return (
    <div className="text-center">
      <AuthHeading title={t("reset.expiredTitle")} subtitle={t("reset.expiredBody")} />
      <Button className="w-full" render={<Link href={routes.signIn} />}>
        {t("backToSignIn")}
      </Button>
    </div>
  )
}
