"use client"

import { Camera } from "lucide-react"
import { useTranslations } from "next-intl"
import { useEffect, useMemo, useRef } from "react"
import { initials } from "@/lib/utils"

type AvatarPickerProps = {
  /** Current photo URL (from the profile), shown until a new file is picked. */
  currentUrl: string
  name: string
  file: File | null
  onFileChange: (file: File | null) => void
}

/** Round profile photo with a camera badge; shows a preview of the chosen file. */
export function AvatarPicker({ currentUrl, name, file, onFileChange }: AvatarPickerProps) {
  const t = useTranslations("onboarding.profile")
  const input = useRef<HTMLInputElement>(null)
  // A temporary URL for the picked file, released when the file changes.
  const preview = useMemo(() => (file ? URL.createObjectURL(file) : null), [file])
  useEffect(() => () => void (preview && URL.revokeObjectURL(preview)), [preview])

  const src = preview ?? currentUrl

  return (
    <div className="flex flex-col items-center gap-3">
      <button
        type="button"
        onClick={() => input.current?.click()}
        aria-label={t("changePhoto")}
        className="group relative size-28 cursor-pointer rounded-full shadow-soft ring-4 ring-white transition-transform duration-300 hover:scale-[1.03]"
      >
        <span className="absolute inset-0 grid place-items-center overflow-hidden rounded-full bg-maroon font-display text-3xl font-bold text-cream">
          {src ? (
            // eslint-disable-next-line @next/next/no-img-element -- local blob preview
            <img src={src} alt="" className="size-full object-cover" />
          ) : (
            initials(name)
          )}
        </span>
        <span className="absolute right-0 bottom-0 grid size-9 place-items-center rounded-full border-[3px] border-white bg-gold text-white transition-transform group-hover:scale-110">
          <Camera className="size-4" />
        </span>
      </button>
      <span className="text-xs text-muted-foreground">{t("photoHint")}</span>
      <input
        ref={input}
        type="file"
        accept="image/*"
        hidden
        onChange={(e) => onFileChange(e.target.files?.[0] ?? null)}
      />
    </div>
  )
}
