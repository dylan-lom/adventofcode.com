;;;
;;; Advanced Functional Programming in LISP
;;; ========================================================
;;; Tail Recursions, Higher-Order Functions, Multiple Values
;;;

(defun list-append (L1 L2)
  "Append L1 by L2."
  (if (null L1)
      L2
    (cons (first L1) (list-append (rest L1) L2))))

;; Reverse a list
;; This is slow because we call the recursive function list-append recursively,
;; and since the size of the list passed to list-append grows as L shrinks it's
;; bad or something... O(n^2) apparently...
(defun slow-list-reverse (L)
  "Return a list containing the elements of L in reversed order."
  (if (null L)
	nil
	(list-append (slow-list-reverse (rest L))
			(list (first L)))))

(defun list-reverse (L)
  "Return a list containing the elements of L in reversed order."
  (list-reverse-aux L nil))

(defun list-reverse-aux (L A)
  "Append list A to the reversal of list L."
  (if (null L)
	A
	(list-reverse-aux (rest L) (cons (first L) A))))

;; Calculate the factorial of a number
(defun fast-factorial (N)
  "A tail-recursive version of factorial."
  (fast-factorial-aux N 1))

(defun fast-factorial-aux (N A)
  (if (= N 1)
  	A
	(fast-factorial-aux (1- N) (* N A))))

(defun slow-triangular (N)
  "Calculate the N'th triangular number."
  (if (zerop N)
	0
	(+ N (slow-triangular (1- N)))))

(defun fast-triangular (N)
  "Calculate the N'th triangular number (with tail recursion)."
  (fast-triangular-aux N 0))

(defun fast-triangular-aux (N S)
  (if (zerop N)
  	S
	(fast-triangular-aux (1- N) (+ N S))))

(defun fast-power (B E)
  "Compute B to the power of E (with tail recursion)."
  (fast-power-aux B E 1))

(defun fast-power-aux (B E S)
  (if (zerop E)
	S
	(fast-power-aux B (1- E) (* S B))))

(defun fast-list-length (L)
  "Calculate the length of L (with tail recursion)."
  (fast-list-length-aux L 0))

(defun fast-list-length-aux (L S)
  (if (null L)
	S
	(fast-list-length-aux (rest L) (1+ S))))

;; -----------------------------------------
;; SECTION: Functions as First-Class Objects

(defun double (X)
  (* 2 X))

(defun repeat-transformation (F N X)
  "Apply function F on object X, N times."
  (if (zerop N)
	X
	(repeat-transformation F (1- N) (funcall F X))))

; (first (repeat-transformation (function rest) 6 '(a b c d e f g h i j)))
; (first (repeat-transformation #'rest 6 '(a b c d e f g h i j)))
; (repeat-transformation #'(lambda (L) (cons 'blah L)) 10 nil)

(defun apply-func-list (L X)
  "Apply each function in L to X, in reverse order."
  ; (apply-func-list (list #'double #'list-length #'rest) '(1 2 3))
  ; (double (list-length (rest '(1 2 3))))
  (if (null L)
	X
	(funcall (first L) (apply-func-list (rest L) X))))

(apply-func-list (list #'(lambda (X) (* X 10)) #'fourth) '(10 20 30 40 50))
(apply-func-list (list #'third #'second) '((1 2) (3 4 5) (6)))
(apply-func-list (list #'(lambda (X) (- 10 X)) #'list-length) '(a b c d e f))
(apply-func-list (list #'list #'list) 'blah)

;; mapcar
(defun mapfirst (F L)
  "Apply function F to every element of list L, and return a list containing the results."
  (if (null L)
	nil
	(cons (funcall F (first L)) (mapfirst F (rest L)))))

(defun find-not-null (L)
  "Find a non-empty/non-null member of L."
  (if (null L)
	nil
    (if (null (first L))
	  (find-not-null (rest L))
	  (first L))))

(defun find-list-if (P L)
  "Find the first element of L that satisfies P."
  (if (null L)
	nil
	(if (funcall P (first L))
	  (first L)
	  (find-list-if P (rest L)))))

(find-if #'(lambda (L) (<= 3 (list-length L))) '(() (1) (1 2) (1 2 3)))
(find-if #'(lambda (L) (evenp (list-length L))) '((1) (1 2 3) (1 2 3 4)))
(find-if #'(lambda (X) (zerop (mod X 3))) '(1 2 4 9))

(defun remove-list-if (P L)
  "Filter L down to elements that don't satisfy P."
  (remove-list-if-aux P L nil))

(defun remove-list-if-aux (P L N)
  (if (null L)
	(reverse N)
	(if (funcall P (first L))
	  (remove-list-if-aux P (rest L) N)
	  (remove-list-if-aux P (rest L) (cons (first L) N)))))

; I'm not sure if this is actually correct, as we don't get any elements that are in L2 but not in L1?
; This is the implementation the textbook has though... It's also how we implemented it in tut1 so I
; guess I just don't know the definition of difference?
(defun list-difference (L1 L2)
  "Compute the difference of L1 and L2."
  (remove-if #'(lambda (X) (member X L2)) L1))

(defun list-intersection (L1 L2)
  (remove-if-not #'(lambda (X) (member X L2)) L1))

(defun list-min-max (L)
  (list-min-max-aux (rest L) (first L) (first L)))

(defun list-min-max-aux (L mi ma)
  (if (null L)
	(values mi ma)
	(list-min-max-aux (rest L)
					  (min (first L) mi)
					  (max (first L) ma))))
