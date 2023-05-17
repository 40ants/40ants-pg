(defsystem "40ants-pg-tests"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/40ants-pg/"
  :class :package-inferred-system
  :description "Provides tests for 40ants-pg."
  :source-control (:git "https://github.com/40ants/40ants-pg")
  :bug-tracker "https://github.com/40ants/40ants-pg/issues"
  :pathname "t"
  :depends-on ("40ants-pg-tests/core")
  :perform (test-op (op c)
                    (unless (symbol-call :rove :run c)
                      (error "Tests failed"))))
