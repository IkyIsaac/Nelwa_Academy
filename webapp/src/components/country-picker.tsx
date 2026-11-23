"use client"

import { Check, ChevronDown, Search } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import { useMemo, useState } from "react"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
import { getCountries, SUGGESTED_COUNTRIES, type Country } from "@/lib/countries"
import { cn } from "@/lib/utils"

type CountryPickerProps = {
  /** English country name, as stored in Firestore. */
  value: string
  onChange: (englishName: string) => void
  id?: string
  invalid?: boolean
}

/** Searchable country list with flags; suggested countries are listed first. */
export function CountryPicker({ value, onChange, id, invalid }: CountryPickerProps) {
  const t = useTranslations("common")
  const locale = useLocale()
  const [open, setOpen] = useState(false)
  const [query, setQuery] = useState("")

  const countries = useMemo(() => getCountries(locale), [locale])
  const selected = countries.find((c) => c.englishName === value)

  const q = query.trim().toLowerCase()
  const matches = (c: Country) =>
    !q || c.name.toLowerCase().includes(q) || c.englishName.toLowerCase().includes(q)
  const suggested = q ? [] : countries.filter((c) => SUGGESTED_COUNTRIES.includes(c.code))
  const rest = countries.filter((c) => matches(c) && (q || !SUGGESTED_COUNTRIES.includes(c.code)))

  const choose = (country: Country) => {
    onChange(country.englishName)
    setOpen(false)
    setQuery("")
  }

  const row = (country: Country) => (
    <button
      key={country.code}
      type="button"
      role="option"
      aria-selected={country.englishName === value}
      onClick={() => choose(country)}
      className="flex w-full cursor-pointer items-center gap-3 rounded-lg px-3 py-2.5 text-left text-sm transition-colors hover:bg-maroon-tint"
    >
      <span className="text-lg leading-none">{country.flag}</span>
      <span className="flex-1 truncate">{country.name}</span>
      {country.englishName === value && <Check className="size-4 text-primary" />}
    </button>
  )

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger
        id={id}
        aria-invalid={invalid}
        className={cn(
          "flex h-12 w-full cursor-pointer items-center gap-3 rounded-xl border-[1.5px] border-input bg-white px-4 text-left text-[15px] transition-[border-color,box-shadow] outline-none hover:border-primary/30 focus-visible:border-primary focus-visible:ring-4 focus-visible:ring-primary/8 aria-invalid:border-destructive",
          !selected && "text-muted-foreground/70",
        )}
      >
        {selected ? (
          <>
            <span className="text-lg leading-none">{selected.flag}</span>
            <span className="flex-1 truncate text-foreground">{selected.name}</span>
          </>
        ) : (
          <span className="flex-1">{t("chooseCountry")}</span>
        )}
        <ChevronDown className="size-4 text-muted-foreground" />
      </PopoverTrigger>
      <PopoverContent align="start" className="w-(--anchor-width) min-w-72 p-0">
        <div className="flex items-center gap-2 border-b border-border px-3">
          <Search className="size-4 text-muted-foreground" />
          <input
            autoFocus
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder={t("search")}
            className="h-11 flex-1 bg-transparent text-sm outline-none"
          />
        </div>
        <div role="listbox" className="max-h-72 overflow-y-auto p-1.5">
          {suggested.length > 0 && (
            <>
              {suggested.map(row)}
              <div className="mx-3 my-1.5 h-px bg-border" />
            </>
          )}
          {rest.map(row)}
          {rest.length === 0 && (
            <p className="px-3 py-6 text-center text-sm text-muted-foreground">{t("noResults")}</p>
          )}
        </div>
      </PopoverContent>
    </Popover>
  )
}
