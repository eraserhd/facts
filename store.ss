(import :std/generic)
(export look-up-facts)

(defgeneric look-up-facts
  (lambda (store subject predicate object)
    (error (with-output-to-string
             (lambda ()
               (display "look-up-facts is not implemented for ")
               (display store))))))

(defmethod (look-up-facts (store <null>) (subject <t>) (predicate <t>) (object <t>))
  '())
