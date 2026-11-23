import type { Metadata, Viewport } from "next"
import { NextIntlClientProvider } from "next-intl"
import { getLocale } from "next-intl/server"
import { Montserrat } from "next/font/google"
import { siteUrl } from "@/config/site"
import { Providers } from "./providers"
import "./globals.css"

// Montserrat for headlines, sub-headlines and body, per the brand guidelines.
const montserrat = Montserrat({
  variable: "--font-montserrat",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700", "800", "900"],
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
}

export const viewport: Viewport = {
  themeColor: "#5d0a0b",
}

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const locale = await getLocale()

  return (
    <html lang={locale} className={montserrat.variable}>
      <body className="grain min-h-dvh">
        <NextIntlClientProvider>
          <Providers>{children}</Providers>
        </NextIntlClientProvider>
      </body>
    </html>
  )
}
