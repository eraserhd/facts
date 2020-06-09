(import :std/test
        "store")

(def store-test
  (test-suite "test :facts/store"
    (test-case "lists as stores"
      (check (look-up-facts '() #f #f #f) => '()))))

(run-tests! store-test)
(test-report-summary!)

(case (test-result)
  ((OK) (exit 0))
  (else (exit 1)))
