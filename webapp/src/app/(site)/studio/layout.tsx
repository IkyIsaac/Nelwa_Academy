import type { Metadata } from "next"
import { getTranslations } from "next-intl/server"
import { StudioShell } from "@/features/studio/components/studio-shell"

export async function generateMetadata(): Promise<Metadata> {
  const t = await getTranslations("studio")
  return { title: { template: `%s · ${t("title")}`, default: t("title") }, robots: { index: false } }
}

export default function StudioLayout({ children }: { children: React.ReactNode }) {
  return <StudioShell>{children}</StudioShell>
}
