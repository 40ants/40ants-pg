(uiop:define-package #:40ants-pg/settings
  (:use #:cl)
  (:import-from #:bordeaux-threads-2
                #:thread-name
                #:current-thread)
  (:export #:get-db-user
           #:get-db-pass
           #:get-db-name
           #:get-db-port
           #:get-db-host
           #:get-application-name
           #:get-default-application-name))
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


(defun get-default-application-name ()
  (format nil "40ants-pg-~A"
          (thread-name
           (current-thread))))

(defun get-application-name ()
  (or (uiop:getenv "DB_APP_NAME")
      (get-default-application-name)))

