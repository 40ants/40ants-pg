(uiop:define-package #:40ants-pg/locks
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
  (:import-from #:40ants-pg/query
                #:execute
                #:sql-fetch-all)
  (:export #:unable-to-aquire-lock
           #:lock-name
           #:lock-timeout
           #:lock-key
           #:with-lock))
(in-package #:40ants-pg/locks)


(defun make-hash-for-lock-name (name)
  ;; TODO: store all names in some global
  ;;       map {hash -> name} so that we'll be enable
  ;;       to make reverse transformation and know
  ;;       which locks are held on database.
  ;;       Also, we need to add a function which
  ;;       fetches all advisory locks from pg_locks table
  ;;       and returns a list of names.
  ;;       (All of this should be made threasafe of cause.)
  (let* ((bytes (ascii-string-to-byte-array name))
         (hmac (make-hmac bytes :sha256))
         (digest (hmac-digest hmac))
         (num-bits-in-result 63)
         (result (octets-to-integer digest
                                    :n-bits num-bits-in-result)))
    result))


(define-condition unable-to-aquire-lock (simple-error)
  ((lock-name :initarg :lock-name
              :reader lock-name
              :documentation "Human readable lock name, passed to `with-lock' macro.")
   (key :initarg :key
        :reader lock-key
        :documentation "An integer, representing lock in a Postgres database."))
  (:documentation "Signaled if some thread was unable to get a lock on a database.")
  (:report (lambda (condition stream)
             (format stream
                     "Unable to aquire lock: name=~A key=~A"
                     (ignore-errors
                      (lock-name condition))
                     (ignore-errors
                      (lock-key condition))))))


(define-condition lock-timeout (unable-to-aquire-lock)
  ((timeout :initarg :timeout
            :reader lock-timeout
            :documentation "An integer, a number a milliseconds."))
  (:report
   (lambda (condition stream)
     (format stream
             "Lock timeout: name=~A key=~A timeout=~A"
             (ignore-errors (lock-name condition))
             (ignore-errors (lock-key condition))
             (ignore-errors (lock-timeout condition)))))
  (:documentation "Raised when you are trying to get lock to was unable to do this during current lock_timeout."))


(defun try-to-get-lock (lock-name &key (signal-on-failure t))
  (unless (cl-dbi:in-transaction mito:*connection*)
    (error "To get a lock, you need to start a transaction."))
  
  (let* ((key (make-hash-for-lock-name lock-name))
         (rows (sql-fetch-all "SELECT pg_try_advisory_xact_lock(?) as locked" key))
         (locked? (getf (first rows)
                        :|locked|) ))
    (unless locked?
      (log:warn "Unable to get lock" lock-name)
      (when signal-on-failure
        (error 'unable-to-aquire-lock
               :lock-name lock-name
               :key key)))
    locked?))


(defun get-lock (lock-name &key (timeout 3))
  ""
  (unless (cl-dbi:in-transaction mito:*connection*)
    (error "To get a lock, you need to start a transaction."))
  
  (let ((key (make-hash-for-lock-name lock-name)))
    (when timeout
      (check-type timeout integer)
      (execute (format nil "SET lock_timeout = ~A" (* timeout 1000))))
    
    (handler-bind ((cl-dbi:<dbi-database-error>
                     ;; If we were unable to acquire lock because
                     ;; of timeout, we need to throw a special
                     ;; condition which can be catched by the caller
                     (lambda (condition)
                       (with-slots ((code dbi.error::error-code)) condition
                         ;; lock_not_available
                         (when (string-equal code "55P03")
                           (error 'lock-timeout
                                  :lock-name lock-name
                                  :key key
                                  :timeout timeout))))))
      (execute "SELECT pg_advisory_xact_lock(?)" key))))


(defmacro with-lock ((name &key (block t) (timeout 3) (signal-on-failure t)) &body body)
  (if block
      `(block with-lock
         (handler-bind ((lock-timeout (lambda (c)
                                        (declare (ignorable c))
                                        (unless ,signal-on-failure
                                          (return-from with-lock))))))
         (get-lock ,name :timeout ,timeout)
         (log:debug "Lock aquired:" ,name mito:*connection*)
         ,@body)
      `(when (try-to-get-lock ,name :signal-on-failure ,signal-on-failure)
         (log:debug "Lock aquired:" ,name mito:*connection*)
         ,@body)))
