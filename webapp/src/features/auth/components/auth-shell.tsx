import { getTranslations } from "next-intl/server"
import Image from "next/image"
import { LanguageSwitcher } from "@/components/layout/language-switcher"
import { Logo } from "@/components/layout/logo"

/**
 * Split-screen frame for sign in / sign up / password pages.
 * Left (desktop only): the brand panel. Right: the form.
 */
export async function AuthShell({ children }: { children: React.ReactNode }) {
  const t = await getTranslations("auth.panel")

  return (
    <div className="grid min-h-dvh lg:grid-cols-[1.05fr_1fr]">
      {/* Brand panel */}
      <aside className="relative hidden overflow-hidden bg-maroon lg:flex lg:flex-col lg:justify-between lg:p-12">
        <div className="grid-lines absolute inset-0" />
        <div className="absolute -top-24 -right-24 size-[480px] animate-blob rounded-full bg-cream opacity-10 blur-[80px]" />
        <div className="absolute -bottom-20 left-1/4 size-[360px] animate-blob rounded-full bg-maroon-light opacity-60 blur-[80px] [animation-direction:reverse]" />

        <Logo light className="relative" />

        <div className="relative mx-auto my-10 w-full max-w-md">
          <div className="relative aspect-square overflow-hidden rounded-[2rem] border border-cream/20 shadow-[0_0_80px_rgb(255_247_238/0.12)]">
            <Image
              src="/brand/hero.jpg"
              alt=""
              fill
              sizes="(min-width: 1024px) 30vw, 0px"
              className="object-cover"
              priority
            />
            <div className="absolute inset-0 bg-gradient-to-t from-maroon-dark/70 via-transparent" />
          </div>
          <div className="absolute -top-5 -right-6 animate-float rounded-2xl border border-cream/20 bg-white/10 px-5 py-3 text-sm font-semibold text-white backdrop-blur-xl">
            <span className="block font-display text-xl font-extrabold text-cream">10+</span>
            {t("years")}
          </div>
          <div className="absolute -bottom-6 -left-8 animate-float rounded-2xl border border-cream/20 bg-white/10 px-5 py-3 text-sm font-semibold text-white backdrop-blur-xl [animation-delay:2s]">
            <span className="block font-display text-xl font-extrabold text-cream">1,200kg</span>
            {t("production")}
          </div>
        </div>

        <blockquote className="relative max-w-md border-l-[3px] border-cream/60 pl-5">
          <p className="font-display text-xl leading-snug font-semibold text-white italic">
            &ldquo;{t("quote")}&rdquo;
          </p>
          <footer className="mt-3 text-sm text-white/70">{t("quoteAuthor")}</footer>
        </blockquote>
      </aside>

      {/* Form side */}
      <div className="flex flex-col bg-white">
        <div className="flex items-center justify-between bg-maroon px-5 py-4 lg:bg-transparent lg:px-10 lg:pt-8">
          <Logo light className="lg:hidden" />
          <div className="ml-auto">
            <div className="lg:hidden">
              <LanguageSwitcher onDark />
            </div>
            <div className="hidden lg:block">
              <LanguageSwitcher />
            </div>
          </div>
        </div>
        <main className="flex flex-1 items-start justify-center px-5 py-10 sm:items-center lg:px-10">
          <div className="w-full max-w-[420px]">{children}</div>
        </main>
      </div>
    </div>
  )
}
