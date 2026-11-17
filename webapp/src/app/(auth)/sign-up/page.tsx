import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { Suspense } from "react"
import { GuestOnly } from "@/features/auth/components/guards"
import { SignUpForm } from "@/features/auth/components/sign-up-form"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("auth.signUp")
  return { title: t("title") }
}

export default function SignUpPage() {
  return (
    <Suspense>
      <GuestOnly>
        <SignUpForm />
      </GuestOnly>
    </Suspense>
  )
}
