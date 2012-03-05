;define node data structure and ancillary functions
;such as goalp (test if a node-state is the goal for 8 puzzle)
;and samep (test if two node-states are the same)
;all 3 functions work without known issues

;when constructing, arguments are keyword args
(defstruct node state (parent nil) (action nil) (g-cost 0) (f-cost 0)(depth 0))

;is node state the goal state ? 
(defun goalp (node-state) (if (eql(misplaced node-state ) 0)t)) 
;are 2 node's node states equal ?
(defun samep (a b) (equal (node-state a) (node-state b)))

