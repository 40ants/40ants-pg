(uiop:define-package #:40ants-pg/local-time
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
                #:fmt))
(in-package #:40ants-pg/local-time)


(defmethod mito.dao:convert-for-driver-type ((driver-type (eql :postgresql))
                                             (col-type (eql :timestamptz))
                                             (value local-time:timestamp))
  (local-time:format-rfc3339-timestring nil value
                                        :timezone local-time:+utc-zone+))


;; Warning, this method can be redefined by SXQL in runtime
(defmethod sxql.operator:convert-for-sql ((value local-time:timestamp))
  (sxql.sql-type:make-sql-variable
   (local-time:format-rfc3339-timestring nil value
                                         :timezone local-time:+utc-zone+)))
