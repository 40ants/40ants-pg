(uiop:define-package #:40ants-pg/transactions
  (:use #:cl)
  (:import-from #:log)
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
                #:make-keyword
                #:length=
                #:remove-from-plistf
                #:with-gensyms)
  (:import-from #:sxql
                #:order-by
                #:where)
  (:import-from #:serapeum
                #:fmt)
  (:export
   #:with-transaction))
(in-package #:40ants-pg/transactions)


(defun call-with-transaction (func)
  (cl-dbi:with-transaction mito:*connection*
    (funcall func)))


(defmacro with-transaction (&body body)
  (with-gensyms (transactional-func)
    `(flet ((,transactional-func ()
              ,@body))
       (declare (dynamic-extent #',transactional-func))
       (call-with-transaction #',transactional-func))))
