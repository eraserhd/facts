(import :std/sugar
        :std/test
        :std/text/json
        "tree")
(export tree-test)

(def tree-test
  (test-suite "test :facts/tree"
    (test-case "tree->facts"
      (def (json-facts s)
        (tree->facts (string->json-object s)))
      (check (tree->facts (hash ("@id" 42) ("color" "red"))) => '((42 color: "red")))
      (check (tree->facts (hash (@id 42) (color "red"))) => '((42 color: "red")))
      (check (tree->facts (hash (@id: 42) (color: "red"))) => '((42 color: "red")))
      (check (tree->facts (hash (@id: 78) (color: (list "red" "blue")))) => '((78 color: "red")
                                                                              (78 color: "blue")))
      (check (json-facts "{\
                            \"@id\": 42,\
                            \"aSubObject\": { \"@id\": 67 }\
                          }") => '((42 aSubObject: 67))))))
