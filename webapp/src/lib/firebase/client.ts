import { getApp, getApps, initializeApp } from "firebase/app"
import { getAuth } from "firebase/auth"
import { getFirestore } from "firebase/firestore"

/**
 * The same Firebase project the mobile app uses, so accounts, courses and
 * purchases are shared. These values are public by design (they also ship
 * inside the mobile app); access is controlled by Firestore/Storage rules.
 */
const firebaseConfig = {
  apiKey: "AIzaSyB1eRpBBatM6yDOuGUC0ptSARa_5ufHDQ4",
  authDomain: "nelwasacademy-7uw9xf.firebaseapp.com",
  projectId: "nelwasacademy-7uw9xf",
  storageBucket: "nelwasacademy-7uw9xf.firebasestorage.app",
  messagingSenderId: "91236738139",
  appId: "1:91236738139:web:5540a75442015e64a88b7e",
}

// Reuse the app on hot reload instead of initialising it twice.
export const app = getApps().length ? getApp() : initializeApp(firebaseConfig)

export const auth = getAuth(app)
export const db = getFirestore(app)
// Storage and Cloud Functions are in ./storage and ./functions, so pages
// that don't upload files or pay don't download those SDKs.
