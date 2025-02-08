(uiop:define-package #:40ants-pg/query
  (:use #:cl)
  (:import-from #:dbi)
  (:import-from #:mito
                #:select-by-sql
                #:object-id
                #:select-dao)
  (:import-from #:alexandria
                #:last-elt
                #:length=
                #:make-keyword
                #:remove-from-plistf
                #:with-gensyms)
  (:import-from #:sxql
                #:limit
                #:order-by
                #:where)
  (:import-from #:40ants-pg/utils
                #:map-by-id
                #:make-list-placeholders)
  (:import-from #:snakes
                #:yield
                #:defgenerator)
  (:import-from #:mustache)
  (:import-from #:mito.class.table)
  (:export #:sql-fetch-all
           #:execute
           #:select-one-column
           #:all-objects-iterator))
(in-package #:40ants-pg/query)


(defun execute (sql &rest params)
  (cl-dbi:execute (cl-dbi:prepare mito:*connection* sql) params))


(defun sql-fetch-all (sql &rest params)
  (cl-dbi:fetch-all (apply #'execute sql params)))


;; Workaround для проблемы, которую я описал тут:
;; https://github.com/fukamachi/mito/issues/120
;; Закомментил потому что работает плохо, лучше явно указать mito:dao-class
;; для класса view
;; (defmethod initialize-instance :around ((class mito:dao-table-view) &rest initargs
;;                                         &key direct-superclasses &allow-other-keys)
;;   (unless (mito.util:contains-class-or-subclasses 'mito:dao-class direct-superclasses)
;;     (push (find-class 'mito:dao-class) (getf initargs :direct-superclasses)))
;;   (apply #'call-next-method class initargs))


(defun select-dao-by-ids (class-name ids &key
                                         (id-field "id")
                                         (id-slot-getter #'object-id)
                                         (sql "SELECT * FROM {{table}} WHERE \"{{column}}\" in {{placeholders}}"))
  (when ids
    (let* ((table-class (find-class class-name))
           (placeholders (make-list-placeholders ids))
           (context (list (cons "table"
                                (mito.class.table:table-name table-class))
                          (cons "column"
                                id-field)
                          (cons "placeholders"
                                placeholders)))
           (full-sql (with-output-to-string (s)
                       (mustache:render sql context s)))
           (objects (select-by-sql table-class
                                   full-sql
                                   :binds ids))
           (mapped (map-by-id objects
                              :id-slot-getter id-slot-getter
                              :test 'equal)))
      ;; To keep ordering the same as in the original IDS list:
      (loop for id in ids
            collect (gethash id mapped)))))



(defun batch-update (ids ;; &key (fields "otvetchik_normalized")
                     )
  (when ids
    (let ((query "
UPDATE {{table}}
SET otvetchik_normalized = data.otvetchik_normalized
FROM
(
  SELECT unnest(?) as id
         unnest(?) as otvetchik_normalized
) as data
WHERE id = data.id
 "))
      (make-list-placeholders ids)
      (mito:execute-sql query
                        (list ids)))))


(defun select-one-column (query &key binds (column :id))
  (loop for row in (mito:retrieve-by-sql query :binds binds)
        collect (getf row column)))


(defgenerator all-objects-iterator (class &key (id-slot-getter #'object-id) (id-slot :id) (batch-size 10))
  "Iterates through all objects of given class fetching them in batches."
  (let* ((last-id nil))
    (flet ((get-next-batch ()
             (let ((objects
                     (select-dao class
                       (if last-id
                           (where (:> id-slot last-id)))
                       (limit batch-size)
                       (order-by id-slot))))
               (when objects
                 (setf last-id
                       (funcall id-slot-getter
                        (last-elt objects)))
                 objects))))
      (loop for objects = (get-next-batch) then (get-next-batch)
            while objects
            do (loop for obj in objects
                     do (yield obj))))))
