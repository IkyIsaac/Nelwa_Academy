import { MobileTabBar } from "@/components/layout/mobile-tab-bar"
import { SiteFooter } from "@/components/layout/site-footer"
import { SiteHeader } from "@/components/layout/site-header"

/** Header, footer and (on phones) the bottom tab bar around every normal page. */
export default function SiteLayout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <SiteHeader />
      <main id="main" className="min-h-dvh">
        {children}
      </main>
      <SiteFooter />
      <MobileTabBar />
    </>
  )
}
