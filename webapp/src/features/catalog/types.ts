import type { DocumentData } from "firebase/firestore"
import { bool, date, num, refId, refList, str, strList } from "@/lib/firebase/fields"

/**
 * Catalog documents as the web app uses them. Field names in Firestore are
 * snake_case (written by the FlutterFlow app); converters below map them to
 * camelCase with safe defaults.
 */

export type Course = {
  id: string
  title: string
  titleSw: string
  description: string
  descriptionSw: string
  image: string
  previewVideo: string
  category: string
  /** Home-screen shelf chosen by the instructor: "New Courses" or "We Recommend". */
  group: string
  level: string
  tags: string[]
  audience: string[]
  /** The language the course is taught in. */
  language: { name: string; code: string; flag: string }
  /** Monthly price in TZS. */
  price: number
  /** Yearly price in TZS. */
  yearPrice: number
  rating: number
  reviewsCount: number
  totalLessons: number
  /** Total length in minutes. */
  totalMinutes: number
  instructorId: string
  instructorName: string
  publishedAt: Date | null
  /** Users who bought the course. */
  studentIds: string[]
}

export function toCourse(id: string, d: DocumentData): Course {
  const language = (d.language ?? {}) as DocumentData
  return {
    id,
    title: str(d.title),
    titleSw: str(d.title_sw),
    description: str(d.description),
    descriptionSw: str(d.description_sw),
    image: str(d.image),
    previewVideo: str(d.video_preview),
    category: str(d.category),
    group: str(d.group),
    level: str(d.level),
    tags: strList(d.tags),
    audience: strList(d.audience),
    language: { name: str(language.language), code: str(language.lang_code), flag: str(language.flag) },
    price: num(d.price),
    yearPrice: num(d.year_price),
    rating: num(d.rating),
    reviewsCount: num(d.reviews_count),
    totalLessons: num(d.total_lessons),
    totalMinutes: num(d.total_duration),
    instructorId: refId(d.instructor_ref),
    instructorName: str(d.instructor_name),
    publishedAt: date(d.published_date),
    studentIds: refList(d.downloaders).map((r) => r.id),
  }
}

/** Swahili title/description when the site is in Swahili and one exists, like the mobile app. */
export const courseTitle = (c: Course, locale: string) => (locale === "sw" && c.titleSw ? c.titleSw : c.title)
export const courseDescription = (c: Course, locale: string) =>
  locale === "sw" && c.descriptionSw ? c.descriptionSw : c.description

export type Lesson = {
  id: string
  title: string
  titleSw: string
  description: string
  descriptionSw: string
  image: string
  order: number
  /** Length in seconds. */
  seconds: number
  isFree: boolean
}

export function toLesson(id: string, d: DocumentData): Lesson {
  return {
    id,
    title: str(d.title),
    titleSw: str(d.title_sw),
    description: str(d.description),
    descriptionSw: str(d.description_sw),
    image: str(d.image),
    order: num(d.order),
    seconds: num(d.duration),
    isFree: bool(d.is_free),
  }
}

export const lessonTitle = (l: Lesson, locale: string) => (locale === "sw" && l.titleSw ? l.titleSw : l.title)

export type Review = {
  id: string
  userName: string
  userImage: string
  rating: number
  comment: string
  createdAt: Date | null
  likedBy: string[]
  dislikedBy: string[]
}

export function toReview(id: string, d: DocumentData): Review {
  return {
    id,
    userName: str(d.user_name),
    userImage: str(d.user_image),
    rating: num(d.rating),
    comment: str(d.comment),
    createdAt: date(d.created_at),
    likedBy: refList(d.liked).map((r) => r.id),
    dislikedBy: refList(d.disliked).map((r) => r.id),
  }
}

export type Category = { name: string; image: string; order: number }

/** The single `options` document: lists the admin manages for the whole app. */
export type CatalogOptions = {
  categories: Category[]
  tags: string[]
  trendingNow: string[]
  audiences: string[]
}

export function toOptions(d: DocumentData | undefined): CatalogOptions {
  const categories: Category[] = Array.isArray(d?.categories)
    ? d.categories
        .map((c: DocumentData) => ({ name: str(c?.category), image: str(c?.image), order: num(c?.item) }))
        .filter((c: Category) => c.name)
        .sort((a: Category, b: Category) => a.order - b.order)
    : []
  return {
    categories,
    tags: strList(d?.tags),
    trendingNow: strList(d?.trending_now),
    audiences: strList(d?.course_audience),
  }
}

export type Instructor = {
  id: string
  /** Name and photo come from the user profile, visible to signed-in learners only. */
  name: string
  photoUrl: string
  specialty: string
  about: string
  education: string
  expertise: string[]
  rating: number
  lessons: number
  studentIds: string[]
  followerIds: string[]
  /** id of the instructor_details document, needed to follow/unfollow. */
  detailsId: string
}

export type Ad = { id: string; title: string; description: string; imageUrl: string }
