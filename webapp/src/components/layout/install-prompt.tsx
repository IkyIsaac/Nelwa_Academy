"use client"

import { Download, Share, SquarePlus, X } from "lucide-react"
import { useTranslations } from "next-intl"
import { usePathname } from "next/navigation"
import { useEffect, useState } from "react"
import { Button } from "@/components/ui/button"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"

/** Chrome/Edge/Samsung Internet's install event (not in TypeScript's DOM types). */
type InstallEvent = Event & { prompt: () => Promise<void>; userChoice: Promise<{ outcome: string }> }

const DISMISS_KEY = "nelwa-install-dismissed"
const DISMISS_DAYS = 30
const DELAY_MS = 4000
// Pages where a banner would get in the way.
const HIDDEN_ON = ["/checkout", "/learn/", "/studio", "/onboarding", "/sign-in", "/sign-up"]

const isIos = () =>
  /iPhone|iPad|iPod/.test(navigator.userAgent) ||
  (navigator.userAgent.includes("Macintosh") && navigator.maxTouchPoints > 1) // iPadOS

const isInstalled = () =>
  window.matchMedia("(display-mode: standalone)").matches ||
  (navigator as Navigator & { standalone?: boolean }).standalone === true

function recentlyDismissed() {
  try {
    const at = Number(localStorage.getItem(DISMISS_KEY))
    return at > 0 && Date.now() - at < DISMISS_DAYS * 86_400_000
  } catch {
    return false
  }
}

/**
 * "Add Nelwa's Academy to your home screen" banner for phones.
 *
 * - Android (Chrome, Edge, Samsung): the browser's own install dialog,
 *   opened from our Install button.
 * - iPhone/iPad: Safari has no install dialog that a site can open, so the
 *   banner shows the two steps: Share, then "Add to Home Screen".
 *
 * Hidden once installed, on wide screens, on pages where it would be in the
 * way, and for 30 days after the visitor closes it.
 */
export function InstallPrompt() {
  const t = useTranslations("install")
  const pathname = usePathname()
  const { status } = useAuth()
  const [mode, setMode] = useState<"ios" | "android" | null>(null)
  const [installEvent, setInstallEvent] = useState<InstallEvent | null>(null)

  useEffect(() => {
    if (isInstalled() || recentlyDismissed()) return
    let timer: ReturnType<typeof setTimeout> | undefined

    if (isIos()) {
      timer = setTimeout(() => setMode("ios"), DELAY_MS)
      return () => clearTimeout(timer)
    }

    const onPrompt = (e: Event) => {
      e.preventDefault() // keep Chrome's mini-bar away; we show our own banner
      setInstallEvent(e as InstallEvent)
      timer = setTimeout(() => setMode("android"), DELAY_MS)
    }
    const onInstalled = () => setMode(null)
    window.addEventListener("beforeinstallprompt", onPrompt)
    window.addEventListener("appinstalled", onInstalled)
    return () => {
      clearTimeout(timer)
      window.removeEventListener("beforeinstallprompt", onPrompt)
      window.removeEventListener("appinstalled", onInstalled)
    }
  }, [])

  if (!mode || HIDDEN_ON.some((p) => pathname.startsWith(p))) return null

  const dismiss = () => {
    try {
      localStorage.setItem(DISMISS_KEY, String(Date.now()))
    } catch {}
    setMode(null)
  }

  const install = async () => {
    if (!installEvent) return
    await installEvent.prompt()
    const { outcome } = await installEvent.userChoice
    setInstallEvent(null)
    if (outcome === "accepted") setMode(null)
    else dismiss()
  }

  return (
    <div
      role="dialog"
      aria-label={t("title")}
      className={cn(
        "fixed inset-x-3 z-50 rounded-3xl border border-border bg-white p-4 shadow-[0_12px_40px_rgb(93_8_11/0.2)] md:hidden",
        // Sit above the bottom tab bar when it's showing (signed in).
        status === "signed-in"
          ? "bottom-[calc(5.5rem+env(safe-area-inset-bottom))]"
          : "bottom-[calc(0.75rem+env(safe-area-inset-bottom))]",
      )}
    >
      <div className="flex items-start gap-3">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src="/icons/icon-192.png" alt="" className="size-12 shrink-0 rounded-xl border border-border" />
        <div className="min-w-0 flex-1">
          <p className="text-sm font-bold">{t("title")}</p>
          <p className="mt-0.5 text-xs leading-relaxed text-muted-foreground">{t("body")}</p>
        </div>
        <button
          type="button"
          onClick={dismiss}
          aria-label={t("close")}
          className="-mt-1 -mr-1 grid size-8 shrink-0 place-items-center rounded-full text-muted-foreground hover:bg-muted"
        >
          <X className="size-4" />
        </button>
      </div>

      {mode === "ios" ? (
        <ol className="mt-3 space-y-2 rounded-2xl bg-cream/70 p-3 text-xs">
          <li className="flex items-center gap-2">
            <span className="grid size-6 shrink-0 place-items-center rounded-full bg-primary text-[11px] font-bold text-white">
              1
            </span>
            <span>
              {t.rich("iosStep1", {
                icon: () => (
                  <Share
                    className="mx-0.5 inline size-4 align-text-bottom text-[#007aff]"
                    aria-label="Share"
                  />
                ),
              })}
            </span>
          </li>
          <li className="flex items-center gap-2">
            <span className="grid size-6 shrink-0 place-items-center rounded-full bg-primary text-[11px] font-bold text-white">
              2
            </span>
            <span>
              {t.rich("iosStep2", {
                b: (chunks) => <b>{chunks}</b>,
                icon: () => <SquarePlus className="mx-0.5 inline size-4 align-text-bottom" aria-hidden />,
              })}
            </span>
          </li>
        </ol>
      ) : (
        <Button className="mt-3 w-full" onClick={install}>
          <Download className="size-4" />
          {t("install")}
        </Button>
      )}
    </div>
  )
}
