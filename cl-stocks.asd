;;;; cl-stocks.asd

(asdf:defsystem #:cl-stocks
  :serial t
  :depends-on (#:cl-yahoo-finance
               #:group-by
               #:cl-utilities)
  :components ((:file "package")
               (:file "date")
               (:file "sma")
               (:file "transaction")
               (:file "stock-position")
               (:file "stock-price")
               (:file "parse-fns")
               (:file "get-stock-info")
               (:file "stock-yield")
               (:file "strategies")
               (:file "scenarios")
               (:file "portfolio-mgmt")
               (:file "cl-stocks"))
  :name "cl-stocks"
  :version "0.1.0"
  :maintainer "Chris Howey"
  :author "Chris Howey"
  :license "ISC"
  :description "Test stock purchasing strategies")

