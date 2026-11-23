// Keeps messages/sw.json and messages/fr.json in step with messages/en.json.
//
//   node scripts/sync-messages.mjs
//
// For every key in en.json:
//   1. keep the existing Swahili/French text if there is one,
//   2. otherwise reuse the mobile app's translation of the same English text
//      (scripts/flutter-glossary.json),
//   3. otherwise fall back to English and list the key as "needs translation".
// Keys removed from en.json are removed from the other files too.
// Keys listed in scripts/same-in-all-languages.json (brand names, prices…)
// are expected to match English and are not reported.

import { existsSync, readFileSync, writeFileSync } from "node:fs"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

const here = dirname(fileURLToPath(import.meta.url))
const messagesDir = join(here, "../messages")
const readJson = (path) => (existsSync(path) ? JSON.parse(readFileSync(path, "utf8")) : {})

const english = readJson(join(messagesDir, "en.json"))
const glossary = readJson(join(here, "flutter-glossary.json"))
const sameEverywhere = new Set(readJson(join(here, "same-in-all-languages.json")))

for (const lang of ["sw", "fr"]) {
  const file = join(messagesDir, `${lang}.json`)
  const existing = readJson(file)
  const missing = []

  const fill = (en, current, path) => {
    if (typeof en === "string") {
      if (typeof current === "string" && current !== en) return current
      const fromMobile = glossary[en.trim()]?.[lang]
      if (fromMobile) return fromMobile
      if (!sameEverywhere.has(path)) missing.push(path)
      return en
    }
    const out = {}
    for (const key of Object.keys(en)) {
      out[key] = fill(en[key], current?.[key], path ? `${path}.${key}` : key)
    }
    return out
  }

  writeFileSync(file, JSON.stringify(fill(english, existing, ""), null, 2) + "\n")
  console.log(`${lang}.json: ${missing.length} key(s) still in English`)
  for (const key of missing) console.log(`  - ${key}`)
}
