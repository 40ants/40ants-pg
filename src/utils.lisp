(uiop:define-package #:40ants-pg/utils
  (:use #:cl)
  (:import-from #:mito
                #:object-id
                #:select-dao)
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
