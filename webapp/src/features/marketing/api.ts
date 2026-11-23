import { addDoc, collection, serverTimestamp } from "firebase/firestore"
import { auth, db } from "@/lib/firebase/client"

export type ContactMessage = { name: string; email: string; topic: string; message: string }

/**
 * Stores a website contact-form message. The `emailOnContactMessage` Cloud
 * Function forwards it to the academy inbox, with reply-to set to the sender.
 */
export function sendContactMessage(message: ContactMessage) {
  return addDoc(collection(db, "contact_messages"), {
    name: message.name.trim(),
    email: message.email.trim(),
    topic: message.topic,
    message: message.message.trim(),
    uid: auth.currentUser?.uid ?? null,
    createdAt: serverTimestamp(),
  })
}
