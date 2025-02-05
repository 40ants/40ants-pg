(uiop:define-package #:40ants-pg-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:40ants-pg-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "HTTP"))
  (0.2.0 2025-02-05
         "* Fixed error on non-external `convert-for-driver-type` function.")
  (0.1.0 2023-02-05
         "* Initial version."))
