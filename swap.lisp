;define a function that swaps two elements in a list

(defun swap (mylist indx1 indx2)
(let  ((tmp (elt mylist indx1)))
  (setf (elt mylist indx1) (elt mylist indx2))
  (setf (elt mylist indx2) tmp) mylist
  ))
