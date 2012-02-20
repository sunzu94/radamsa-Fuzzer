
;;;
;;; Shared Parameters and Functions
;;;

(define-library (rad shared)

   (import (owl base))

   (export
      max-block-size
      initial-ip
      remutate-probability
      selection->priority
      choose
      choose-pri
      car>
      )

   (begin
      (define max-block-size (* 8 1024)) ; average half of this
      (define initial-ip 24)             ; initial max 1/n for basic patterns
      (define remutate-probability 2/3)

      ;; (#t(name func short long) ...) name → func | #false
      (define (choose options name)
         (cond
            ((null? options) #false)
            ((equal? name (ref (car options) 1))
               (ref (car options) 2))
            (else
               (choose (cdr options) name))))

      (define (car> a b) 
         (> (car a) (car b)))

      (define (selection->priority lst)
         (let ((l (length lst)))
            (cond
               ((= l 2) ; (name pri-str)
                  (let ((pri (string->number (cadr lst) 10)))
                     (cond
                        ((not pri)
                           (print*-to (list "Bad priority: " (cadr lst)) stderr)
                           #false)
                        ((< pri 0) ;; allow 0 to set a fuzzer off
                           (print*-to (list "Inconceivable: " (cadr lst)) stderr)
                           #false)
                        (else
                           (cons (car lst) pri)))))
               ((= l 1)
                  (cons (car lst) 1))
               (else
                  (print*-to (list "Too many things: " lst) stderr)
                  #false))))
      ; ((p . a) ...) n → x
      (define (choose-pri l n)
         (let ((this (caar l)))
            (if (< n this)
               (cdar l)
               (choose-pri (cdr l) (- n this)))))
      
))
