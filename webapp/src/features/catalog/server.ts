import "server-only"

/**
 * Server-side reads for page metadata (titles and share previews), using the
 * public Firestore REST API. Only published courses are readable without
 * signing in, so drafts never leak into link previews. Any failure just
 * falls back to the default site metadata.
 */

const BASE = "https://firestore.googleapis.com/v1/projects/nelwasacademy-7uw9xf/databases/(default)/documents"

type RestValue = { stringValue?: string }

export async function getCourseMeta(id: string, locale: string) {
  try {
    const res = await fetch(`${BASE}/courses/${encodeURIComponent(id)}`, { next: { revalidate: 300 } })
    if (!res.ok) return null
    const { fields = {} } = (await res.json()) as { fields?: Record<string, RestValue> }
    const text = (key: string) => fields[key]?.stringValue ?? ""
    const sw = locale === "sw"
    return {
      title: (sw && text("title_sw")) || text("title"),
      description: ((sw && text("description_sw")) || text("description")).slice(0, 180),
      image: text("image"),
    }
  } catch {
    return null
  }
}
