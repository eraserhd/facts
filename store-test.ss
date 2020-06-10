(import :std/test
        "store")
(export store-test)

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
      (check (retrieve-facts db #f '(equal? size:) '(equal? big)) => '()))))
