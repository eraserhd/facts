(import :std/test
        "store")

(def store-test
  (test-suite "test :facts/store"
    (test-case "lists as stores"
      (def db
        [[1 color: 'blue]
         [2 color: 'red]])
      (check (look-up-facts '() #f #f #f) => '())
      (check (look-up-facts db #f #f #f) => db))))

(run-tests! store-test)
(test-report-summary!)

(case (test-result)
  ((OK) (exit 0))
  (else (exit 1)))
