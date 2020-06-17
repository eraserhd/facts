(import :std/misc/list)
(export tree->facts)

(def (tree->facts tree)
  (def (table-id table)
    (or (hash-ref table "@id" #f)
        (hash-ref table '@id #f)
        (hash-ref table @id: #f)))
  
  (def (special-key? k)
    (def s (cond
            ((symbol? k)  (symbol->string k))
            ((keyword? k) (keyword->string k))
            ((string? k)  k)
            (else         "")))
    (and (<= 1 (string-length s))
         (char=? #\@ (string-ref s 0))))

  (def (key->attr k)
    (match k
      ((? string? s)  (string->keyword s))
      ((? symbol? s)  (string->keyword (symbol->string s)))
      ((? keyword? k) k)))
  (def (table->facts table)
    (def id (table-id table))
    (with-list-builder (put!)
      (hash-for-each
       (lambda (k v)
         (when (not (special-key? k))
           (put! (list id (key->attr k) v))))
       table)))
  (match tree
    ((? hash-table?) (table->facts tree))))
