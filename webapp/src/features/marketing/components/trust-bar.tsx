import { Award, ChefHat, Globe, MapPin, Mic, Tv } from "lucide-react"
import { getTranslations } from "next-intl/server"

/** Endless scrolling strip of credentials. Pauses on hover. */
export async function TrustBar() {
  const t = await getTranslations("landing.trust")
  const items = [
    { icon: Tv, text: t("cnn") },
    { icon: Mic, text: t("bbc") },
    { icon: Globe, text: t("since") },
    { icon: Award, text: t("award") },
    { icon: ChefHat, text: t("expertise") },
    { icon: MapPin, text: t("madeIn") },
  ]

  // The list is rendered twice so the loop is seamless; the copy is hidden from screen readers.
  const row = (hidden: boolean) =>
    items.map(({ icon: Icon, text }) => (
      <div key={`${text}-${hidden}`} aria-hidden={hidden} className="flex items-center gap-14">
        <span className="flex items-center gap-2.5 text-[13px] font-bold whitespace-nowrap text-maroon">
          <Icon className="size-4" />
          {text}
        </span>
        <span className="size-1.5 rounded-full bg-maroon/40" />
      </div>
    ))

  return (
    <div className="group overflow-hidden bg-cream py-4">
      <div className="flex w-max animate-marquee gap-14 group-hover:[animation-play-state:paused]">
        {row(false)}
        {row(true)}
      </div>
    </div>
  )
}
