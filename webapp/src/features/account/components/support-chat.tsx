"use client"

import { ArrowUp, ImagePlus, Loader2, MessagesSquare, X } from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useLocale, useTranslations } from "next-intl"
import { useEffect, useMemo, useRef, useState } from "react"
import { toast } from "sonner"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { Textarea } from "@/components/ui/textarea"
import { site } from "@/config/site"
import { useAuth } from "@/features/auth/components/auth-provider"
import { cn } from "@/lib/utils"
import { sendSupportMessage, uploadSupportImage } from "../api"
import { useSupportMessages } from "../hooks"

const MAX_IMAGE_BYTES = 5 * 1024 * 1024

/** One conversation with the academy, shared with the mobile Support screen. */
export function SupportChat() {
  const t = useTranslations("account.support")
  const locale = useLocale()
  const { user, profile } = useAuth()
  // Remember a thread we just opened until the profile snapshot catches up.
  const [newThread, setNewThread] = useState("")
  const supportId = profile?.supportId || newThread
  const live = useSupportMessages(supportId)
  const [text, setText] = useState("")
  const [file, setFile] = useState<File | null>(null)
  const [sending, setSending] = useState(false)
  const bottom = useRef<HTMLDivElement>(null)
  const preview = useMemo(() => (file ? URL.createObjectURL(file) : ""), [file])
  useEffect(() => () => void (preview && URL.revokeObjectURL(preview)), [preview])

  const messages = live.status === "ready" ? live.data : []
  useEffect(() => bottom.current?.scrollIntoView({ behavior: "smooth", block: "end" }), [messages.length])

  const pick = (f: File | undefined) => {
    if (!f) return
    if (!f.type.startsWith("image/") || f.size > MAX_IMAGE_BYTES) return toast.error(t("imageInvalid"))
    setFile(f)
  }

  const send = async () => {
    if (!user || (!text.trim() && !file)) return
    setSending(true)
    try {
      const image = file ? await uploadSupportImage(user.uid, file) : ""
      const id = await sendSupportMessage(user.uid, supportId, text.trim(), image)
      if (!supportId) setNewThread(id)
      setText("")
      setFile(null)
    } catch {
      toast.error(t("sendFailed"))
    } finally {
      setSending(false)
    }
  }

  const fmt = new Intl.DateTimeFormat(locale, { dateStyle: "medium", timeStyle: "short" })

  return (
    <div className="flex h-[min(70dvh,640px)] flex-col overflow-hidden rounded-3xl border border-border bg-white">
      <div className="flex-1 space-y-3 overflow-y-auto bg-cream/50 p-4 sm:p-6">
        {supportId && live.status === "loading" ? (
          <div className="space-y-3">
            <Skeleton className="h-12 w-2/3 rounded-2xl" />
            <Skeleton className="ml-auto h-12 w-1/2 rounded-2xl" />
          </div>
        ) : messages.length === 0 ? (
          <div className="grid h-full place-items-center text-center">
            <div className="max-w-sm">
              <span className="mx-auto mb-4 grid size-14 place-items-center rounded-2xl bg-maroon-tint text-primary">
                <MessagesSquare className="size-6" />
              </span>
              <p className="font-bold">{t("emptyTitle")}</p>
              <p className="mt-1 text-sm text-muted-foreground">{t("emptyBody")}</p>
            </div>
          </div>
        ) : (
          <AnimatePresence initial={false}>
            {messages.map((m) => (
              <motion.div
                key={m.id}
                initial={{ opacity: 0, y: 8, scale: 0.98 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                className={cn("flex", m.fromLearner ? "justify-end" : "justify-start")}
              >
                <div
                  className={cn(
                    "max-w-[80%] rounded-2xl px-4 py-2.5 text-sm",
                    m.fromLearner
                      ? "rounded-br-md bg-primary text-white"
                      : "rounded-bl-md border border-border bg-white",
                  )}
                >
                  {!m.fromLearner && <p className="mb-0.5 text-xs font-bold text-primary">{t("academy")}</p>}
                  {m.image && (
                    // eslint-disable-next-line @next/next/no-img-element -- user upload from Firebase Storage
                    <img src={m.image} alt="" className="mb-2 max-h-60 rounded-xl" />
                  )}
                  {m.text && <p className="whitespace-pre-wrap">{m.text}</p>}
                  {m.at && (
                    <p
                      className={cn(
                        "mt-1 text-[10px]",
                        m.fromLearner ? "text-white/70" : "text-muted-foreground",
                      )}
                    >
                      {fmt.format(m.at)}
                    </p>
                  )}
                </div>
              </motion.div>
            ))}
          </AnimatePresence>
        )}
        <div ref={bottom} />
      </div>

      <div className="border-t border-border p-3">
        {preview && (
          <div className="relative mb-2 w-fit">
            {/* eslint-disable-next-line @next/next/no-img-element -- local blob preview */}
            <img src={preview} alt="" className="h-20 rounded-xl" />
            <button
              type="button"
              onClick={() => setFile(null)}
              aria-label={t("removeImage")}
              className="absolute -top-2 -right-2 grid size-6 place-items-center rounded-full bg-foreground text-white"
            >
              <X className="size-3.5" />
            </button>
          </div>
        )}
        <form
          className="flex items-end gap-2"
          onSubmit={(e) => {
            e.preventDefault()
            send()
          }}
        >
          <label className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-full text-muted-foreground transition-colors hover:bg-cream hover:text-primary">
            <ImagePlus className="size-5" />
            <span className="sr-only">{t("addImage")}</span>
            <input
              type="file"
              accept="image/*"
              className="sr-only"
              onChange={(e) => pick(e.target.files?.[0])}
            />
          </label>
          <Textarea
            value={text}
            onChange={(e) => setText(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault()
                send()
              }
            }}
            rows={1}
            placeholder={t("placeholder")}
            aria-label={t("placeholder")}
            className="max-h-32 min-h-11 resize-none"
          />
          <Button
            type="submit"
            size="icon"
            className="size-11 shrink-0"
            disabled={sending || (!text.trim() && !file)}
            aria-label={t("send")}
          >
            {sending ? <Loader2 className="animate-spin" /> : <ArrowUp />}
          </Button>
        </form>
      </div>
      <p className="border-t border-border bg-cream/40 px-4 py-2 text-center text-xs text-muted-foreground">
        {t("whatsapp")}{" "}
        <a
          href={site.whatsappUrl}
          target="_blank"
          rel="noopener noreferrer"
          className="font-semibold text-primary"
        >
          WhatsApp
        </a>
      </p>
    </div>
  )
}
