// Firestore rules tests: mobile + web flows that must keep working, and leaks that must be closed.
import { assertFails, assertSucceeds, initializeTestEnvironment } from "@firebase/rules-unit-testing"
import {
  addDoc, arrayUnion, collection, collectionGroup, doc, getDoc, getDocs, increment, query,
  serverTimestamp, setDoc, updateDoc, deleteDoc, where,
} from "firebase/firestore"
import { readFileSync } from "node:fs"
import { after, before, beforeEach, test } from "node:test"

// Must match isAdmin() in firestore.rules.
const ADMIN_EMAIL = process.env.ADMIN_EMAIL ?? "isaackitomari33@gmail.com"
let env

before(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-nelwa",
    firestore: { rules: readFileSync(new URL("../firestore.rules", import.meta.url), "utf8"), host: "127.0.0.1", port: 8181 },
  })
})
after(() => env.cleanup())

const userRef = (db, uid) => doc(db, "users", uid)

beforeEach(async () => {
  await env.clearFirestore()
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore()
    await setDoc(userRef(db, "teacher"), { display_name: "Mercy", email: "t@x.com", phone_number: "1", instructor: true, role: "Instructor" })
    await setDoc(userRef(db, "legacyTeacher"), { display_name: "Old", role: "Instructor" })
    await setDoc(userRef(db, "alice"), { display_name: "Alice", email: "a@x.com", phone_number: "2", subscriptions: [userRef(db, "teacher")] })
    await setDoc(userRef(db, "bob"), { display_name: "Bob", email: "b@x.com", phone_number: "3" })
    await setDoc(doc(db, "courses", "c1"), { title: "Gelato", is_published: true, instructor_ref: userRef(db, "teacher"), rating: 4, reviews_count: 2, downloaders: [userRef(db, "alice")] })
    await setDoc(doc(db, "courses", "draft"), { title: "Draft", is_published: false, instructor_ref: userRef(db, "teacher") })
    await setDoc(doc(db, "courses", "c1", "lessons", "l1"), { title: "L1", video_url: "https://v" })
    await setDoc(doc(db, "courses", "c1", "courses_review", "r1"), { comment: "great", rating: 5, liked: [], disliked: [] })
    await setDoc(doc(db, "users", "teacher", "instructor_details", "d1"), { followers: [], lessons: 1 })
    await setDoc(doc(db, "users", "teacher", "payment_account", "p1"), { account: "123456789", balance: 0 })
    await setDoc(doc(db, "users", "alice", "payment_method", "m1"), { card_number: "4111", cvc: "123" })
    await setDoc(doc(db, "users", "alice", "purchase_history", "h1"), { amount: 1 })
    await setDoc(doc(db, "users", "alice", "purchased_courses", "pc1"), { courses_ref: doc(db, "courses", "c1"), reviwed: false })
    await setDoc(doc(db, "users", "alice", "notification", "n1"), { seen: false })
    await setDoc(doc(db, "options", "o1"), { tags: ["a"], categories: [], trending_now: [] })
    await setDoc(doc(db, "ads", "ad1"), { image_url: "x" })
    await setDoc(doc(db, "consultation", "k1"), { uid: "bob", email: "b@x.com", phone_number: "3" })
    await setDoc(doc(db, "support", "s1"), { user: userRef(db, "alice") })
    await setDoc(doc(db, "support", "s1", "support_message", "sm1"), { message: "hi" })
  })
})

const as = (uid, email) => env.authenticatedContext(uid, email ? { email } : {}).firestore()
const anon = () => env.unauthenticatedContext().firestore()

// ---------- public catalog (web visitors) ----------
test("visitor lists published courses, not drafts", async () => {
  await assertSucceeds(getDocs(query(collection(anon(), "courses"), where("is_published", "==", true))))
  await assertFails(getDocs(collection(anon(), "courses")))
  await assertSucceeds(getDoc(doc(anon(), "courses", "c1")))
  await assertFails(getDoc(doc(anon(), "courses", "draft")))
})
test("visitor reads reviews, options, instructor stats; not lessons, users or ads", async () => {
  await assertSucceeds(getDocs(collection(anon(), "courses", "c1", "courses_review")))
  await assertSucceeds(getDocs(collection(anon(), "options")))
  await assertSucceeds(getDocs(collection(anon(), "users", "teacher", "instructor_details")))
  await assertFails(getDocs(collection(anon(), "courses", "c1", "lessons")))
  await assertFails(getDoc(doc(anon(), "users", "teacher")))
  await assertFails(getDocs(collection(anon(), "ads")))
})

// ---------- users privacy ----------
test("learner can't read another learner's profile", async () => {
  await assertFails(getDoc(userRef(as("bob"), "alice")))
  await assertSucceeds(getDoc(userRef(as("alice"), "alice")))
})
test("signed-in users read instructor profiles (incl. legacy role-only)", async () => {
  await assertSucceeds(getDoc(userRef(as("bob"), "teacher")))
  await assertSucceeds(getDoc(userRef(as("bob"), "legacyTeacher")))
})
test("instructor reads a follower's profile (Followers list)", async () => {
  await assertSucceeds(getDoc(userRef(as("teacher"), "alice")))
  await assertFails(getDoc(userRef(as("teacher"), "bob")))
})
test("admin lists all users", async () => {
  await assertSucceeds(getDocs(collection(as("admin", ADMIN_EMAIL), "users")))
  await assertFails(getDocs(collection(as("bob"), "users")))
})

// ---------- courses ----------
test("learner can't edit a course price", async () => {
  await assertFails(updateDoc(doc(as("bob"), "courses", "c1"), { price: 1 }))
  await assertFails(deleteDoc(doc(as("bob"), "courses", "c1")))
})
test("owner instructor and admin edit/delete a course", async () => {
  await assertSucceeds(updateDoc(doc(as("teacher"), "courses", "c1"), { price: 5, total_lessons: increment(1) }))
  await assertSucceeds(updateDoc(doc(as("admin", ADMIN_EMAIL), "courses", "c1"), { is_published: false }))
  await assertSucceeds(deleteDoc(doc(as("teacher"), "courses", "draft")))
})
test("other instructor can't edit someone else's course or steal it", async () => {
  await assertFails(updateDoc(doc(as("legacyTeacher"), "courses", "c1"), { price: 0 }))
})
test("instructor creates own course; learner can't", async () => {
  const t = as("teacher")
  await assertSucceeds(setDoc(doc(t, "courses", "new"), { title: "N", instructor_ref: userRef(t, "teacher"), is_published: true }))
  const b = as("bob")
  await assertFails(setDoc(doc(b, "courses", "new2"), { title: "N", instructor_ref: userRef(b, "bob") }))
})
test("learner records preview view and adds review rating", async () => {
  const b = as("bob")
  await assertSucceeds(updateDoc(doc(b, "courses", "c1"), { preview_views: arrayUnion(userRef(b, "bob")) }))
  await assertSucceeds(updateDoc(doc(b, "courses", "c1"), { rating: 4.5, reviews_count: increment(1) }))
  await assertFails(updateDoc(doc(b, "courses", "c1"), { rating: 5, reviews_count: 99 }))
})
test("lessons: owner/admin write, learner can't", async () => {
  await assertSucceeds(setDoc(doc(as("teacher"), "courses", "c1", "lessons", "l2"), { title: "L2" }))
  await assertFails(setDoc(doc(as("bob"), "courses", "c1", "lessons", "l3"), { title: "x" }))
  await assertFails(updateDoc(doc(as("bob"), "courses", "c1", "lessons", "l1"), { video_url: "evil" }))
  await assertSucceeds(getDoc(doc(as("bob"), "courses", "c1", "lessons", "l1")))
})

// ---------- reviews ----------
test("write review, vote on reviews, can't rewrite others' reviews", async () => {
  const b = as("bob")
  await assertSucceeds(addDoc(collection(b, "courses", "c1", "courses_review"), { comment: "ok", rating: 4 }))
  await assertSucceeds(updateDoc(doc(b, "courses", "c1", "courses_review", "r1"), { liked: arrayUnion(userRef(b, "bob")) }))
  await assertFails(updateDoc(doc(b, "courses", "c1", "courses_review", "r1"), { comment: "edited" }))
})

// ---------- instructor details / follow ----------
test("follow writes followers + own subscriptions only", async () => {
  const b = as("bob")
  await assertSucceeds(updateDoc(doc(b, "users", "teacher", "instructor_details", "d1"), { followers: arrayUnion(userRef(b, "bob")) }))
  await assertSucceeds(updateDoc(userRef(b, "bob"), { subscriptions: arrayUnion(userRef(b, "teacher")) }))
  await assertFails(updateDoc(doc(b, "users", "teacher", "instructor_details", "d1"), { lessons: 99 }))
  await assertSucceeds(updateDoc(doc(as("teacher"), "users", "teacher", "instructor_details", "d1"), { lessons: increment(1) }))
})
test("instructor onboarding creates own details", async () => {
  await assertSucceeds(setDoc(doc(as("bob"), "users", "bob", "instructor_details", "x"), { specialty: "gelato" }))
  await assertFails(setDoc(doc(as("bob"), "users", "alice", "instructor_details", "x"), { specialty: "gelato" }))
})

// ---------- money / private subcollections ----------
test("payment accounts and cards are private", async () => {
  await assertFails(getDocs(collection(as("bob"), "users", "teacher", "payment_account")))
  await assertSucceeds(getDocs(collection(as("teacher"), "users", "teacher", "payment_account")))
  await assertFails(getDocs(collection(as("bob"), "users", "alice", "payment_method")))
  await assertSucceeds(getDocs(collection(as("alice"), "users", "alice", "payment_method")))
  await assertSucceeds(setDoc(doc(as("alice"), "users", "alice", "payment_method", "m2"), { type: "mm" }))
  await assertFails(getDocs(collectionGroup(as("bob"), "payment_method")))
  await assertFails(getDocs(collectionGroup(as("bob"), "payment_account")))
  await assertSucceeds(getDocs(collectionGroup(as("admin", ADMIN_EMAIL), "payment_account")))
})
test("instructors can't credit their own payout balance", async () => {
  const mine = doc(as("teacher"), "users", "teacher", "payment_account", "p1")
  await assertSucceeds(updateDoc(mine, { account_holder: "Teacher" }))
  await assertFails(updateDoc(mine, { balance: 1000000 }))
  await assertFails(updateDoc(mine, { sales_reports: [{ amount: 1000000 }] }))
  await assertSucceeds(setDoc(doc(as("teacher"), "users", "teacher", "payment_account", "p2"), { balance: 0, account_type: "Mobile money" }))
  await assertFails(setDoc(doc(as("teacher"), "users", "teacher", "payment_account", "p3"), { balance: 500 }))
  await assertSucceeds(updateDoc(doc(as("admin", ADMIN_EMAIL), "users", "teacher", "payment_account", "p1"), { balance: 10 }))
})
test("purchase history and purchases are private; group query is admin-only", async () => {
  await assertSucceeds(getDocs(collection(as("alice"), "users", "alice", "purchase_history")))
  await assertFails(getDocs(collection(as("bob"), "users", "alice", "purchase_history")))
  await assertFails(getDocs(collectionGroup(as("bob"), "purchase_history")))
  await assertSucceeds(getDocs(collection(as("alice"), "users", "alice", "purchased_courses")))
  await assertFails(getDocs(collection(as("bob"), "users", "alice", "purchased_courses")))
  await assertSucceeds(updateDoc(doc(as("alice"), "users", "alice", "purchased_courses", "pc1"), { reviwed: true }))
  await assertFails(setDoc(doc(as("alice"), "users", "alice", "purchased_courses", "free"), { courses_ref: doc(as("alice"), "courses", "c1") }))
})
test("notifications: others can create, only owner reads/updates", async () => {
  await assertSucceeds(addDoc(collection(as("bob"), "users", "teacher", "notification"), { type: "subscribed", seen: false }))
  await assertFails(getDocs(collection(as("bob"), "users", "alice", "notification")))
  await assertSucceeds(getDocs(collection(as("alice"), "users", "alice", "notification")))
  await assertSucceeds(updateDoc(doc(as("alice"), "users", "alice", "notification", "n1"), { seen: true }))
  await assertFails(getDocs(collectionGroup(as("bob"), "notification")))
})

// ---------- options / ads ----------
test("options: instructors add tags/categories, learners can't", async () => {
  await assertSucceeds(updateDoc(doc(as("teacher"), "options", "o1"), { tags: arrayUnion("b") }))
  await assertFails(updateDoc(doc(as("bob"), "options", "o1"), { tags: arrayUnion("b") }))
  await assertFails(updateDoc(doc(as("teacher"), "options", "o1"), { trending_now: ["spam"] }))
})
test("ads: signed-in read, admin-only write", async () => {
  await assertSucceeds(getDocs(collection(as("bob"), "ads")))
  await assertFails(setDoc(doc(as("bob"), "ads", "x"), { image_url: "y" }))
  await assertSucceeds(setDoc(doc(as("admin", ADMIN_EMAIL), "ads", "x"), { image_url: "y" }))
})

// ---------- consultation / support / refunds ----------
test("consultations: anyone books; not public; instructors/admin/owner read", async () => {
  await assertSucceeds(addDoc(collection(anon(), "consultation"), { email: "z@x.com" }))
  await assertFails(getDocs(collection(anon(), "consultation")))
  await assertFails(getDocs(collection(as("alice"), "consultation")))
  await assertSucceeds(getDocs(collection(as("teacher"), "consultation")))
  await assertSucceeds(getDoc(doc(as("bob"), "consultation", "k1")))
})
test("support thread belongs to its learner", async () => {
  const a = as("alice")
  await assertSucceeds(getDoc(doc(a, "support", "s1")))
  await assertSucceeds(addDoc(collection(a, "support", "s1", "support_message"), { message: "help" }))
  await assertFails(getDoc(doc(as("bob"), "support", "s1")))
  await assertFails(getDocs(collection(as("bob"), "support", "s1", "support_message")))
  const b = as("bob")
  await assertSucceeds(setDoc(doc(b, "support", "s2"), { user: userRef(b, "bob") }))
  await assertSucceeds(addDoc(collection(b, "support", "s2", "support_message"), { message: "hi" }))
})
test("refund requests: own create/read, admin reads all", async () => {
  const b = as("bob")
  await assertSucceeds(setDoc(doc(b, "requesta_refund", "rf1"), { user_ref: userRef(b, "bob"), status: "pending" }))
  await assertFails(setDoc(doc(b, "requesta_refund", "rf2"), { user_ref: userRef(b, "alice") }))
  await assertFails(getDoc(doc(as("alice"), "requesta_refund", "rf1")))
  await assertSucceeds(getDocs(collection(as("admin", ADMIN_EMAIL), "requesta_refund")))
})

// ---------- unchanged behaviour ----------
test("new user creates own doc; contact form works signed out", async () => {
  await assertSucceeds(setDoc(userRef(as("carol"), "carol"), { email: "c@x.com", display_name: "", created_time: serverTimestamp() }))
  await assertSucceeds(addDoc(collection(anon(), "contact_messages"), { name: "N", email: "n@x.com", topic: "", message: "hi", uid: "", createdAt: serverTimestamp() }))
})
