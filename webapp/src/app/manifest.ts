import type { MetadataRoute } from "next"

/**
 * Lets phones "Add to home screen" with the academy's name, icon and colour.
 * Opens on the landing page, which works whether or not the visitor is
 * signed in.
 */
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "Nelwa's Academy",
    short_name: "Nelwa's",
    description: "Learn to make soft serve and gelato, and turn your skills into income.",
    start_url: "/",
    display: "standalone",
    background_color: "#ffffff",
    theme_color: "#5d0a0b",
    icons: [
      { src: "/icons/icon-192.png", sizes: "192x192", type: "image/png" },
      { src: "/icons/icon-512.png", sizes: "512x512", type: "image/png" },
      { src: "/icons/icon-maskable-192.png", sizes: "192x192", type: "image/png", purpose: "maskable" },
      { src: "/icons/icon-maskable-512.png", sizes: "512x512", type: "image/png", purpose: "maskable" },
    ],
  }
}
