// Builds an English → { sw, fr } glossary from the Flutter app's translations,
// so the web app reuses the Swahili and French the mobile app already ships.
//
//   node scripts/extract-flutter-glossary.mjs
//
// Reads  ../lib/flutter_flow/internationalization.dart
// Writes scripts/flutter-glossary.json

import { readFileSync, writeFileSync } from "node:fs"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

const here = dirname(fileURLToPath(import.meta.url))
const dartFile = join(here, "../../lib/flutter_flow/internationalization.dart")
const outFile = join(here, "flutter-glossary.json")

const source = readFileSync(dartFile, "utf8")

// Each entry looks like:  'id': { 'en': '…', 'fr': '…', 'sw': '…', },
const entryPattern = /'[\w-]+':\s*\{([^{}]*)\}/g
const langPattern = /'(en|sw|fr)':\s*'((?:\\.|[^'\\])*)'/g

const unescape = (s) =>
  s.replace(/\\n/g, "\n").replace(/\\'/g, "'").replace(/\\\$/g, "$").replace(/\\\\/g, "\\")

const glossary = {}
for (const [, body] of source.matchAll(entryPattern)) {
  const texts = {}
  for (const [, lang, text] of body.matchAll(langPattern)) texts[lang] = unescape(text).trim()
  const english = texts.en
  if (!english || glossary[english]) continue
  glossary[english] = { sw: texts.sw ?? "", fr: texts.fr ?? "" }
}

writeFileSync(outFile, JSON.stringify(glossary, null, 2) + "\n")
console.log(`Wrote ${Object.keys(glossary).length} phrases to ${outFile}`)
