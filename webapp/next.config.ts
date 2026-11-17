import type { NextConfig } from "next"
import createNextIntlPlugin from "next-intl/plugin"

const withNextIntl = createNextIntlPlugin("./src/i18n/request.ts")

const nextConfig: NextConfig = {
  experimental: {
    // Lets course cards morph into the course page header (React <ViewTransition>).
    viewTransition: true,
  },
  images: {
    remotePatterns: [
      { protocol: "https", hostname: "firebasestorage.googleapis.com" },
      { protocol: "https", hostname: "storage.googleapis.com" },
      { protocol: "https", hostname: "lh3.googleusercontent.com" }, // Google profile photos
      { protocol: "https", hostname: "iili.io" }, // landing page images
    ],
  },
}

export default withNextIntl(nextConfig)
