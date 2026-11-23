import { getFunctions } from "firebase/functions"
import { app } from "./client"

/** Cloud Functions (us-central1), used by checkout. Kept apart so other pages stay light. */
export const functions = getFunctions(app)
