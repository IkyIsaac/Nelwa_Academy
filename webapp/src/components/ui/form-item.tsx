import { AnimatePresence, motion } from "motion/react"
import { Field, FieldDescription, FieldLabel } from "@/components/ui/field"

type FormItemProps = {
  label?: React.ReactNode
  htmlFor?: string
  /** Validation message from React Hook Form (`errors.x?.message`). */
  error?: string
  hint?: React.ReactNode
  children: React.ReactNode
  className?: string
}

/**
 * One labelled form row: label, the input passed as children, then a hint
 * or an error message that slides in when validation fails.
 */
export function FormItem({ label, htmlFor, error, hint, children, className }: FormItemProps) {
  return (
    <Field data-invalid={error ? true : undefined} className={className}>
      {label && <FieldLabel htmlFor={htmlFor}>{label}</FieldLabel>}
      {children}
      <AnimatePresence initial={false} mode="wait">
        {error ? (
          <motion.p
            key="error"
            role="alert"
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            exit={{ opacity: 0, height: 0 }}
            className="text-[13px] font-medium text-destructive"
          >
            {error}
          </motion.p>
        ) : (
          hint && <FieldDescription key="hint">{hint}</FieldDescription>
        )}
      </AnimatePresence>
    </Field>
  )
}
