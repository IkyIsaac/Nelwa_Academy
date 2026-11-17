import type { Metadata } from "next"
import { Suspense } from "react"
import { ListingView } from "@/features/catalog/components/discover-views"
import { decodeParam } from "@/lib/params"

type Props = { params: Promise<{ group: string }> }

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { group } = await params
  return { title: decodeParam(group) }
}

export default async function GroupPage({ params }: Props) {
  const { group } = await params
  return (
    <Suspense>
      <ListingView kind="group" value={decodeParam(group)} />
    </Suspense>
  )
}
