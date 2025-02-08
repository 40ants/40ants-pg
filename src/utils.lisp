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
  (:import-from #:serapeum
                #:fmt)
  (:export #:map-by-id
           #:make-list-placeholders))
(in-package #:40ants-pg/utils)


(defun map-by-id (dao-objects &key
                              (id-slot-getter #'object-id)
                              (test 'eql))
  (loop with result = (make-hash-table :test test)
        for obj in dao-objects
        do (setf (gethash (funcall id-slot-getter obj) result)
                 obj)
        finally (return result)))


(defun make-list-placeholders (list)
  "Given a list of items, returns a string like \"(?,?,?)\"
   where number of questionmarks corresponds to number of list items."
  (fmt "(~{~A~^,~})"
       (loop repeat (length list)
             collect "?")))
