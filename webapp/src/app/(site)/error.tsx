"use client"

import { TriangleAlert } from "lucide-react"
import Link from "next/link"
import { useTranslations } from "next-intl"
import { useEffect } from "react"
import { EmptyState } from "@/components/empty-state"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"

/**
 * Shown in place of a page that crashed, inside the normal header and footer.
 * "Try again" re-renders just this page; the rest of the site keeps working.
 */
export default function SiteError({
  error,
  unstable_retry,
}: {
  error: Error & { digest?: string }
  unstable_retry: () => void
}) {
  const t = useTranslations("errors")

  useEffect(() => {
    console.error(error)
  }, [error])

  return (
    <div className="mx-auto flex min-h-[70dvh] max-w-2xl items-center px-4 py-16">
      <EmptyState
        className="w-full"
        icon={TriangleAlert}
        title={t("crashTitle")}
        body={t("crashBody")}
        action={
          <div className="flex flex-wrap justify-center gap-3">
            <Button onClick={() => unstable_retry()}>{t("retry")}</Button>
            <Button variant="outline" render={<Link href={routes.landing} />}>
              {t("goHome")}
            </Button>
          </div>
        }
      />
      {error.digest && <p className="sr-only">Error {error.digest}</p>}
    </div>
  )
}
