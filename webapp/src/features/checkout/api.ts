import { collection, doc, getDocs, limit, onSnapshot, query, where } from "firebase/firestore"
import { httpsCallable } from "firebase/functions"
import { db, functions } from "@/lib/firebase/client"
import { type CheckoutError, type Order, toOrder } from "./types"

type CreateOrderResult = { orderId: string; checkoutUrl: string }

/**
 * Starts a Snippe checkout for one course. The price is read on the server
 * from the course, never sent from here. `returnOrigin` lets Snippe send
 * the buyer back to this site's order page once they've paid.
 */
export async function startCheckout(courseId: string): Promise<CreateOrderResult> {
  const createOrder = httpsCallable<{ courseIds: string[]; returnOrigin: string }, CreateOrderResult>(
    functions,
    "createOrder",
  )
  const { data } = await createOrder({ courseIds: [courseId], returnOrigin: window.location.origin })
  return data
}

/** Maps a `createOrder` failure to something we can explain to the learner. */
export function checkoutError(error: unknown): CheckoutError {
  const code = (error as { code?: string })?.code ?? ""
  if (code.endsWith("already-exists")) return "owned"
  if (code.endsWith("failed-precondition") || code.endsWith("not-found")) return "notForSale"
  if (code.endsWith("unauthenticated")) return "signedOut"
  return "unavailable"
}

/** Live updates for one order, so the page reacts the moment Snippe confirms. */
export function watchOrder(
  orderId: string,
  onChange: (order: Order | null) => void,
  onError: (error: Error) => void,
) {
  return onSnapshot(
    doc(db, "orders", orderId),
    (snap) => onChange(snap.exists() ? toOrder(snap.id, snap.data()) : null),
    onError,
  )
}

/**
 * Whether the learner already has this course. Checks their purchases
 * directly, because people who bought before Snippe aren't always listed
 * on the course's `downloaders`.
 */
export async function hasPurchased(uid: string, courseId: string) {
  const snap = await getDocs(
    query(
      collection(db, "users", uid, "purchased_courses"),
      where("courses_ref", "==", doc(db, "courses", courseId)),
      limit(1),
    ),
  )
  return !snap.empty
}
