"use client"

import { motion } from "motion/react"
import { useTranslations } from "next-intl"
import { PageHeader } from "@/components/layout/page-header"
import { routes } from "@/config/site"

/** Shared frame for account sub-pages: title band with "back to account". */
export function AccountPage({
  title,
  description,
  children,
  wide = false,
  back = { href: routes.account },
}: {
  title: string
  description?: string
  children: React.ReactNode
  wide?: boolean
  back?: { href: string; label?: string }
}) {
  const t = useTranslations("account")
  return (
    <>
      <PageHeader
        title={title}
        description={description}
        back={{ href: back.href, label: back.label ?? t("title") }}
      />
      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        className={`container-page py-10 ${wide ? "" : "max-w-3xl"}`}
      >
        {children}
      </motion.div>
    </>
  )
}
