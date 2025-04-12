(use-modules (rnrs bytevectors)
             (rnrs bytevectors gnu)
             (gcrypt hash)
             (gcrypt base16))


(define (str->md5 str)
 (bytevector->base16-string (md5 (string->utf8 str))))

(define (five-zeros-prefix? md5)
  (string-every #\0 md5 0 6))

(define (main input-str)
  (define finished? #f)
  (do ((i 1 (1+ i)))
      ((equal? finished? #t))
    (let* ([num-str    (number->string i)]
           [hash-input (string-concatenate (list input-str num-str))]
           [hash       (str->md5 hash-input)])
      (when (five-zeros-prefix? hash)
        (set! finished? #t)
        (display (string-concatenate `["found " ,hash-input " = " ,hash "\n"])))
      (when (zero? (modulo i 10000))
        (display (string-concatenate `["done " ,num-str " iterations\n"]))))))

(main "ckczppom")
