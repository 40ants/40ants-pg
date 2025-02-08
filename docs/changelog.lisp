(uiop:define-package #:40ants-pg-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:40ants-pg-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "DB_APP_NAME"
                              "HTTP"))
  (0.3.0 2025-02-08
         "
New
===

Function 40ANTS-PG/UTILS:ALL-OBJECTS-ITERATOR now accepts keyword arguments such as `id-slot-getter`, `id-slot` and `batch-size`.

When getting connection it is possible to pass application name. If not passed, then by default it will be searched in DB_APP_NAME
environment variable or created as concatenation of \"40ants-pg-\" and current thread name.

Changes
=======

Connection caching now is turned on by default.
")
  
  (0.2.0 2025-02-05
         "* Fixed error on non-external `convert-for-driver-type` function.")
  (0.1.0 2023-02-05
         "* Initial version."))
