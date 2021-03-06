;;;; get-stock-info.lisp

(in-package #:cl-stocks)

(defun get-stock-prices (ticker start end)
  (let* ((result nil)
         (yahoo-data (cl-yahoo-finance:read-historical-data ticker start end :historical-type :daily))
         (current-stock-price (make-instance 'stock-price))
         (date-col (position "Date" (first yahoo-data) :test #'string-equal))
         (open-col (position "Open" (first yahoo-data) :test #'string-equal))
         (close-col (position "Close" (first yahoo-data) :test #'string-equal))
         (two-hundred-sma (simple-moving-average 200)))
    (dolist (row (rest yahoo-data) (add-52w-numbers result))
      (psetf (stock-price-date current-stock-price) (parse-date (nth date-col row))
             (stock-price-open current-stock-price) (rationalize (nth open-col row))
             (stock-price-close current-stock-price) (rationalize (nth close-col row)))
      (setf (stock-price-sma current-stock-price) (funcall two-hundred-sma (stock-price-close current-stock-price)))
      (push current-stock-price result)
      (setf current-stock-price (make-instance 'stock-price)))))

(defun get-stock-divs (ticker start end)
  (let* ((result nil)
         (yahoo-data (cl-yahoo-finance:read-historical-data ticker start end :historical-type :dividends_only))
         (date-col (position "Date" (first yahoo-data) :test #'string-equal))
         (div-col (position "Dividends" (first yahoo-data) :test #'string-equal))
         (current-stock-div (make-instance 'stock-div)))
    (dolist (row (rest yahoo-data) result)
      (psetf (stock-div-date current-stock-div) (parse-date (nth date-col row))
             (stock-div-div current-stock-div) (rationalize (nth div-col row)))
      (push current-stock-div result)
      (setf current-stock-div (make-instance 'stock-div)))))

(defun get-stock-splits (ticker start end)
  (let* ((result nil)
         (yahoo-data (cl-yahoo-finance:read-historical-splits ticker start end))
         (date-col (position "Date" (first yahoo-data) :test #'string-equal))
         (split-col (position "Split" (first yahoo-data) :test #'string-equal))
         (current-stock-split (make-instance 'stock-split)))
    (dolist (row (rest yahoo-data) result)
      (psetf (stock-split-date current-stock-split) (parse-date (nth date-col row))
             (stock-split-factor current-stock-split) (nth split-col row))
      (push current-stock-split result)
      (setf current-stock-split (make-instance 'stock-split)))))

(defun get-stock-info (ticker start end)
  (values (get-stock-prices ticker start end)
          (get-stock-divs ticker start end)
          (get-stock-splits ticker start end)))
