#-asdf3.1 (error "40ants-pg requires ASDF 3.1 because for lower versions pathname does not work for package-inferred systems.")
(defsystem "40ants-pg"
  :description "A set of utilities to work with Postgresql using Mito and Common Lisp."
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/40ants-pg/"
  :source-control (:git "https://github.com/40ants/40ants-pg")
  :bug-tracker "https://github.com/40ants/40ants-pg/issues"
  :class :40ants-asdf-system
  :defsystem-depends-on ("40ants-asdf-system")
  :pathname "src"
  :depends-on ("40ants-pg/connection"
               "40ants-pg/local-time"
               "40ants-pg/locks"
               "40ants-pg/query"
               "40ants-pg/transactions"
               "40ants-pg/utils")
  :in-order-to ((test-op (test-op "40ants-pg-tests"))))


(register-system-packages "mito" '(#:mito.class #:mito.db #:mito.dao #:mito.util))
(register-system-packages "cl-mustache" '(#:mustache))
(register-system-packages "dbd-postgres" '(#:dbd.postgres))
(register-system-packages "cl-dbi" '(#:dbi.cache.thread #:dbi.error))
(register-system-packages "log4cl" '(#:log))
(register-system-packages "slynk" '(#:slynk-api))
;; To prevent mito and clack loading these libraries in runtime
(register-system-packages "dbd-postgres" '(#:dbd.postgres))
