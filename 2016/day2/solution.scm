(use-modules (ice-9 format)
             (srfi srfi-1)
             (srfi srfi-11))

(define p1-keypad '([1 2 3]
                    [4 5 6]
                    [7 8 9]))

(define move-to m

(define (find-on-keypad keypad coordinate)
  (fold (lambda (x prev) (list-ref prev x)) p1-keypad coordinate))
  

(define (move dir-char curr-place)
  (case dir-char
    [(#\U) (map + curr-place '(0   1))]
    [(#\D) (map + curr-place '(0  -1))]
    [(#\L) (map + curr-place '(1   0))]
    [(#\R) (map + curr-place '(-1  0))]))

(define (consume initial-coord args)
  (if (null? args)
      ""
      (let* ([current-row (car args)]
             [d (fold move initial-coord (string->list current-row))])
        (cons (find-on-keypad p1-keypad d)
              (consume d (cdr args))))))

(define (solve-pt1 input)
  (let ([input-rows (string-split input #\newline)]
        (fold (lambda (x prev) ) () intput-rows
       (fold move '(0 0) (string->list x)  )


(define sample-input  "ULL\nRRDDD\nLURDL\nUUUUD")

(let ([sample-output "1985"]
      [solution (solve-pt1 sample-input)])
    (if (not (equal? sample-output solution))
        (error (format #f "Got: ~s\nExpected: ~s" solution sample-output))))
