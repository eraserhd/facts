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
  (def (matcher pattern)
    (match pattern
      (['equal? x] (lambda (v) (equal? x v)))
      (_           (lambda (_) #t))))
  (def matches-s? (matcher subject))
  (def matches-p? (matcher predicate))
  (def matches-o? (matcher object))
  (def (matches-value? value pattern)
    (match pattern
      (['equal? x] (equal? value x))
      (_           #t)))
  (def matches?
    (match <>
      ([(? matches-s?) (? matches-p?) (? matches-o?)] #t)
      (_                                              #f)))
  (filter matches? store))
