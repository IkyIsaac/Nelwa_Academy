import { DocumentReference, Timestamp } from "firebase/firestore"

/**
 * Small helpers for reading Firestore documents written by the FlutterFlow
 * app. Fields can be missing on older documents, so every helper returns a
 * safe default instead of `undefined`, the same way the Flutter models do.
 */

export const str = (value: unknown): string => (typeof value === "string" ? value : "")

export const num = (value: unknown): number => (typeof value === "number" ? value : 0)

export const bool = (value: unknown): boolean => value === true

export const strList = (value: unknown): string[] =>
  Array.isArray(value) ? value.filter((v): v is string => typeof v === "string") : []

export const date = (value: unknown): Date | null => (value instanceof Timestamp ? value.toDate() : null)

export const ref = (value: unknown): DocumentReference | null =>
  value instanceof DocumentReference ? value : null

export const refList = (value: unknown): DocumentReference[] =>
  Array.isArray(value) ? value.filter((v): v is DocumentReference => v instanceof DocumentReference) : []

/** The document id a reference points at, or "" when there is no reference. */
export const refId = (value: unknown): string => ref(value)?.id ?? ""
