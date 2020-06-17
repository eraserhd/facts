(import :std/misc/list)
(export tree->facts)

(def (tree->facts tree)
  (def (table-id table)
    (or (hash-ref table "@id" #f)
        (hash-ref table '@id #f)))
  (def (key->attr k)
    (match k
      ((? string? s) (string->keyword s))
      ((? symbol? s) (string->keyword (symbol->string s)))))
  (def (table->facts table)
    (def id (table-id table))
    (with-list-builder (put!)
      (hash-for-each
       (lambda (k v)
         (when (and (not (equal? "@id" k)) (not (eq? '@id k)))
           (put! (list id (key->attr k) v))))
       table)))
  (match tree
    ((? hash-table?) (table->facts tree))))
