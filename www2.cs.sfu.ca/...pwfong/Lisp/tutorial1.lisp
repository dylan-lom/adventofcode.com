;;; testing.lisp
;;;
;;; Introductory comments are preceded by ";;;"
;;; Function headers are preceded by ";;"
;;; Inline comments are introduced by ";"
;;;

;;
;; Triple the value of a number
;;
(defun triple (X)
  "Compute 3 times X." ; Inline comment can
  (* 3 x))             ; be placed here.

;;
;; Negate the sign of a number
;;
(defun negate (X)
  "Negate the value of X." ; This is a documentation string.
  (- X))

;;
;; Compute the factorial of a number
;;
(defun factorial (X)
  "Compute the factorial of X"
  (if (= X 1)
  	1
    (* X (factorial (- X 1)))))

;;
;; Find a particular triangular number
;;
(defun triangular (N)
  "Find the N'th triangular number."
  (if (<= N 1)
	1
	(+ N (triangular (- N 1)))))

;;
;; Find the value of a number to a power
;;
(defun power (B E)
  "Compute B to the power of E."
  (if (= E 0)
	1
	(* B (power B (- E 1)))))

;; Find a particular fibonnaci number
(defun fibonacci (N)
  "Compute the N'th fibonacci number."
  (if (<= N 1)
	1
	(+ (fibonacci (- N 1)) (fibonacci (- N 2)))))

(defun fibonacci2 (N)
  (if (<= N 1)
	1
	(let
	  	((F1 (fibonacci2 (- N 1)))
		 (F2 (fibonacci2 (- N 2))))
	(+ F1 F2))))

;; Find the binomial coeffecient
(defun bc (N R)
  "Find the binomial coeffecient of N & R i guess..."
  (if (or (= R 0) (= R N))
	1
	(+ (bc (1- N) (1- R)) (bc (1- N) R))))

;; Determine length of a list
(defun list-length1 (L)
  "Determine the length of L"
  (if (null L)
  	0
	(1+ (list-length1 (rest L)))))

;; Calculate the sum of a list
(defun sum (L)
  "Calculate the sum of L"
  (if (null L)
	0
	(+ (first L) (sum (rest L)))))

;; Get a certain element in a list
(defun nth1 (N L)
  "Get the Nth element of L"
  (cond
	((null L)  nil)
	((zerop N) (first L))
	(T         (nth1 (1- N) (rest L)))))
;   (if (null L)
; 	nil
; 	(if (= N 0)
; 	  (first L)
; 	  (nth1 (1- N) (rest L)))))

;; Get the last element in a list
(defun last1 (L)
  "Get the last element of L"
  (if (null L)
	nil
	(if (null (rest L))
	  (first L)
	  (last1 (rest L)))))

(defun member1 (E L)
  "Test if E is a member of L."
  (cond
	((null L)            nil)
	((equal E (first L)) T)
	(T                   (member1 E (rest L)))))

(defun append1 (L1 L2)
  "Append L2 to L1"
  (if (null L1)
	L2
	(cons (first L1) (append1 (rest L1) L2))))

(defun butLast1 (L)
  (if (or (null L) (null (rest L)))
	nil
	(cons (first L) (butLast1 (rest L)))))

(defun list-intersection (L1 L2)
  "Return a list containing elements belonging to both L1 and L2."
  (cond
	((null L1)              nil)
	((member (first L1) L2) (cons (first L1) (list-intersection (rest L1) L2)))
	(t                      (list-intersection (rest L1) L2))))

(defun list-union (L1 L2)
  "Return a list containing elements belonging to either L1 or L2."
  (cond
	((null L1)              L2)
	((member (first L1) L2) (list-union (rest L1) L2))
	(t                      (cons (first L1) (list-union (rest L1) L2)))))
 
(defun list-difference (L1 L2)
  "Return a list containing elements belonging to L1 but not L2."
  (cond
	((null L1)               nil)
	((member (first L1) L2)  (list-difference (rest L1) L2))
	(t                       (cons (first L1) (list-difference (rest L1) L2)))))
