(uiop:define-package #:40ants-pg/dao
  (:use #:cl)
  (:import-from #:alexandria
                #:last-elt
                #:length=)
  (:import-from #:mito
                #:object-id
                #:object-created-at)
  (:import-from #:local-time
                #:format-rfc3339-timestring)
  (:import-from #:sxql
                #:where)
  (:export
   #:select-dao-with-pagination))
(in-package #:40ants-pg/dao)


(defmacro select-dao-with-pagination (class &key (limit 10)
                                                 (order-by '((:desc :created-at)
                                                             ;; (:desc :id)
                                                             ))
                                                 page-key
                                                 where)
  (let ((sort-fields '(:created_at
                       ;; :id
                       ))
        ;; desc
        (sort-directions '(:<=
                           ;; :<
                           )))
    `(let* ((clauses (remove nil
                             (list ,@(loop for sort-field in sort-fields
                                           for sort-direction in sort-directions
                                           for idx upfrom 0
                                           collect `(when ,page-key
                                                      (where (,sort-direction ,sort-field
                                                                              (elt ,page-key ,idx)))))
                                   ,@(uiop:ensure-list where))))
            (where-clause (sxql.clause:compose-where-clauses clauses)))
       (multiple-value-bind (objects sql)
           (mito:select-dao ,class
             (sxql:limit ,(1+ limit))
             (sxql:order-by ,@order-by)
             where-clause)
         (let* ((has-next-page (length= objects
                                        ,(1+ limit)))
                (results (if has-next-page
                             (butlast objects)
                             objects))
                (next-page-key
                  (when has-next-page
                    ;; Важно конвертнуть его в строку,
                    ;; иначе SXQL вставит её без таймзоны
                    (let ((last-obj (last-elt results)))
                      (list (format-rfc3339-timestring
                             nil
                             (object-created-at last-obj))
                            (object-id last-obj))))))
           (values results
                   next-page-key
                   sql))))))
