(defsystem "40ants-pg-ci"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/40ants-pg/"
  :class :package-inferred-system
  :description "Provides CI settings for 40ants-pg."
  :source-control (:git "https://github.com/40ants/40ants-pg")
  :bug-tracker "https://github.com/40ants/40ants-pg/issues"
  :pathname "src"
  :depends-on ("40ants-ci"
               "40ants-pg-ci/ci"))
