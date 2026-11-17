"use client"

import { QueryClient, QueryClientProvider } from "@tanstack/react-query"
import { MotionConfig } from "motion/react"
import { NuqsAdapter } from "nuqs/adapters/next/app"
import { useState } from "react"
import { Toaster } from "@/components/ui/sonner"
import { TooltipProvider } from "@/components/ui/tooltip"
import { AuthProvider } from "@/features/auth/components/auth-provider"

/** Everything the client side of the app needs, wrapped once at the root. */
export function Providers({ children }: { children: React.ReactNode }) {
  // One query cache per browser tab (created lazily so it survives re-renders).
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 60_000, // course data rarely changes minute to minute
            refetchOnWindowFocus: false,
            retry: 1,
          },
        },
      }),
  )

  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <NuqsAdapter>
          {/* "user" = respect the visitor's reduced-motion setting everywhere */}
          <MotionConfig reducedMotion="user">
            <TooltipProvider>{children}</TooltipProvider>
          </MotionConfig>
        </NuqsAdapter>
      </AuthProvider>
      <Toaster />
    </QueryClientProvider>
  )
}
