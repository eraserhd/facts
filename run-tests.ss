(import :std/test
        "store-test")

(run-tests! store-test)
(test-report-summary!)

(case (test-result)
  ((OK) (exit 0))
  (else (exit 1)))
