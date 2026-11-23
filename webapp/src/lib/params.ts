/** Route params can arrive URL-encoded ("Ice%20Cream"); decode them safely. */
export function decodeParam(value: string) {
  try {
    return decodeURIComponent(value)
  } catch {
    return value
  }
}
