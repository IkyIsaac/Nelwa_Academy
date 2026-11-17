/**
 * Every country (ISO 3166-1 alpha-2), with names in the learner's language
 * from the browser's built-in Intl data — no translation files needed.
 * We store the English name in Firestore so mobile and admin read it as-is.
 */
const CODES =
  "AF AX AL DZ AS AD AO AI AQ AG AR AM AW AU AT AZ BS BH BD BB BY BE BZ BJ BM BT BO BQ BA BW BV BR IO BN BG BF BI CV KH CM CA KY CF TD CL CN CX CC CO KM CG CD CK CR CI HR CU CW CY CZ DK DJ DM DO EC EG SV GQ ER EE SZ ET FK FO FJ FI FR GF PF TF GA GM GE DE GH GI GR GL GD GP GU GT GG GN GW GY HT HM VA HN HK HU IS IN ID IR IQ IE IM IL IT JM JP JE JO KZ KE KI KP KR KW KG LA LV LB LS LR LY LI LT LU MO MG MW MY MV ML MT MH MQ MR MU YT MX FM MD MC MN ME MS MA MZ MM NA NR NP NL NC NZ NI NE NG NU NF MK MP NO OM PK PW PS PA PG PY PE PH PN PL PT PR QA RE RO RU RW BL SH KN LC MF PM VC WS SM ST SA SN RS SC SL SG SX SK SI SB SO ZA GS SS ES LK SD SR SJ SE CH SY TW TJ TZ TH TL TG TK TO TT TN TR TM TC TV UG UA AE GB US UM UY UZ VU VE VN VG VI WF EH YE ZM ZW".split(
    " ",
  )

/** Shown first: where most learners are. */
export const SUGGESTED_COUNTRIES = ["TZ", "KE", "UG", "RW", "BI", "CD", "CM", "NG", "ZA"]

export type Country = { code: string; name: string; englishName: string; flag: string }

const flagOf = (code: string) => String.fromCodePoint(...[...code].map((c) => 0x1f1e6 + c.charCodeAt(0) - 65))

export function getCountries(locale: string): Country[] {
  const local = new Intl.DisplayNames([locale], { type: "region" })
  const english = new Intl.DisplayNames(["en"], { type: "region" })
  return CODES.map((code) => ({
    code,
    name: local.of(code) ?? code,
    englishName: english.of(code) ?? code,
    flag: flagOf(code),
  })).sort((a, b) => a.name.localeCompare(b.name, locale))
}
