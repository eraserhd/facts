(import :std/sugar
        :std/test
        "tree")
(export tree-test)

(def tree-test
  (test-suite "test :facts/tree"
    (test-case "tree->facts"
      (check (tree->facts (hash ("@id" 42) ("color" "red"))) => '((42 color: "red")))
      (check (tree->facts (hash (@id 42) (color "red"))) => '((42 color: "red"))))))

