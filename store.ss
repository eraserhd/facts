(import :std/generic
        :std/misc/list)
(export look-up-facts)

(defgeneric look-up-facts
  (lambda (store subject predicate object)
    (error (with-output-to-string
             (lambda ()
               (display "look-up-facts is not implemented for ")
               (display store))))))

(defmethod (look-up-facts (store <null>) (subject <t>) (predicate <t>) (object <t>))
  '())
(defmethod (look-up-facts (store <pair>) (subject <t>) (predicate <t>) (object <t>))
  (def (matches-value? value pattern)
    (match pattern
      (['equal? x] (equal? value x))
      (_           #t)))
  (def (matches? fact)
    (match fact
      ([s p o] (and (matches-value? s subject)
                    (matches-value? p predicate)
                    (matches-value? o object)))
      (_       #f)))
  (filter matches? store))
