(import :std/test
        "store-test"
        "tree-test")

(run-tests! store-test tree-test)
(test-report-summary!)

(case (test-result)
  ((OK) (exit 0))
  (else (exit 1)))
