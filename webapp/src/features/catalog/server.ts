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

type RestTimestamp = { timestampValue?: string }

/**
 * Every published course (id, category, last change) for the sitemap.
 * Same public REST API and same rule as above: the query must filter on
 * `is_published == true`, or Firestore refuses it for a signed-out reader.
 */
export async function listPublishedCourses() {
  try {
    const res = await fetch(`${BASE}:runQuery`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        structuredQuery: {
          from: [{ collectionId: "courses" }],
          where: {
            fieldFilter: { field: { fieldPath: "is_published" }, op: "EQUAL", value: { booleanValue: true } },
          },
          select: { fields: [{ fieldPath: "category" }, { fieldPath: "published_date" }] },
        },
      }),
      next: { revalidate: 3600 },
    })
    if (!res.ok) return []
    const rows = (await res.json()) as {
      document?: {
        name: string
        updateTime?: string
        fields?: { category?: RestValue; published_date?: RestTimestamp }
      }
    }[]
    return rows.flatMap((row) => {
      if (!row.document) return []
      const when = row.document.updateTime ?? row.document.fields?.published_date?.timestampValue
      return [
        {
          id: row.document.name.split("/").pop() ?? "",
          category: row.document.fields?.category?.stringValue ?? "",
          updatedAt: when ? new Date(when) : undefined,
        },
      ]
    })
  } catch {
    return []
  }
}
