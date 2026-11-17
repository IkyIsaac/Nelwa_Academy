"use client"

import { Search, X } from "lucide-react"
import { useTranslations } from "next-intl"
import { cn } from "@/lib/utils"

/** Large rounded search field with a clear button. */
export function SearchBox({
  value,
  onChange,
  onSubmit,
  autoFocus,
  className,
}: {
  value: string
  onChange: (value: string) => void
  onSubmit?: (value: string) => void
  autoFocus?: boolean
  className?: string
}) {
  const t = useTranslations("catalog")

  return (
    <form
      role="search"
      onSubmit={(e) => {
        e.preventDefault()
        onSubmit?.(value)
      }}
      className={cn(
        "group relative flex items-center rounded-full border-[1.5px] border-border bg-white shadow-soft transition-all focus-within:border-primary focus-within:ring-4 focus-within:ring-primary/10",
        className,
      )}
    >
      <Search className="pointer-events-none absolute left-5 size-5 text-muted-foreground group-focus-within:text-primary" />
      <input
        type="search"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        autoFocus={autoFocus}
        placeholder={t("searchPlaceholder")}
        aria-label={t("searchPlaceholder")}
        className="h-14 w-full rounded-full bg-transparent pr-12 pl-13 text-base outline-none placeholder:text-muted-foreground [&::-webkit-search-cancel-button]:hidden"
      />
      {value && (
        <button
          type="button"
          onClick={() => onChange("")}
          aria-label={t("clearSearch")}
          className="absolute right-3 grid size-8 place-items-center rounded-full text-muted-foreground hover:bg-muted hover:text-foreground"
        >
          <X className="size-4" />
        </button>
      )}
    </form>
  )
}

/** Tappable suggestion chips (the mobile "Trending now"). */
export function SearchChips({ terms, onPick }: { terms: string[]; onPick: (term: string) => void }) {
  return (
    <div className="flex flex-wrap gap-2">
      {terms.map((term) => (
        <button
          key={term}
          type="button"
          onClick={() => onPick(term)}
          className="rounded-full border border-border bg-white px-4 py-2 text-sm font-medium transition-all hover:-translate-y-0.5 hover:border-primary/40 hover:text-primary hover:shadow-soft"
        >
          {term}
        </button>
      ))}
    </div>
  )
}
