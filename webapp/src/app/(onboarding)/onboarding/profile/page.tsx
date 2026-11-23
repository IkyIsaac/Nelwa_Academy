import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { Suspense } from "react"
import { ProfileForm } from "@/features/onboarding/components/profile-form"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("onboarding.profile")
  return { title: t("title") }
}

export default async function CompleteProfilePage() {
  const t = await getTranslations("onboarding.profile")
  return (
    <>
      <div className="mb-8 text-center">
        <h1 className="text-[1.75rem] leading-tight font-extrabold">{t("title")}</h1>
        <p className="mt-2 text-muted-foreground">{t("subtitle")}</p>
      </div>
      <Suspense>
        <ProfileForm />
      </Suspense>
    </>
  )
}
