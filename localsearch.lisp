;hill climbing - an example of local 'greedy' search

(defun hill-climb (state successorf evalf);evalf takes a state (configuration) and returns 
                                            ;objective value or cost if goal is minimization
                                            ;successorf takes a state and returns neighbors
  (let ((next (best (funcall successorf state) state evalf)))
     (if (eql state next)
       state 
       (hill-climb next successorf evalf)
       )))


;return state that maximizes some function evalf btwn neighbors and current state
(defun best (neighbors state evalf)
  (select-max
    (make-node :value (funcall evalf state) :state state)
    (mapcar (lambda (s) (make-node :value (funcall evalf s) :state s))
            neighbors))
  )

;finding max node value (integer) using built in predicates, cond, and recursion
;takes in args; current node and list of neighbor nodes
(defun select-max (best-so-far rest)
  (cond 
    ((null rest) (node-state best-so-far));if there are no neighbors, return node-state of current state
    ((> (node-value best-so-far) (node-value (car rest)));if current node value>car rest node values, 
     (select-max best-so-far (cdr rest)));try current node val on rest of rest
     (t (select-max (car rest)(cdr rest)));else , current node val < car rest so find max from within rest
     ))

