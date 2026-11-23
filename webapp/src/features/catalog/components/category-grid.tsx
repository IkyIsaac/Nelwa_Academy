"use client"

import { ArrowUpRight } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { CoverImage } from "@/components/cover-image"
import { Skeleton } from "@/components/ui/skeleton"
import { routes } from "@/config/site"
import { cn } from "@/lib/utils"
import type { Category, Course } from "../types"

/** Picture tiles linking to each category, with how many courses it holds. */
export function CategoryGrid({
  categories,
  courses,
  loading,
  className,
}: {
  categories: Category[] | undefined
  courses?: Course[]
  loading?: boolean
  className?: string
}) {
  const t = useTranslations("catalog")
  const grid = cn("grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4", className)

  if (loading) {
    return (
      <div className={grid}>
        {Array.from({ length: 4 }, (_, i) => (
          <Skeleton key={i} className="aspect-[4/3] rounded-3xl" />
        ))}
      </div>
    )
  }

  return (
    <div className={grid}>
      {categories?.map((category) => {
        const count = courses?.filter((c) => c.category === category.name).length
        return (
          <Link
            key={category.name}
            href={routes.category(category.name)}
            className="group relative aspect-[4/3] overflow-hidden rounded-3xl bg-maroon"
          >
            <CoverImage
              src={category.image}
              alt=""
              className="absolute inset-0 size-full transition-transform duration-700 ease-out-expo group-hover:scale-110"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-maroon-dark/90 via-maroon-dark/30 to-transparent" />
            <div className="absolute inset-x-4 bottom-4 flex items-end justify-between gap-2 text-white">
              <div className="min-w-0">
                <p className="truncate font-bold">{category.name}</p>
                {count !== undefined && (
                  <p className="text-xs text-white/75">{t("coursesCount", { count })}</p>
                )}
              </div>
              <span className="grid size-8 shrink-0 place-items-center rounded-full bg-white/15 backdrop-blur transition-all group-hover:rotate-45 group-hover:bg-white group-hover:text-primary">
                <ArrowUpRight className="size-4" />
              </span>
            </div>
          </Link>
        )
      })}
    </div>
  )
}
