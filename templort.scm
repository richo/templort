(use srfi-1)
;; Renders template in the current execution environment

(define make-renderer
  (lambda (view-path)
    (let ((load-template (lambda (template-file) (read-file (string-append view-path "/" template-file)))))
      (lambda (view #!optional (locals '()))
        (let ((tpl (load-template view)))
          (template-eval tpl locals))))))

;; TODO Load these at boot time and check for validity

(define template-inline-subst
  (lambda (exp locals)
    (map (lambda (el)
           (if (list? el)
              (if (equal? (car el) (quote ->))
                (list 'quote (cdr (assoc (cadr el) locals)))
                (template-inline-subst el locals))
             el))
         exp)))

(define template-expand
  (lambda (el)
   (cond
     ((string? el)
      el)
     ((number? el)
      (number->string el))
     ((symbol? el)
      (symbol->string el))
     (else
       (display el)
       (error "Uncaught toplevel element")))))

;; Toplevel eval deals with string emitting valid markup, etc.
(define template-toplevel-eval
  (lambda (exp locals)
    (template-expand
      (cond
         ((string? exp)
          (string-append "\"" exp "\""))
         ((list? exp)
          (if (equal? (car exp) (quote ->))
            (cdr (assoc (cadr exp) locals))
            (eval (template-inline-subst exp locals))))
         (else
           exp)))))

(define (template-eval exp locals)
  (string-intersperse
    (map (lambda (el)
           (template-toplevel-eval el locals))
       exp)
    " "))
