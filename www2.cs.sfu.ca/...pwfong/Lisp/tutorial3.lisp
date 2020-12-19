;;; Data Abstraction

;;
;; Binary Trees
;;

;;
;; Constructors
;;
(defun make-bin-tree-leaf (L)
  "Create a leaf."
  (list L))

(defun make-bin-tree-node (E B1 B2)
  "Create a node with element E, left subtree B1 and right subtree B2."
  (list E B1 B2))

;;
;; Selectors
;;
(defun bin-tree-leaf-element (L)
  "Retrieve the element of leaf L."
  (first L))

(defun bin-tree-node-element (N)
  "Retrieve the element of node N."
  (first N))

(defun bin-tree-node-left (N)
  "Retrieve the left subtree of node N."
  (second N))

(defun bin-tree-node-right (N)
  "Retrieve the right subtree of node N."
  (third N))

;;
;; Recognizers
;;
(defun bin-tree-leaf-p (B)
  "Test if binary tree B is a leaf."
  (and (listp B) (= 1 (list-length B))))

(defun bin-tree-node-p (B)
  "Test if binary tree B is a node."
  (and (listp B) (= 3 (list-length B))))

;;
;; Other things
;;
(defun bin-tree-member-p (B E)
  "Test if element E is in binary tree B."
  (if (bin-tree-leaf-p B)
	(equal E (bin-tree-leaf-element B))
	(let
	  ((elmt (bin-tree-node-element B))
	   (left (bin-tree-node-left    B))
	   (rght (bin-tree-node-right   B)))
	  (or (equal E elmt)
		  (bin-tree-member-p left E)
		  (bin-tree-member-p rght E)))))

;; 1. B is a leaf and is the end of a branch
;; 2. B is a node
;;  2a. Evaluate the left and right subtrees of B until a leaf is hit
(defun size (B)
  "Calculate the number of elements in binary tree B."
  (if (bin-tree-leaf-p B)
	1
	(let
	  ((left (bin-tree-node-left   B))
	   (right (bin-tree-node-right B)))
	  (+ 1 (size left) (size right)))))

;; 1. B is a leaf
;;  - The reverse of B is itself.
;; 2. B is a node
;;  - The node element remains unchanged
;;  - The new left branch is the reversal of the original right branch.
;;  - The new right branch is the reversal of the original left branch.
(defun bin-tree-reverse (B)
  "Reverse binary tree B."
  (if (bin-tree-leaf-p B)
    B
    (let
      ((elmt  (bin-tree-node-element B))
       (left  (bin-tree-node-left    B))
       (right (bin-tree-node-right   B)))
      (make-bin-tree-node elmt
                          (bin-tree-reverse right)
                          (bin-tree-reverse left)))))

;;; Traversal
(defun bin-tree-preorder (B)
  "Create a list containing keys of B in preorder."
  (if (bin-tree-leaf-p B)
    (list (bin-tree-leaf-element B))
    (let
      ((elmt  (bin-tree-node-element B))
       (left  (bin-tree-node-left    B))
       (right (bin-tree-node-right   B)))
      (cons elmt
            (append (bin-tree-preorder left)
                    (bin-tree-preorder right))))))

(defun fast-bin-tree-preorder (B)
  (fast-bin-tree-preorder-aux B nil))

(defun fast-bin-tree-preorder-aux (B L)
  (if (bin-tree-leaf-p B)
    (cons (bin-tree-leaf-element B) L)
    (let
     ((elmt  (bin-tree-node-element B))
      (left  (bin-tree-node-left    B))
      (right (bin-tree-node-right   B)))
     (cons elmt
           (fast-bin-tree-preorder-aux left
                                       (fast-bin-tree-preorder-aux right L))))))

(defun bin-tree-postorder (B)
  (if (bin-tree-leaf-p B)
    (list (bin-tree-leaf-element B))
    (let
      ((elmt  (bin-tree-node-element B))
       (left  (bin-tree-node-left    B))
       (right (bin-tree-node-right   B)))
      (append (bin-tree-postorder left)
              (bin-tree-postorder right)
              (cons elmt nil)))))

(defun fast-bin-tree-postorder (B)
  (fast-bin-tree-postorder-aux B nil))

(defun fast-bin-tree-postorder-aux (B L)
  (if (bin-tree-leaf-p B)
    (cons (bin-tree-leaf-element B) L)
    (let
      ((elmt  (bin-tree-node-element B))
       (left  (bin-tree-node-left    B))
       (right (bin-tree-node-right   B)))
      (fast-bin-tree-postorder-aux left
                                   (fast-bin-tree-postorder-aux right
                                                                (cons elmt L))))))

(defun bin-tree-inorder (B)
  (if (bin-tree-leaf-p B)
    (list (bin-tree-leaf-element B))
    (let
     ((elmt  (bin-tree-node-element b))
      (left  (bin-tree-node-left    b))
      (right (bin-tree-node-right   b)))
     (append (bin-tree-inorder left)
             (cons elmt nil)
             (bin-tree-inorder right)))))

(defun fast-bin-tree-inorder (B)
  (inorder-aux B nil))

; TODO: I'm not confident in how to tell this is actually tail-recursive --
; revisit definitions/early examples!
(defun inorder-aux (B L)
  (if (bin-tree-leaf-p B)
    (cons (bin-tree-leaf-element B) L)
    (let
     ((elmt  (bin-tree-node-element b))
      (left  (bin-tree-node-left    b))
      (right (bin-tree-node-right   b)))
     (inorder-aux left
                  (cons elmt (inorder-aux right L))))))

;; 
;; Abstract Data Types
;;

;; Sets
(defun make-empty-set ()
  "Creates an empty set."
  nil)

; :test is an &key parameter
(defun set-insert (S E)
  "Return a set containing all members of S plus the element E."
  (adjoin E S :test #'equal))

(defun set-remove (S E)
  "Return a set containing all the members of S except for the element E."
  (remove E S :test #'equal))

(defun set-member-p (S E)
  "Return non-NIL if set S contains element E."
  (member E S :test #'equal))

(defun set-empty-p (S)
  "Return T if set S is empty."
  (null S))

; Without using equal, we can't make sets of strings, etc.
(defun set-insert-no-test (S E)
  (adjoin E S))

;;
;; Binary Search Trees
;;
(defun make-empty-BST ()
  "Return an empty BST."
  nil)

(defun BST-empty-p (B)
  "Check is BST B is empty."
  (null B))

; This assumes that all nodes of B are also nonempty which idk if is ok...
(defun BST-member-p (B E)
  "Check if E is a member of BST B."
  (if (BST-empty-p B)
    nil
    (BST-nonempty-member-p B E)))

(defun BST-nonempty-member-p (B E)
  "Check if E is a member of non-empty BST B."
  (if (bin-tree-leaf-p B)
    (= E (bin-tree-leaf-element B))
    (if (<= E (bin-tree-node-element B))
      (BST-nonempty-member-p (bin-tree-node-left  B) E)
      (BST-nonempty-member-p (bin-tree-node-right B) E))))

(defun BST-insert (B E)
  "Insert E into BST B."
  (if (BST-empty-p B)
    (make-bin-tree-leaf E)
    (BST-nonempty-insert B E)))

(defun BST-nonempty-insert (B E)
  "Insert E into non-empty BST B."
  (if (bin-tree-leaf-p B)
    (BST-leaf-insert B E)
    (let ((elmt  (bin-tree-node-element B))
          (left  (bin-tree-node-left    B))
          (right (bin-tree-node-right   B)))
      (if (<= E elmt)
        (make-bin-tree-node elmt
                            (BST-nonempty-insert left E)
                            right)
        (make-bin-tree-node elmt
                            left
                            (BST-nonempty-insert right E))))))

(defun BST-leaf-insert (L E)
  "Insert element E into BST leaf L."
  (let ((elmt (bin-tree-leaf-element L)))
    (cond
      ((= E elmt) L)
      ((< E elmt) (make-bin-tree-node E
                                      (make-bin-tree-leaf E)
                                      (make-bin-tree-leaf elmt)))
      ((T)        (make-bin-tree-node E
                                      (make-bin-tree-leaf elmt)
                                      (make-bin-tree-leaf E))))))

(defun BST-remove (B E)
  "Remove element E from BST B."
  (if (BST-empty-p B)
    B
    (if (bin-tree-leaf-p B)
      (BST-leaf-remove B E)
      (BST-node-remove B E))))

(defun BST-leaf-remove (L E)
  "Remove element E from BST leaf L."
  (if (= E (bin-tree-leaf-element L))
    (make-empty-BST)
    L))

(defun BST-node-remove (N E)
  "Remove element E from BST node N."
  (let ((elmt  (bin-tree-node-element N))
        (left  (bin-tree-node-left    N))
        (right (bin-tree-node-right   N)))
    (if (<= E elmt)
      ; I'm not sure why we don't use BST-leaf-remove?
      (if (bin-tree-leaf-p left)
        (if (= E (bin-tree-leaf-element left))
          right
          N)
        (make-bin-tree-node elmt (BST-node-remove left E) right))
      (if (bin-tree-leaf-p right)
        (if (= E (bin-tree-leaf-element right))
          left
          N)
        (make-bin-tree-node elmt left (BST-node-remove right E))))))
