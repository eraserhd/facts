(import :std/test
        "store")

(def store-test
  (test-suite "test :facts/store"
    (test-case "lists as stores"
      (def db
        [[1 color: 'blue]
         [1 size: 'small]
         [2 color: 'red]])
      (check (look-up-facts '() #f #f #f) => '())
      (check (look-up-facts db #f #f #f) => db)
      (check (look-up-facts db '(equal? 1) #f #f) => [[1 color: 'blue] [1 size: 'small]])
      (check (look-up-facts db #f '(equal? size:) #f) => [[1 size: 'small]])
      (check (look-up-facts db #f #f '(equal? red)) => [[2 color: 'red]])
      (check (look-up-facts db '(equal? 1) '(equal? size:) '(equal? small)) => [[1 size: 'small]])
      (check (look-up-facts db #f '(equal? size:) '(equal? big)) => '()))))

(run-tests! store-test)
(test-report-summary!)

(case (test-result)
  ((OK) (exit 0))
  (else (exit 1)))
