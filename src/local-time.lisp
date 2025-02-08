(uiop:define-package #:40ants-pg/local-time
  (:use #:cl)
  (:import-from #:mito.dao
                #:convert-for-driver-type)
  (:import-from #:sxql.operator
                #:convert-for-sql)
  (:import-from #:local-time
                #:+utc-zone+
                #:format-rfc3339-timestring
                #:timestamp)
  (:import-from #:sxql.sql-type
                #:make-sql-variable))
(in-package #:40ants-pg/local-time)


(defmethod convert-for-driver-type ((driver-type (eql :postgresql))
                                    (col-type (eql :timestamptz))
                                    (value timestamp))
  (format-rfc3339-timestring nil value
                             :timezone +utc-zone+))


;; Warning, this method can be redefined by SXQL in runtime
(defmethod convert-for-sql ((value timestamp))
  (make-sql-variable
   (format-rfc3339-timestring nil value
                              :timezone +utc-zone+)))
