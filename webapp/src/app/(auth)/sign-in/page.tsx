import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { Suspense } from "react"
import { GuestOnly } from "@/features/auth/components/guards"
import { SignInForm } from "@/features/auth/components/sign-in-form"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("auth.signIn")
  return { title: t("title") }
}

export default function SignInPage() {
  return (
    <Suspense>
      <GuestOnly>
        <SignInForm />
      </GuestOnly>
    </Suspense>
  )
}
