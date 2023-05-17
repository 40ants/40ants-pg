(defsystem "40ants-pg-docs"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/40ants-pg/"
  :class :package-inferred-system
  :description "Provides documentation for 40ants-pg."
  :source-control (:git "https://github.com/40ants/40ants-pg")
  :bug-tracker "https://github.com/40ants/40ants-pg/issues"
  :pathname "docs"
  :depends-on ("40ants-pg"
               "40ants-pg-docs/index"))
