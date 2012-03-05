(defun make-node (&key state (parent nil)(action nil)
                              (path-cost 0)(depth 0))
  (list state parent action path-cost depth))

(defun node-state (node) (car node))
(defun node-parent (node) (cadr node))

(load "swap.lisp")











