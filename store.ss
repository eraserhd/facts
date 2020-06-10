(import :std/generic
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
  '())
(defmethod (:retrieve-facts (store <pair>) (subject-filter <t>) (predicate-filter <t>) (object-filter <t>))
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

(defstruct hashed-fact-store (index)
  constructor: :init!)

(defmethod {:init! hashed-fact-store}
  (lambda (self . fact-lists)
    (let (index (make-hash-table))
      (set! (hashed-fact-store-index self) index)
      (for-each
       (lambda (fact-list)
         (for-each
          (lambda (fact)
            (hash-update! index '(#f #f #f) (cut cons fact <>) '()))
          fact-list))
       fact-lists))))

(defmethod (:retrieve-facts (store hashed-fact-store) (subject-filter <t>) (predicate-filter <t>) (object-filter <t>))
  (def key [subject-filter predicate-filter object-filter])
  (hash-ref (hashed-fact-store-index store) key '()))

(def (retrieve-facts store subject-filter predicate-filter object-filter)
  (:retrieve-facts store subject-filter predicate-filter object-filter))
