"use client"

import { create } from "zustand"
import { createJSONStorage, persist } from "zustand/middleware"

/**
 * Saved courses. Like the mobile app, the wishlist lives on the device
 * (here: the browser's local storage), not in the user's account.
 */
type WishlistState = {
  courseIds: string[]
  toggle: (courseId: string) => void
}

export const useWishlist = create<WishlistState>()(
  persist(
    (set) => ({
      courseIds: [],
      toggle: (courseId) =>
        set(({ courseIds }) => ({
          courseIds: courseIds.includes(courseId)
            ? courseIds.filter((id) => id !== courseId)
            : [courseId, ...courseIds],
        })),
    }),
    {
      name: "nelwa-wishlist",
      storage: createJSONStorage(() => localStorage),
      // Read local storage after the first render (see Providers) so the
      // server and browser HTML match.
      skipHydration: true,
    },
  ),
)
