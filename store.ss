(import :std/generic
        :std/misc/list)
(export retrieve-facts)

(defgeneric retrieve-facts
  (lambda (store subject-filter predicate-filter object-filter)
    (error (with-output-to-string
             (lambda ()
               (display "retrieve-facts is not implemented for ")
               (display store))))))

(defmethod (retrieve-facts (store <null>) (subject-filter <t>) (predicate-filter <t>) (object-filter <t>))
  '())
(defmethod (retrieve-facts (store <pair>) (subject-filter <t>) (predicate-filter <t>) (object-filter <t>))
  (def (matcher pattern)
    (match pattern
      (['equal? x] (lambda (v) (equal? x v)))
      (_           (lambda (_) #t))))
  (def matches-s? (matcher subject-filter))
  (def matches-p? (matcher predicate-filter))
  (def matches-o? (matcher object-filter))
  (def matches?
    (match <>
      ([(? matches-s?) (? matches-p?) (? matches-o?)] #t)
      (_                                              #f)))
  (filter matches? store))
