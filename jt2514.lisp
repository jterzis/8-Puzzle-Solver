;main source file for hw2 8 puzzle search. 
;implements data structures for 1) node 2) priority queue
;implements 3) general search function 4) graph search function
;calls 5) succesor function 6) random initial state generator 7) heuristic functions
(load "queue.lisp")
;for initial - state , call misplaced function to initialize g&h-cost 
(load "successor.lisp")
(load "gensearch.lisp")
(load "node.lisp")
;8-puzzle is the wrapper function that 1) initializes fringe queue
;2) creates a node out of initial state and places in fringe
;3) calls graph search on initial node and heuristicf 

(defun 8-puzzle (initial-state heuristicf)
 (let ((fringe (make-q :enqueue #'enqueue-priority :key #'node-f-cost)));note: struct accessors are functions
   (setq expnode 0) ;initialize list of expanded nodes
   (q-insert fringe (list (make-node :state initial-state :f-cost (funcall heuristicf initial-state))));init fringe 
   (graph-search fringe nil #'successorf #'goalp #'samep expnode heuristicf);call general graph search
   )
 )



(defun find-best (&key (h1 #'manhattan) (h2 #'extracredit) ) 
  ( let ((rcase (random-case)))
    (loop while (> (car (last (8-puzzle rcase h1))) (car (last (8-puzzle rcase h2))) ) do (print rcase) (setf rcase (random-case)))
 (8-puzzle rcase h1)


  )

  
  )

