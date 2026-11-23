/** Display helpers for prices and durations. */

/** "TSh 50,000" — the mobile app shows prices in Tanzanian shillings. */
export function formatPrice(amount: number) {
  return `TSh ${Math.round(amount).toLocaleString("en-US")}`
}

/**
 * Course length from seconds (`total_duration`, like lesson `duration`, is
 * stored in seconds): "45 min", "3 h", "3 h 20 min".
 */
export function formatCourseLength(seconds: number) {
  const minutes = Math.round(seconds / 60)
  if (minutes <= 0) return ""
  const h = Math.floor(minutes / 60)
  const m = minutes % 60
  if (!h) return `${m} min`
  return m ? `${h} h ${m} min` : `${h} h`
}

/** Lesson length from seconds: "4:05", "1:02:09". */
export function formatSeconds(seconds: number) {
  if (seconds <= 0) return ""
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  const pad = (n: number) => String(n).padStart(2, "0")
  return h ? `${h}:${pad(m)}:${pad(s)}` : `${m}:${pad(s)}`
}

/** "4.5" — one decimal, as on mobile. */
export const formatRating = (rating: number) => (Math.round(rating * 10) / 10).toFixed(1)
