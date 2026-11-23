import type { MetadataRoute } from "next"
import { siteUrl } from "@/config/site"

/** Crawl the public site; keep crawlers out of pages that need an account. */
export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: "*",
      allow: "/",
      disallow: [
        "/home",
        "/learn",
        "/account",
        "/checkout",
        "/studio",
        "/notifications",
        "/onboarding",
        "/auth",
        "/search",
      ],
    },
    sitemap: new URL("/sitemap.xml", siteUrl).toString(),
    host: siteUrl,
  }
}
