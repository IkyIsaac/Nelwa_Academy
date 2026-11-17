import type { Metadata } from "next"
import { Suspense } from "react"
import { ListingView } from "@/features/catalog/components/discover-views"
import { decodeParam } from "@/lib/params"

type Props = { params: Promise<{ tag: string }> }

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { tag } = await params
  return { title: decodeParam(tag) }
}

export default async function TagPage({ params }: Props) {
  const { tag } = await params
  return (
    <Suspense>
      <ListingView kind="tag" value={decodeParam(tag)} />
    </Suspense>
  )
}
