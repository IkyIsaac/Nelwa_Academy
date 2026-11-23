"use client"

import { Film, ImagePlus, Loader2, RefreshCw, X } from "lucide-react"
import { useTranslations } from "next-intl"
import { useRef, useState } from "react"
import { toast } from "sonner"
import { CoverImage } from "@/components/cover-image"
import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import { useAuth } from "@/features/auth/components/auth-provider"
import { formatSeconds } from "@/features/catalog/format"
import { cn } from "@/lib/utils"
import { uploadStudioImage, uploadStudioVideo, videoSeconds } from "../api"

const MAX_IMAGE = 10 * 1024 * 1024
const MAX_VIDEO = 1024 * 1024 * 1024

/** Cover / lesson image: resized in the browser, uploaded on pick. */
export function ImageUpload({
  value,
  onChange,
  kind,
  invalid,
}: {
  value: string
  onChange: (url: string) => void
  kind: "course" | "lesson"
  invalid?: boolean
}) {
  const t = useTranslations("studio.media")
  const { user } = useAuth()
  const input = useRef<HTMLInputElement>(null)
  const [busy, setBusy] = useState(false)

  const pick = async (file: File | undefined) => {
    if (!file || !user) return
    if (!file.type.startsWith("image/") || file.size > MAX_IMAGE) {
      toast.error(t("imageInvalid"))
      return
    }
    setBusy(true)
    try {
      onChange(await uploadStudioImage(user.uid, file, kind))
    } catch {
      toast.error(t("uploadFailed"))
    } finally {
      setBusy(false)
    }
  }

  return (
    <div>
      <input
        ref={input}
        type="file"
        accept="image/*"
        hidden
        onChange={(e) => {
          pick(e.target.files?.[0])
          e.target.value = ""
        }}
      />
      {value ? (
        <div className="relative aspect-video w-full max-w-sm overflow-hidden rounded-2xl border border-border">
          <CoverImage src={value} alt="" className="size-full" />
          <div className="absolute right-2 bottom-2 flex gap-2">
            <Button
              size="sm"
              variant="outline"
              className="bg-white"
              disabled={busy}
              onClick={() => input.current?.click()}
            >
              {busy ? <Loader2 className="animate-spin" /> : <RefreshCw />} {t("replace")}
            </Button>
          </div>
        </div>
      ) : (
        <button
          type="button"
          onClick={() => input.current?.click()}
          disabled={busy}
          className={cn(
            "grid aspect-video w-full max-w-sm place-items-center rounded-2xl border-[1.5px] border-dashed border-border bg-cream/50 text-sm text-muted-foreground transition-colors hover:border-primary/40 hover:text-primary",
            invalid && "border-destructive",
          )}
        >
          <span className="flex flex-col items-center gap-2">
            {busy ? <Loader2 className="size-6 animate-spin" /> : <ImagePlus className="size-6" />}
            {busy ? t("uploading") : t("addImage")}
          </span>
        </button>
      )}
    </div>
  )
}

/**
 * Preview / lesson video. Uploads with progress (videos can be large) and
 * reports the length so lessons never need it typed in.
 */
export function VideoUpload({
  value,
  onChange,
  onDuration,
  kind,
  invalid,
}: {
  value: string
  onChange: (url: string) => void
  onDuration?: (seconds: number) => void
  kind: "preview" | "lesson"
  invalid?: boolean
}) {
  const t = useTranslations("studio.media")
  const { user } = useAuth()
  const input = useRef<HTMLInputElement>(null)
  const cancel = useRef<(() => void) | null>(null)
  const [progress, setProgress] = useState<number | null>(null)
  const [seconds, setSeconds] = useState(0)

  const pick = async (file: File | undefined) => {
    if (!file || !user) return
    if (!file.type.startsWith("video/") || file.size > MAX_VIDEO) {
      toast.error(t("videoInvalid"))
      return
    }
    const length = await videoSeconds(file)
    setSeconds(length)
    onDuration?.(length)
    setProgress(0)
    const upload = uploadStudioVideo(user.uid, file, kind, setProgress)
    cancel.current = upload.cancel
    try {
      onChange(await upload.done)
    } catch (error) {
      if ((error as { code?: string }).code !== "storage/canceled") toast.error(t("uploadFailed"))
    } finally {
      setProgress(null)
      cancel.current = null
    }
  }

  return (
    <div className="max-w-sm">
      <input
        ref={input}
        type="file"
        accept="video/*"
        hidden
        onChange={(e) => {
          pick(e.target.files?.[0])
          e.target.value = ""
        }}
      />
      {progress !== null ? (
        <div className="rounded-2xl border border-border bg-white p-4">
          <div className="mb-2 flex items-center justify-between text-sm">
            <span className="font-semibold">
              {t("uploadingVideo", { percent: Math.round(progress * 100) })}
            </span>
            <button
              type="button"
              aria-label={t("cancel")}
              onClick={() => cancel.current?.()}
              className="text-muted-foreground hover:text-destructive"
            >
              <X className="size-4" />
            </button>
          </div>
          <Progress value={progress * 100} className="h-1.5" />
          <p className="mt-2 text-xs text-muted-foreground">{t("keepOpen")}</p>
        </div>
      ) : value ? (
        <div className="space-y-2">
          <video
            src={value}
            controls
            preload="metadata"
            className="aspect-video w-full rounded-2xl bg-maroon-dark"
          />
          <div className="flex items-center justify-between gap-2">
            <span className="text-xs text-muted-foreground">{seconds > 0 && formatSeconds(seconds)}</span>
            <Button size="sm" variant="outline" onClick={() => input.current?.click()}>
              <RefreshCw /> {t("replace")}
            </Button>
          </div>
        </div>
      ) : (
        <button
          type="button"
          onClick={() => input.current?.click()}
          className={cn(
            "grid aspect-video w-full place-items-center rounded-2xl border-[1.5px] border-dashed border-border bg-cream/50 text-sm text-muted-foreground transition-colors hover:border-primary/40 hover:text-primary",
            invalid && "border-destructive",
          )}
        >
          <span className="flex flex-col items-center gap-2">
            <Film className="size-6" />
            {t("addVideo")}
          </span>
        </button>
      )}
    </div>
  )
}
