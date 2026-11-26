import type { Metadata, Viewport } from "next"
import { NextIntlClientProvider } from "next-intl"
import { getLocale, getTranslations } from "next-intl/server"
import localFont from "next/font/local"
import { siteUrl } from "@/config/site"
import { Providers } from "./providers"
import "./globals.css"

// Montserrat for headlines, sub-headlines and body, per the brand guidelines.
// Self-hosted (variable font, Latin subset, from @fontsource-variable/montserrat
// 5.3.0, OFL licence in ./fonts) rather than next/font/google: Turbopack's
// Google-font loader fails on Netlify's build machines ("next/font/google
// queries have exactly one entry"), and this also keeps builds offline-safe.
const montserrat = localFont({
  variable: "--font-montserrat",
  src: "./fonts/montserrat-latin-wght.woff2",
  weight: "100 900",
  style: "normal",
  display: "swap",
})

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: {
    default: "Nelwa's Academy — Africa's Ice Cream School",
    template: "%s · Nelwa's Academy",
  },
  description:
    "Learn how to make soft serve and gelato, and turn your skills into real income. Taught by Tanzania's most celebrated ice cream entrepreneur.",
  openGraph: { siteName: "Nelwa's Academy", type: "website" },
  // Name and status bar when added to an iPhone's home screen.
  appleWebApp: { capable: true, title: "Nelwa's", statusBarStyle: "default" },
}

export const viewport: Viewport = {
  themeColor: "#5d0a0b",
}

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const locale = await getLocale()
  const t = await getTranslations("nav")

  return (
    <html lang={locale} className={montserrat.variable}>
      <body className="grain min-h-dvh">
        {/* First Tab stop: lets keyboard and screen-reader users jump past the header. */}
        <a
          href="#main"
          className="sr-only z-100 rounded-full bg-primary px-5 py-3 text-sm font-semibold text-primary-foreground focus:not-sr-only focus:fixed focus:top-3 focus:left-3"
        >
          {t("skipToContent")}
        </a>
        <NextIntlClientProvider>
          <Providers>{children}</Providers>
        </NextIntlClientProvider>
      </body>
    </html>
  )
}
