(import :std/sort
        :std/test
        "store")
(export store-test)

(def (sort-facts facts)
  (def (fact-less? a b)
    (let ((as (with-output-to-string
                (lambda ()
                  (display a))))
          (bs (with-output-to-string
                (lambda ()
                  (display b)))))
      (string<? as bs)))
  (sort facts fact-less?))

(def store-test
  (test-suite "test :facts/store"
    (test-case "lists as stores"
      (def db
        [[1 color: 'blue]
         [1 size: 'small]
         [2 color: 'red]])
      (check (retrieve-facts '() #f #f #f) => '())
      (check (retrieve-facts db #f #f #f) => db)
      (check (retrieve-facts db '(equal? 1) #f #f) => [[1 color: 'blue] [1 size: 'small]])
      (check (retrieve-facts db #f '(equal? size:) #f) => [[1 size: 'small]])
      (check (retrieve-facts db #f #f '(equal? red)) => [[2 color: 'red]])
      (check (retrieve-facts db '(equal? 1) '(equal? size:) '(equal? small)) => [[1 size: 'small]])
      (check (retrieve-facts db #f '(equal? size:) '(equal? big)) => '()))
    (test-case "hashed fact store"
      (def facts
        [[1 color: 'blue]
         [1 size: 'small]
         [2 color: 'red]])
      (def db (make-hashed-fact-store facts))
      (check (hashed-fact-store? db) => #t)
      (check (sort-facts (:retrieve-facts db #f #f #f)) => (sort-facts facts))
      (check (:retrieve-facts db #f '(equal? size:) #f) => [[1 size: 'small]])
      (check (:retrieve-facts db '(equal? 2) '(equal? color:) #f) => [[2 color: 'red]])
      (check (:retrieve-facts db '(equal? 2) '(equal? color:) '(unknown-pred 96)) => [[2 color: 'red]]))))
