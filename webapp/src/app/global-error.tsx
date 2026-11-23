"use client"

import "./globals.css"

/**
 * Last-resort screen when the root layout itself fails, so translations and
 * the site header aren't available. Plain, bilingual (English and Swahili)
 * and self-contained.
 */
export default function GlobalError({ unstable_retry }: { error: Error; unstable_retry: () => void }) {
  return (
    <html lang="en">
      <body className="grid min-h-dvh place-items-center bg-background px-4 font-sans text-foreground">
        <title>Nelwa&apos;s Academy</title>
        <div className="max-w-md text-center">
          <h1 className="text-2xl font-bold text-primary">Something went wrong</h1>
          <p className="mt-1 text-lg font-semibold">Hitilafu imetokea</p>
          <p className="mt-4 text-sm text-muted-foreground">
            Please try again in a moment. · Tafadhali jaribu tena baada ya muda mfupi.
          </p>
          <button
            type="button"
            onClick={() => unstable_retry()}
            className="mt-8 rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground"
          >
            Try again · Jaribu tena
          </button>
        </div>
      </body>
    </html>
  )
}
