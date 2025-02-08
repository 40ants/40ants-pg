(uiop:define-package #:40ants-pg/transactions
  (:use #:cl)
  (:import-from #:dbi.driver)
  (:import-from #:mito
                #:object-id
                #:select-dao)
  (:import-from #:alexandria
                #:with-gensyms)
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
