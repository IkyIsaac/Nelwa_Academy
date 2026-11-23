import type { MetadataRoute } from "next"
import { routes, siteUrl } from "@/config/site"
import { listPublishedCourses } from "@/features/catalog/server"

/**
 * Public pages only: the landing and info pages, the catalog and every
 * published course with its reviews. Pages behind sign-in (learning,
 * account, checkout, studio) are left out and blocked in robots.ts.
 * Rebuilt at most once an hour.
 */
export const revalidate = 3600

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const url = (path: string) => new URL(path, siteUrl).toString()
  const courses = await listPublishedCourses()

  const staticPages: MetadataRoute.Sitemap = [
    { url: url(routes.landing), changeFrequency: "weekly", priority: 1 },
    { url: url(routes.explore), changeFrequency: "daily", priority: 0.9 },
    { url: url(routes.categories), changeFrequency: "weekly", priority: 0.7 },
    { url: url("/about"), changeFrequency: "monthly", priority: 0.6 },
    { url: url("/consult"), changeFrequency: "monthly", priority: 0.6 },
    { url: url("/contact"), changeFrequency: "yearly", priority: 0.5 },
    { url: url("/help"), changeFrequency: "monthly", priority: 0.4 },
    { url: url("/terms"), changeFrequency: "yearly", priority: 0.2 },
    { url: url("/privacy"), changeFrequency: "yearly", priority: 0.2 },
  ]

  const categories = [...new Set(courses.map((c) => c.category).filter(Boolean))].map(
    (name): MetadataRoute.Sitemap[number] => ({
      url: url(routes.category(name)),
      changeFrequency: "weekly",
      priority: 0.6,
    }),
  )

  const coursePages = courses.flatMap((c): MetadataRoute.Sitemap => [
    { url: url(routes.course(c.id)), lastModified: c.updatedAt, changeFrequency: "weekly", priority: 0.8 },
    { url: url(routes.courseReviews(c.id)), changeFrequency: "weekly", priority: 0.4 },
  ])

  return [...staticPages, ...categories, ...coursePages]
}
