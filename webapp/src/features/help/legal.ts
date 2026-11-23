/**
 * Terms and Privacy text (English only). Placeholder wording that matches
 * how the platform works today; the academy will supply its final legal
 * documents to replace it. See docs/account-web.md. Keep it in step with
 * any change to what data is collected or which services process it.
 */

export type LegalSection = { heading: string; paragraphs: string[] }
export type LegalDoc = { updated: string; intro: string; sections: LegalSection[] }

const CONTACT = "nelwasacademy@nelwasgelato.com"

export const terms: LegalDoc = {
  updated: "17 November 2026",
  intro:
    "These terms apply when you use Nelwa's Academy on the website or in the mobile app. By creating an account or buying a course you agree to them.",
  sections: [
    {
      heading: "1. Your account",
      paragraphs: [
        "You need an account to watch lessons, buy courses, review them or contact support. Give accurate details and keep your password private. You are responsible for what happens under your account.",
        "One account works on both the website and the mobile app. You can delete it at any time from Account → Security.",
      ],
    },
    {
      heading: "2. Courses and access",
      paragraphs: [
        "Some lessons are free for everyone with an account. Buying a course unlocks all of its lessons on the website and in the app for as long as the course is offered on the platform.",
        "Courses are for your personal learning. You may not copy, download, record, resell or share course videos or materials.",
      ],
    },
    {
      heading: "3. Payments",
      paragraphs: [
        "Prices are shown in Tanzanian shillings (TZS). Payments are made by mobile money (M-Pesa, Airtel Money, Mixx by Yas, Halotel) through our payment provider, Snippe. A course is unlocked only after the payment provider confirms your payment.",
        "We never see or store your mobile-money PIN.",
      ],
    },
    {
      heading: "4. No refunds",
      paragraphs: [
        "Course purchases are final and are not refunded. If you were charged but the course didn't unlock, or you were charged twice, contact support with your order details and we'll put it right.",
      ],
    },
    {
      heading: "5. Reviews and messages",
      paragraphs: [
        "Reviews you post are public and show your name and photo. Keep reviews, support messages and anything you upload honest, respectful and lawful. We may remove content that isn't.",
      ],
    },
    {
      heading: "6. Consultations",
      paragraphs: [
        "Booking a consultation sends a request; it is confirmed only when the academy contacts you to agree a time and any fee.",
      ],
    },
    {
      heading: "7. Our content",
      paragraphs: [
        "All courses, videos, text and branding belong to Nelwa's Academy or its instructors. Using the platform gives you a personal, non-transferable right to view them, nothing more.",
      ],
    },
    {
      heading: "8. Availability and liability",
      paragraphs: [
        "We work to keep the platform running but can't promise it will always be available or error-free. Courses are educational; results in your business depend on many things beyond our control, and we are not liable for them to the extent the law allows.",
      ],
    },
    {
      heading: "9. Changes and law",
      paragraphs: [
        "We may update these terms and will show the new date here. These terms are governed by the laws of the United Republic of Tanzania.",
        `Questions? Email ${CONTACT}.`,
      ],
    },
  ],
}

export const privacy: LegalDoc = {
  updated: "17 November 2026",
  intro:
    "This explains what personal information Nelwa's Academy collects on the website and in the app, why, who processes it for us, and the choices you have.",
  sections: [
    {
      heading: "1. What we collect",
      paragraphs: [
        "Account details: your email address, name, profile photo, phone number, date of birth, country, education, what you'd like to learn and anything you write about yourself.",
        "Learning activity: courses you buy, lessons you open, reviews you post, and instructors you follow.",
        "Messages: support chats (including images you attach), contact-form messages and consultation bookings.",
        "Payments: the course, amount, date and status of each order. Your mobile-money number and PIN are handled by our payment provider; we don't store your PIN.",
      ],
    },
    {
      heading: "2. Why we use it",
      paragraphs: [
        "To run your account, give you access to the courses you bought, keep your progress in sync between web and app, process payments, answer your messages and consultation requests, and send emails about your account and purchases (welcome, receipts, payment problems).",
      ],
    },
    {
      heading: "3. Who processes it for us",
      paragraphs: [
        "Google Firebase stores the platform's data and handles sign-in. Snippe processes mobile-money payments. Resend sends our emails. Our web host serves the website. Each receives only what it needs to do that job.",
        "We do not sell your personal information or share it for advertising.",
      ],
    },
    {
      heading: "4. What others can see",
      paragraphs: [
        "Reviews show your name and photo publicly. If you follow an instructor, they can see your profile in their followers list. If you become an instructor, your instructor profile is visible to learners.",
      ],
    },
    {
      heading: "5. On your device",
      paragraphs: [
        "The website remembers your language choice in a cookie and your wishlist in your browser's storage. Firebase keeps you signed in using your browser's storage. We don't use advertising cookies.",
      ],
    },
    {
      heading: "6. Keeping and deleting data",
      paragraphs: [
        "We keep your information while your account exists. You can edit your details in Account → Personal info and delete your account in Account → Security, which removes your profile. Payment records may be kept longer where the law requires.",
      ],
    },
    {
      heading: "7. Your rights",
      paragraphs: [
        `Under Tanzania's Personal Data Protection Act and other applicable law you can ask to see, correct or delete your information, or object to how we use it. Email ${CONTACT}.`,
      ],
    },
    {
      heading: "8. Changes",
      paragraphs: ["We'll update this page when our practices change and show the new date at the top."],
    },
  ],
}
