(import :std/sugar
        :std/test
        "tree")
(export tree-test)

(def tree-test
  (test-suite "test :facts/tree"
    (test-case "tree->facts"
      (displayln (tree->facts (hash ("@id" 1) ("color" "red"))))
      (check (tree->facts (hash ("@id" 1) ("color" "red"))) => '((1 color: "red"))))))
