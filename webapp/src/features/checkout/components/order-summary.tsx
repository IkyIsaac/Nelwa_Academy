import { useTranslations } from "next-intl"
import { CoverImage } from "@/components/cover-image"
import { formatPrice } from "@/features/catalog/format"

type Line = { title: string; price: number; image?: string; subtitle?: string }

/** Course(s) being bought and the total, as on a receipt. */
export function OrderSummary({ lines, total }: { lines: Line[]; total: number }) {
  const t = useTranslations("checkout")
  return (
    <div className="rounded-3xl border border-border bg-white p-5 shadow-lift sm:p-6">
      <h2 className="font-sans text-base font-bold">{t("summary")}</h2>
      <ul className="mt-4 space-y-4">
        {lines.map((line) => (
          <li key={line.title} className="flex gap-3">
            {line.image && (
              <CoverImage
                src={line.image}
                alt=""
                className="aspect-video w-24 shrink-0 rounded-xl object-cover"
              />
            )}
            <div className="min-w-0 flex-1">
              <p className="line-clamp-2 text-sm font-semibold">{line.title}</p>
              {line.subtitle && <p className="mt-0.5 text-xs text-muted-foreground">{line.subtitle}</p>}
            </div>
            <p className="shrink-0 text-sm font-bold">{formatPrice(line.price)}</p>
          </li>
        ))}
      </ul>
      <div className="mt-5 flex items-baseline justify-between border-t border-dashed border-border pt-4">
        <span className="text-sm font-semibold text-muted-foreground">{t("total")}</span>
        <span className="text-2xl font-extrabold text-primary">{formatPrice(total)}</span>
      </div>
    </div>
  )
}
