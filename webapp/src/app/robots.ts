import type { MetadataRoute } from "next"
import { productionUrl, siteUrl } from "@/config/site"

/**
 * Crawl the public site; keep crawlers out of pages that need an account.
 * Preview deploys (any other address) are closed to crawlers entirely.
 */
export default function robots(): MetadataRoute.Robots {
  if (new URL(siteUrl).origin !== productionUrl) {
    return { rules: { userAgent: "*", disallow: "/" } }
  }
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
