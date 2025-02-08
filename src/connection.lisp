(uiop:define-package #:40ants-pg/connection
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
  (:import-from #:40ants-pg/settings
                #:get-default-application-name
                #:get-application-name
                #:get-db-pass
                #:get-db-user
                #:get-db-name
                #:get-db-port
                #:get-db-host)
  (:import-from #:40ants-pg/query
                #:execute)
  (:import-from #:40ants-pg/transactions
                #:call-with-transaction)
  (:import-from #:str
                #:shorten)
  (:export
   #:connection-error
   #:error-message
   #:connect
   #:connect-toplevel
   #:connect-toplevel-in-dev
   #:with-connection))
(in-package #:40ants-pg/connection)

;; TODO: разобраться почему при использовании pool,
;; запросы через раз зависают. Пока не кэшируем:
(defparameter *cached-default* nil)


(define-condition connection-error (error)
  ((message :initarg :message
            :reader error-message))
  (:report (lambda (condition stream)
             (format stream "~A"
                     (error-message condition)))))


(declaim (notinline inner-connect))

(defun inner-connect (&key host database-name username password
                           (port 5432)
                           (cached *cached-default*)
                           (application-name (get-default-application-name))
                           (use-ssl :no))
  "This function is used to leave a trace in the backtrace and let
   logger know which arguments are secret."

  (let ((application-name
          ;; This is a limit of Postgres.
          ;; If application name is larger than this limit
          ;; then Postgres will trim it or even can just
          ;; ignore the value.
          (shorten 63 application-name)))
    (funcall (if cached
                 'cl-dbi:connect-cached
                 'cl-dbi:connect)
             :postgres
             :host host
             :port port
             :database-name database-name
             :username username
             :password (ensure-value-revealed password)
             :application-name application-name
             :use-ssl use-ssl)))


(defun connect (&key host database-name username password
                     port
                     (cached *cached-default*)
                     (application-name nil)
                     (use-ssl :no))
  (let ((host (or host
                  (get-db-host)))
        (port (or port
                  (get-db-port)))
        (dbname (or database-name
                    (get-db-name)))
        (application-name (or application-name
                              (get-application-name)))
        (username (or username
                      (get-db-user))))
      (log:debug "Making new connection (host=~A port=~A username=~A dbname=~A use-ssl=~A cached=~A)"
                 host
                 port
                 username
                 dbname
                 use-ssl
                 cached)
  
    (inner-connect :host host
                   :port port
                   :database-name dbname
                   :username username
                   :password (or password
                                 (get-db-pass))
                   :cached cached
                   :application-name application-name
                   :use-ssl use-ssl)))


(defun connect-toplevel ()
  (setf mito:*connection* (connect :cached nil)))


(defun connect-toplevel-in-dev ()
  (setf mito:*connection*
        (cl-dbi:connect :postgres
                        :host (get-db-host)
                        :port (get-db-port)
                        :database-name (get-db-name)
                        :username (get-db-user)
                        :password (get-db-pass))))

(defvar *was-cached*)


(defun call-with-connection (func &rest connect-options &key (cached *cached-default*) &allow-other-keys)
  (when (and cached
             (boundp '*was-cached*)
             (not *was-cached*))
    (error 'connection-error
           :message "Unable to get cached connection inside a block with non-cached connection."))

  (let* ((*was-cached* cached)
         ;; (cl-postgres:*ssl-key-file* )
         ;;
         ;;  
         ;; (cl-postgres:*ssl-root-ca-file*
         ;;   "/home/art/.postgresql/root.crt")
         ;; (cl-postgres:*ssl-certificate-file*
         ;;   "/home/art/.postgresql/root.crt")
         (schema (prog1 (getf connect-options :schema)
                   (remove-from-plistf connect-options :schema)))
         (mito:*connection*
           ;; In cached mode we will reuse current connect.
           ;; This way, nested WITH-CONNECTION calls will
           ;; reuse the same connection and postgres savepoints.
           (cond ((and *was-cached*
                       mito:*connection*)
                  mito:*connection*)
                 (t
                  (apply #'connect
                         connect-options)))))
    (when schema
      (execute (format nil "set search_path TO ~A,public"
                       (string-downcase schema))))
    
    (unwind-protect
         (call-with-transaction func)
      (unless cached
        ;; We don't want to close nested cached connections
        ;; because they should be closed only on upper level
        ;; Here is a state table showing in which cases connect
        ;; will be closed:
        ;; | top connect | nested connect | close top | close nested |
        ;; | cached?     | cached?        | connect?  | connect?     |
        ;; |-------------+----------------+-----------+--------------|
        ;; | nil         | nil            | t         | t            |
        ;; | nil         | t              | t         | t            |
        ;; | t           | t              | t         | nil          |
        (cl-dbi:disconnect mito:*connection*)))))


(defmacro with-connection ((&rest connect-options) &body body)
  "Establish a new connection and start transaction"
  (with-gensyms (connected-func)
    `(flet ((,connected-func ()
              ,@body))
       (declare (dynamic-extent #',connected-func))
       (call-with-connection #',connected-func ,@connect-options))))
