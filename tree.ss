(import :std/misc/list)
(export tree->facts)

(def (tree->facts tree)
  (def (table-id table)
    (hash-ref table "@id"))
  (def (key->attr k)
    (match k
      ((? string? s) (string->keyword s))))
  (def (table->facts table)
    (def id (table-id table))
    (with-list-builder (put!)
      (hash-for-each
       (lambda (k v)
         (when (not (equal? "@id" k))
           (put! (list id (key->attr k) v))))
       table)))
  (match tree
    ((? hash-table?) (table->facts tree))))
