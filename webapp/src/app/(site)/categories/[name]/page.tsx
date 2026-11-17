import type { Metadata } from "next"
import { Suspense } from "react"
import { ListingView } from "@/features/catalog/components/discover-views"
import { decodeParam } from "@/lib/params"

type Props = { params: Promise<{ name: string }> }

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { name } = await params
  return { title: decodeParam(name) }
}

export default async function CategoryPage({ params }: Props) {
  const { name } = await params
  return (
    <Suspense>
      <ListingView kind="category" value={decodeParam(name)} />
    </Suspense>
  )
}
