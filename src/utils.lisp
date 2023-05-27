(uiop:define-package #:40ants-pg/utils
  (:use #:cl)
  (:import-from #:log)
  (:import-from #:mustache)
  (:import-from #:dbi)
  (:import-from #:dbi.error)
  (:import-from #:cl-postgres)
  ;; To prevent Mito from trying to load driver on first connect.
  ;; Sometimes this can cause errors if DBD get's updated by some
  ;; project's check
  (:import-from #:dbd.postgres)
  (:import-from #:mito
                #:object-id
                #:select-dao)
  (:import-from #:ironclad
                #:octets-to-integer
                #:hmac-digest
                #:make-hmac
                #:ascii-string-to-byte-array)
  (:import-from #:secret-values
                #:ensure-value-revealed)
  (:import-from #:alexandria
                #:last-elt
                #:make-keyword
                #:length=
                #:remove-from-plistf
                #:with-gensyms)
  (:import-from #:sxql
                #:limit
                #:order-by
                #:where)
  (:import-from #:serapeum
                #:fmt)
  (:import-from #:mito.dao
                #:select-by-sql)
  (:import-from #:snakes
                #:yield
                #:defgenerator)
  (:export #:map-by-id
           #:make-list-placeholders
           #:select-dao-by-ids
           #:all-objects-iterator))
(in-package #:40ants-pg/utils)


(defun map-by-id (dao-objects)
  (loop with result = (make-hash-table)
        for obj in dao-objects
        do (setf (gethash (object-id obj) result)
                 obj)
        finally (return result)))


(defun make-list-placeholders (list)
  "Given a list of items, returns a string like \"(?,?,?)\"
   where number of questionmarks corresponds to number of list items."
  (format nil "(~{~A~^,~})"
          (loop repeat (length list)
                collect "?")))


(defun select-dao-by-ids (class-name ids &key (id-field "id")
                                              (sql "SELECT * FROM {{table}} WHERE \"{{column}}\" in {{placeholders}}"))
  (when ids
    (let* ((table-class (find-class class-name))
           (placeholders (make-list-placeholders ids))
           (context (list (cons "table"
                                (mito.class:table-name table-class))
                          (cons "column"
                                id-field)
                          (cons "placeholders"
                                placeholders)))
           (full-sql (with-output-to-string (s)
                       (mustache:render sql context s))))
      (select-by-sql table-class
                     full-sql
                     :binds ids))))




(defgenerator all-objects-iterator (class)
  "Iterates through all objects of given class fetching them in batches."
  (let* ((last-id nil))
    (flet ((get-next-batch ()
             (let ((objects
                     (select-dao class
                       (if last-id
                           (where (:> :id last-id)))
                       (limit 10)
                       (order-by :id))))
               (when objects
                 (setf last-id
                       (object-id
                        (last-elt objects)))
                 objects))))
      (loop for objects = (get-next-batch) then (get-next-batch)
            while objects
            do (loop for obj in objects
                     do (yield obj))))))
