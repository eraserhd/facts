(import :std/misc/list)
(export tree->facts)

(def (tree->facts tree)
  (call-with-list-builder
   (lambda (put-fact! _)
     (def (special-key? k)
       (def s (cond
               ((symbol? k)  (symbol->string k))
               ((keyword? k) (keyword->string k))
               ((string? k)  k)
               (else         "")))
       (and (<= 1 (string-length s))
            (char=? #\@ (string-ref s 0))))

     (def (special-ref table k)
       (or (hash-ref table k #f)
           (hash-ref table (string->symbol k) #f)
           (hash-ref table (string->keyword k) #f)))

     (def (table-id table)
       (special-ref table "@id"))

     (def (key->attr k)
       (match k
         ((? string? s)  (string->keyword s))
         ((? symbol? s)  (string->keyword (symbol->string s)))
         ((? keyword? k) k)))

     (def (process-hash table)
       (def id (table-id table))
       (hash-for-each
        (lambda (k v)
          (def vs (if (list? v) v [v]))
          (when (not (special-key? k))
            (for-each (lambda (v)
                        (put-fact! (list id (key->attr k) v)))
                      vs)))
        table)
       id)

     (process-hash tree))))
