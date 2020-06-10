(import :std/generic
        :std/iter
        :std/misc/list
        :std/srfi/9)
(export :retrieve-facts
        retrieve-facts
        hashed-fact-store?
        make-hashed-fact-store)

(defgeneric :retrieve-facts
  (lambda (store subject-filter predicate-filter object-filter)
    (error (with-output-to-string
             (lambda ()
               (display "retrieve-facts is not implemented for ")
               (display store))))))

(defmethod (:retrieve-facts (store <null>) (subject-filter <t>) (predicate-filter <t>) (object-filter <t>))
  store)
(defmethod (:retrieve-facts (store <pair>) (subject-filter <t>) (predicate-filter <t>) (object-filter <t>))
  store)

(defstruct hashed-fact-store (index)
  constructor: :init!)

(defmethod {:init! hashed-fact-store}
  (lambda (self . fact-lists)
    (def index (make-hash-table))
    (for* ((fact-list fact-lists)
           (fact fact-list))
      (with ([s p o] fact)
        (for* ((s-pattern (list #f `(equal? ,s)))
               (p-pattern (list #f `(equal? ,p)))
               (o-pattern (list #f `(equal? ,o))))
          (hash-update! index (list s-pattern p-pattern o-pattern) (cut cons fact <>) '()))))
    (set! (hashed-fact-store-index self) index)))

(defmethod (:retrieve-facts (store hashed-fact-store) (subject-filter <t>) (predicate-filter <t>) (object-filter <t>))
  (def key [subject-filter predicate-filter object-filter])
  (hash-ref (hashed-fact-store-index store) key '()))

(def (retrieve-facts store subject-filter predicate-filter object-filter)
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
  (filter matches? (:retrieve-facts store subject-filter predicate-filter object-filter)))
