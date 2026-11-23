import { Compass } from "lucide-react"
import type { Metadata } from "next"
import Link from "next/link"
import { getTranslations } from "next-intl/server"
import { EmptyState } from "@/components/empty-state"
import { MobileTabBar } from "@/components/layout/mobile-tab-bar"
import { SiteFooter } from "@/components/layout/site-footer"
import { SiteHeader } from "@/components/layout/site-header"
import { Button } from "@/components/ui/button"
import { routes } from "@/config/site"

export const metadata: Metadata = { title: "404", robots: { index: false } }

/**
 * 404 for unknown URLs and for pages that call notFound() (a missing course,
 * a switched-off feature). Keeps the normal header and footer so visitors can
 * carry on browsing.
 */
export default async function NotFound() {
  const t = await getTranslations("errors")
  return (
    <>
      <SiteHeader />
      <main id="main" className="mx-auto flex min-h-[70dvh] max-w-2xl items-center px-4 py-16">
        <EmptyState
          className="w-full"
          icon={Compass}
          title={t("notFoundTitle")}
          body={t("notFoundBody")}
          action={
            <div className="flex flex-wrap justify-center gap-3">
              <Button render={<Link href={routes.explore} />}>{t("browseCourses")}</Button>
              <Button variant="outline" render={<Link href={routes.landing} />}>
                {t("goHome")}
              </Button>
            </div>
          }
        />
      </main>
      <SiteFooter />
      <MobileTabBar />
    </>
  )
}
