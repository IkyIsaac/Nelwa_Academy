/**
 * The site's public address, used for the sitemap, robots.txt and share
 * links. Set NEXT_PUBLIC_SITE_URL on a preview deploy so its links point at
 * itself rather than the live site.
 */
export const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || "https://nelwasacademy.com"

/** Contact details and links shown across the site (from the landing template). */
export const site = {
  name: "Nelwa's Academy",
  email: "nelwasacademy@nelwasgelato.com",
  whatsappNumber: "+255 758 097 748",
  whatsappUrl: "https://wa.me/255758097748",
  gelatoUrl: "https://www.nelwasgelato.com",
  playStoreUrl: "https://play.google.com/store/apps/details?id=com.mycompany.nelwas",
} as const

/**
 * Feature switches. Refund requests are turned off by the academy
 * (2026-11-17); flip `refunds` back to true to restore the button and page.
 */
export const features = {
  refunds: false,
} as const

/** Routes in one place so links never drift out of sync. */
export const routes = {
  landing: "/",
  home: "/home",
  explore: "/explore",
  search: "/search",
  categories: "/categories",
  category: (name: string) => `/categories/${encodeURIComponent(name)}`,
  tag: (tag: string) => `/tags/${encodeURIComponent(tag)}`,
  group: (group: string) => `/groups/${encodeURIComponent(group)}`,
  course: (id: string) => `/courses/${id}`,
  courseReviews: (id: string) => `/courses/${id}/reviews`,
  instructor: (id: string) => `/instructors/${id}`,
  checkout: (courseId: string) => `/checkout/${courseId}`,
  orderStatus: (orderId: string) => `/checkout/status/${orderId}`,
  learn: "/learn",
  learnCourse: (courseId: string) => `/learn/${courseId}`,
  refund: (courseId: string) => `/learn/${courseId}/refund`,
  notifications: "/notifications",
  studio: "/studio",
  studioCourses: "/studio/courses",
  studioNewCourse: "/studio/courses/new",
  studioCourse: (id: string) => `/studio/courses/${id}`,
  studioSales: "/studio/sales",
  studioFollowers: "/studio/followers",
  studioConsultations: "/studio/consultations",
  account: "/account",
  personalInfo: "/account/personal-info",
  security: "/account/security",
  notificationSettings: "/account/notifications",
  language: "/account/language",
  wishlist: "/account/wishlist",
  purchases: "/account/purchases",
  myReviews: "/account/reviews",
  subscriptions: "/account/subscriptions",
  support: "/account/support",
  help: "/help",
  about: "/about",
  consult: "/consult",
  contact: "/contact",
  terms: "/terms",
  privacy: "/privacy",
  signIn: "/sign-in",
  signUp: "/sign-up",
  forgotPassword: "/forgot-password",
  completeProfile: "/onboarding/profile",
  interests: "/onboarding/interests",
} as const
