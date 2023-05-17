(uiop:define-package #:40ants-pg/query
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
  (:export #:sql-fetch-all
           #:execute))
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


(defun select-dao-by-ids (class-name ids)
  (let* ((class (find-class class-name))
         (pk-name (let ((value (mito.class:table-primary-key class)))
                    (unless (length= 1 value)
                      (error "PK should have only one column, to make select-dao-by-ids work. ~S has ~S."
                             class-name value))
                    (first value)))
         (columns (mito.class:table-column-slots class))
         (pk-column
           (loop for column in columns
                 for column-name = (closer-mop:slot-definition-name column)
                 thereis (and
                          (string-equal column-name
                                        pk-name)
                          column)))
         (pk-type (when pk-column
                    (mito.class:table-column-type pk-column))))
    (values
     (if ids
         (select-dao class-name
           (where (:in (make-keyword pk-name) ids))
           ;; Чтобы сохранился порядок элементов, такой же как в ids:
           (order-by (:raw (fmt "array_position(array[~{~A~^, ~}]::~A[], ~A)"
                                ids
                                (cond
                                  ((string-equal pk-type "bigserial")
                                   "bigint")
                                  ((string-equal pk-type "serial")
                                   "integer")
                                  (t pk-type))
                                pk-name))))
         #()))))
