import type { NextConfig } from "next"
import createNextIntlPlugin from "next-intl/plugin"

const withNextIntl = createNextIntlPlugin("./src/i18n/request.ts")

/**
 * Security headers on every response. No full Content-Security-Policy yet:
 * Firebase Auth (Google sign-in iframe), Storage video and the Snippe
 * checkout redirect would each need allow-listing and testing first.
 */
const securityHeaders = [
  // Only this site may put its pages in a frame (stops clickjacking).
  { key: "Content-Security-Policy", value: "frame-ancestors 'self'" },
  { key: "X-Frame-Options", value: "SAMEORIGIN" },
  { key: "X-Content-Type-Options", value: "nosniff" },
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  // The site never uses these; file pickers don't need the camera permission.
  { key: "Permissions-Policy", value: "camera=(), microphone=(), geolocation=(), browsing-topics=()" },
  // Browsers remember to use HTTPS for two years (no subdomains: other
  // nelwasacademy.com hosts are managed elsewhere).
  { key: "Strict-Transport-Security", value: "max-age=63072000" },
]

const nextConfig: NextConfig = {
  poweredByHeader: false,
  async headers() {
    return [{ source: "/:path*", headers: securityHeaders }]
  },
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
