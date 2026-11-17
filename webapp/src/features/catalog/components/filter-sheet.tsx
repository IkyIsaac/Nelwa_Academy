"use client"

import { SlidersHorizontal, Star } from "lucide-react"
import { useTranslations } from "next-intl"
import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Sheet, SheetContent, SheetTitle, SheetTrigger } from "@/components/ui/sheet"
import { cn } from "@/lib/utils"
import { type CourseFilters, countActiveFilters, defaultFilters } from "../filters"

type Option<T> = { value: T; label: React.ReactNode }

function ChipGroup<T extends string | number>({
  label,
  options,
  value,
  onChange,
}: {
  label: string
  options: Option<T>[]
  value: T
  onChange: (value: T) => void
}) {
  return (
    <fieldset className="border-b border-border py-5 last:border-0">
      <legend className="mb-3 text-sm font-bold">{label}</legend>
      <div className="flex flex-wrap gap-2">
        {options.map((option) => (
          <button
            key={String(option.value)}
            type="button"
            aria-pressed={value === option.value}
            onClick={() => onChange(option.value)}
            className={cn(
              "inline-flex items-center gap-1 rounded-full border px-4 py-2 text-sm font-medium transition-all",
              value === option.value
                ? "border-primary bg-primary text-primary-foreground shadow-soft"
                : "border-border bg-white hover:border-primary/40 hover:text-primary",
            )}
          >
            {option.label}
          </button>
        ))}
      </div>
    </fieldset>
  )
}

/**
 * The mobile filter sheet (rating, duration, price) plus the course language.
 * Choices are applied when the learner taps "Show results".
 */
export function FilterSheet({
  filters,
  onApply,
  languages,
}: {
  filters: CourseFilters
  onApply: (filters: Partial<CourseFilters>) => void
  /** Languages that actually have courses, as [code, name]. */
  languages: [string, string][]
}) {
  const t = useTranslations("catalog.filters")
  const [open, setOpen] = useState(false)
  const [draft, setDraft] = useState(filters)
  const active = countActiveFilters(filters)

  const update = (change: Partial<CourseFilters>) => setDraft((d) => ({ ...d, ...change }))

  return (
    <Sheet
      open={open}
      onOpenChange={(next) => {
        if (next) setDraft(filters)
        setOpen(next)
      }}
    >
      <SheetTrigger render={<Button variant="outline" size="sm" />}>
        <SlidersHorizontal />
        {t("button")}
        {active > 0 && (
          <span className="grid size-5 place-items-center rounded-full bg-primary text-[11px] text-primary-foreground">
            {active}
          </span>
        )}
      </SheetTrigger>
      <SheetContent side="right" className="flex w-full flex-col gap-0 p-0 sm:max-w-md">
        <SheetTitle className="border-b border-border px-6 py-5 font-display text-xl">
          {t("title")}
        </SheetTitle>

        <div className="flex-1 overflow-y-auto px-6">
          <ChipGroup
            label={t("rating")}
            value={draft.rating}
            onChange={(rating) => update({ rating })}
            options={[
              { value: 0, label: t("any") },
              ...[4.5, 4, 3.5].map((r) => ({
                value: r,
                label: (
                  <>
                    <Star className="size-3.5 text-gold" fill="currentColor" strokeWidth={0} />
                    {r.toFixed(1)}+
                  </>
                ),
              })),
            ]}
          />
          <ChipGroup
            label={t("duration")}
            value={draft.duration}
            onChange={(duration) => update({ duration })}
            options={(["any", "under1h", "1to3h", "3to10h", "over10h"] as const).map((value) => ({
              value,
              label: t(`durations.${value}`),
            }))}
          />
          <ChipGroup
            label={t("price")}
            value={draft.price}
            onChange={(price) => update({ price })}
            options={(["any", "free", "under50k", "50to150k", "over150k"] as const).map((value) => ({
              value,
              label: t(`prices.${value}`),
            }))}
          />
          {languages.length > 1 && (
            <ChipGroup
              label={t("language")}
              value={draft.language}
              onChange={(language) => update({ language })}
              options={[
                { value: "", label: t("any") },
                ...languages.map(([value, label]) => ({ value, label })),
              ]}
            />
          )}
        </div>

        <div className="grid grid-cols-2 gap-3 border-t border-border p-4">
          <Button
            variant="ghost"
            onClick={() => {
              const { sort } = filters
              setDraft({ ...defaultFilters, sort })
            }}
          >
            {t("clear")}
          </Button>
          <Button
            onClick={() => {
              onApply(draft)
              setOpen(false)
            }}
          >
            {t("apply")}
          </Button>
        </div>
      </SheetContent>
    </Sheet>
  )
}
