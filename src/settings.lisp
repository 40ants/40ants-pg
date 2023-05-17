(uiop:define-package #:40ants-pg/settings
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
  (:export #:get-db-user
           #:get-db-pass
           #:get-db-name
           #:get-db-port
           #:get-db-host))
(in-package #:40ants-pg/settings)


(defun get-db-host ()
  (or (uiop:getenv "DB_HOST")
      "192.168.0.2"))

(defun get-db-port ()
  (parse-integer
   (or (uiop:getenv "DB_PORT")
       "5432")))

(defun get-db-name ()
  (or (uiop:getenv "DB_NAME")
      "postgres"))

(defun get-db-user ()
  (or (uiop:getenv "DB_USER")
      "root"))

(defun get-db-pass ()
  (uiop:getenv "DB_PASSWORD"))

