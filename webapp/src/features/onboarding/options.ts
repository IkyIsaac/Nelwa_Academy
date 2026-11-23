/**
 * Questionnaire choices, identical to the mobile app (lib/app_state.dart).
 * `value` is what's stored in Firestore — keep it unchanged so mobile and web
 * agree. `key` points at the translated label in messages/*.json.
 */
export const interestOptions = [
  { value: "ICE-CREAM", key: "iceCream", emoji: "🍦" },
  { value: "BAKERY", key: "bakery", emoji: "🥐" },
  { value: "CATERING", key: "catering", emoji: "🍽️" },
] as const

export const experienceOptions = [
  { value: "Newcomer", key: "newcomer" },
  { value: "Beginner", key: "beginner" },
  { value: "Student", key: "student" },
  { value: "Enthusiast", key: "enthusiast" },
  { value: "Intermediate", key: "intermediate" },
  { value: "Professional", key: "professional" },
] as const

export const useForOptions = [
  { value: "I want to start my business ", key: "startBusiness" },
  { value: "I want to improve my skills", key: "improveSkills" },
  { value: "I want to improve my team's skills", key: "improveTeam" },
  { value: "I'm just looking around", key: "lookingAround" },
] as const
