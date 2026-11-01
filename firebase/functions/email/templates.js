/**
 * Email copy, in English and Swahili. Each template takes the `data` stored
 * on the outbox doc plus the recipient's language, and returns the content
 * blocks layout.js renders. All strings are plain text (layout escapes them).
 */

const APP_URL = () => process.env.APP_URL || "https://nelwasacademy.com";

function money(amount, currency = "TZS") {
  return `${currency} ${Number(amount || 0).toLocaleString("en-US")}`;
}

function date(iso, language) {
  const d = iso ? new Date(iso) : new Date();
  return d.toLocaleDateString(language === "sw" ? "sw-TZ" : "en-GB", {
    day: "numeric",
    month: "long",
    year: "numeric",
    timeZone: "Africa/Dar_es_Salaam",
  });
}

function greeting(name, language) {
  const first = (name || "").trim().split(/\s+/)[0];
  if (language === "sw") return first ? `Habari ${first},` : "Habari,";
  return first ? `Hi ${first},` : "Hi there,";
}

function courseList(titles, language) {
  if (titles.length <= 1) return titles[0] || "";
  const and = language === "sw" ? "na" : "and";
  return `${titles.slice(0, -1).join(", ")} ${and} ${titles[titles.length - 1]}`;
}

const templates = {
  welcome: (d, lang) => {
    const name = (d.name || "").trim().split(/\s+/)[0];
    return lang === "sw" ? {
      subject: name ? `Karibu Nelwa Academy, ${name}!` : "Karibu Nelwa Academy!",
      preheader: "Akaunti yako iko tayari. Anza kujifunza leo.",
      heading: "Karibu Nelwa Academy",
      paragraphs: [
        greeting(d.name, lang),
        "Asante kwa kujiunga na Nelwa Academy. Sasa unaweza kuvinjari kozi, kujifunza kwa kasi yako mwenyewe, na kuendelea ulipoishia wakati wowote.",
        "Unataka kufundisha? Unaweza kuomba kuwa mkufunzi kupitia wasifu wako ndani ya programu.",
      ],
      cta: { label: "Gundua kozi", url: APP_URL() },
    } : {
      subject: name ? `Welcome to Nelwa Academy, ${name}!` : "Welcome to Nelwa Academy!",
      preheader: "Your account is ready. Start learning today.",
      heading: "Welcome to Nelwa Academy",
      paragraphs: [
        greeting(d.name, lang),
        "Thanks for joining Nelwa Academy. You can now browse courses, learn at your own pace, and pick up where you left off at any time.",
        "Want to teach? You can apply to become an instructor from your profile in the app.",
      ],
      cta: { label: "Explore courses", url: APP_URL() },
    };
  },

  purchase_receipt: (d, lang) => {
    const titles = d.courses.map((c) => c.title);
    const single = titles.length === 1;
    const rows = [
      ...d.courses.map((c) => [c.title, money(c.price, d.currency)]),
      [lang === "sw" ? "Jumla" : "Total", money(d.amount, d.currency)],
      [lang === "sw" ? "Namba ya oda" : "Order number", d.orderId],
      [lang === "sw" ? "Tarehe" : "Date", date(d.paidAt, lang)],
      [lang === "sw" ? "Njia ya malipo" : "Payment method", lang === "sw" ? "Pesa kwa simu" : "Mobile money"],
    ];
    return lang === "sw" ? {
      subject: single ? `Umejiandikisha: ${titles[0]}` : `Umejiandikisha kwenye kozi ${titles.length}`,
      preheader: `Malipo ya ${money(d.amount, d.currency)} yamepokelewa.`,
      heading: "Malipo yamepokelewa",
      paragraphs: [
        greeting(d.name, lang),
        single
          ? "Asante kwa ununuzi wako. Malipo yako yamefanikiwa na kozi sasa inapatikana kwenye kozi zako ndani ya programu."
          : "Asante kwa ununuzi wako. Malipo yako yamefanikiwa na kozi sasa zinapatikana kwenye kozi zako ndani ya programu.",
      ],
      rows,
      cta: { label: "Anza kujifunza", url: APP_URL() },
      footnote: "Hifadhi barua pepe hii kama risiti yako. Kama hukufanya ununuzi huu, jibu barua pepe hii.",
    } : {
      subject: single ? `You're enrolled: ${titles[0]}` : `You're enrolled in ${titles.length} courses`,
      preheader: `Payment of ${money(d.amount, d.currency)} received.`,
      heading: "Payment received",
      paragraphs: [
        greeting(d.name, lang),
        single
          ? "Thank you for your purchase. Your payment was successful and the course is now in your courses in the app."
          : "Thank you for your purchase. Your payment was successful and the courses are now in your courses in the app.",
      ],
      rows,
      cta: { label: "Start learning", url: APP_URL() },
      footnote: "Keep this email as your receipt. If you didn't make this purchase, reply to this email.",
    };
  },

  payment_failed: (d, lang) => {
    const courses = courseList(d.courses.map((c) => c.title), lang);
    const expired = d.reason === "expired";
    return lang === "sw" ? {
      subject: "Malipo yako hayakukamilika",
      preheader: "Unaweza kujaribu tena kupitia programu.",
      heading: "Malipo hayakukamilika",
      paragraphs: [
        greeting(d.name, lang),
        expired
          ? `Muda wa malipo ya ${money(d.amount, d.currency)} kwa ${courses} uliisha kabla malipo hayajakamilika.`
          : `Hatukuweza kukamilisha malipo yako ya ${money(d.amount, d.currency)} kwa ${courses}.`,
        "Unaweza kujaribu tena kupitia ukurasa wa kozi ndani ya programu.",
      ],
      rows: [["Namba ya oda", d.orderId]],
      cta: { label: "Jaribu tena", url: APP_URL() },
      footnote: "Kama pesa zimekatwa kwenye akaunti yako ya pesa kwa simu, jibu barua pepe hii ukitaja namba ya oda na tutalifuatilia.",
    } : {
      subject: "Your payment didn't go through",
      preheader: "You can try again from the app.",
      heading: "Payment not completed",
      paragraphs: [
        greeting(d.name, lang),
        expired
          ? `The payment session for ${courses} (${money(d.amount, d.currency)}) expired before the payment was completed.`
          : `We couldn't complete your payment of ${money(d.amount, d.currency)} for ${courses}.`,
        "You can try again from the course page in the app.",
      ],
      rows: [["Order number", d.orderId]],
      cta: { label: "Try again", url: APP_URL() },
      footnote: "If money left your mobile money account, reply to this email with the order number and we'll look into it.",
    };
  },

  instructor_sale: (d, lang) => {
    const titles = d.courses.map((c) => c.title);
    const single = titles.length === 1;
    const rows = [
      ...d.courses.map((c) => [c.title, money(c.price, d.currency)]),
      [lang === "sw" ? "Imeongezwa kwenye salio" : "Added to your balance", money(d.amount, d.currency)],
    ];
    return lang === "sw" ? {
      subject: single ? `Umeuza kozi: ${titles[0]}` : `Umeuza kozi ${titles.length}`,
      preheader: `${money(d.amount, d.currency)} imeongezwa kwenye salio lako.`,
      heading: "Hongera, umepata mauzo!",
      paragraphs: [
        greeting(d.name, lang),
        single
          ? "Mwanafunzi mpya amejiandikisha kwenye kozi yako."
          : "Mwanafunzi mpya amejiandikisha kwenye kozi zako.",
      ],
      rows,
      cta: { label: "Fungua programu", url: APP_URL() },
    } : {
      subject: single ? `You made a sale: ${titles[0]}` : `You made ${titles.length} sales`,
      preheader: `${money(d.amount, d.currency)} was added to your balance.`,
      heading: "Congratulations, you made a sale!",
      paragraphs: [
        greeting(d.name, lang),
        single
          ? "A new student just enrolled in your course."
          : "A new student just enrolled in your courses.",
      ],
      rows,
      cta: { label: "Open the app", url: APP_URL() },
    };
  },

  instructor_application_received: (d, lang) => lang === "sw" ? {
    subject: "Tumepokea ombi lako la kuwa mkufunzi",
    heading: "Ombi lako limepokelewa",
    paragraphs: [
      greeting(d.name, lang),
      "Asante kwa kuomba kufundisha kwenye Nelwa Academy. Timu yetu itakagua ombi lako na tutakutumia barua pepe uamuzi utakapofanywa.",
    ],
  } : {
    subject: "We've received your instructor application",
    heading: "Application received",
    paragraphs: [
      greeting(d.name, lang),
      "Thanks for applying to teach on Nelwa Academy. Our team will review your application and email you once a decision has been made.",
    ],
  },

  instructor_approved: (d, lang) => lang === "sw" ? {
    subject: "Sasa wewe ni mkufunzi wa Nelwa Academy",
    heading: "Ombi lako limekubaliwa",
    paragraphs: [
      greeting(d.name, lang),
      "Hongera! Ombi lako la kuwa mkufunzi limekubaliwa. Sasa unaweza kuanza kuunda kozi kupitia programu.",
    ],
    cta: { label: "Fungua programu", url: APP_URL() },
  } : {
    subject: "You're now a Nelwa Academy instructor",
    heading: "Your application was approved",
    paragraphs: [
      greeting(d.name, lang),
      "Congratulations! Your instructor application has been approved. You can now start creating courses in the app.",
    ],
    cta: { label: "Open the app", url: APP_URL() },
  },

  instructor_rejected: (d, lang) => lang === "sw" ? {
    subject: "Taarifa kuhusu ombi lako la kuwa mkufunzi",
    heading: "Taarifa kuhusu ombi lako",
    paragraphs: [
      greeting(d.name, lang),
      "Asante kwa nia yako ya kufundisha kwenye Nelwa Academy. Baada ya kukagua ombi lako, hatuwezi kulikubali kwa sasa.",
      "Kama una maswali, jibu barua pepe hii.",
    ],
  } : {
    subject: "An update on your instructor application",
    heading: "An update on your application",
    paragraphs: [
      greeting(d.name, lang),
      "Thank you for your interest in teaching on Nelwa Academy. After reviewing your application, we're not able to approve it at this time.",
      "If you have any questions, reply to this email.",
    ],
  },

  instructor_revoked: (d, lang) => lang === "sw" ? {
    subject: "Mabadiliko kwenye ruhusa yako ya ukufunzi",
    heading: "Ruhusa ya ukufunzi imeondolewa",
    paragraphs: [
      greeting(d.name, lang),
      "Ruhusa yako ya kuwa mkufunzi kwenye Nelwa Academy imeondolewa.",
      "Kama unadhani hili ni kosa, jibu barua pepe hii.",
    ],
  } : {
    subject: "Your instructor access has changed",
    heading: "Instructor access removed",
    paragraphs: [
      greeting(d.name, lang),
      "Your instructor access on Nelwa Academy has been removed.",
      "If you think this is a mistake, reply to this email.",
    ],
  },
};

module.exports = { templates };
