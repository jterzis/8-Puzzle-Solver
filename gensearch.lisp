;algorithms to implement general uninformed search
;depth first search (lifo queue), bfs (fifo), uniform-cost search
;iterative deepening

;define node data structure which includes accessor functions implicit


;search strategies defined by order of node expansion on fringe (queue)

;(defun general-search (initial-state successorf goalp
 ;                       &key (enqueue #'enqueue-LIFO)
  ;                      (key #'identity));key dflts to returning itself 
;general initializes search by creating queue data structure setting
;fringe equal to queue, which was initialized with initial state node
;then it calls tree search with initial fringe, successor function, and goalp funct
  ;(let ((fringe (make-q :enqueue enqueue :key key)))
   ; (q-insert fringe (list (make-node :state initial-state)))
    ;(tree-search fringe successorf goalp)))

;tree search using tail recursion to search tree
;it takes a node out of queue (method depends on type of queue) 
;checks it against goal , if node is not goal 
;it expands successor nodes of node, inserts them into fringe queue (unexplored nodes)
;and calls tree search again
;each call to tree search removes at most 1 node from queue

;expand actually creates and initializes the elements of nodes in memory from the 
;(action,state,cost) tuples returned by a successor function
;it returns a list of successor nodes via mapcar


;EXPAND NODES WITHOUT CHECKING IF SUCCESSORS ARE ALREADY ON FRINGE 
(defun expand (successorf node expnode fringe heuristicf)
  (let ((triples (funcall successorf (node-state node) :heuristicf heuristicf) ))
        
  (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
              ))
             triples) )
   ) ;return value of expand is list of constructed successor nodes


;EXPAND2 checks if successors are already on fringe and discards if so 
(defun expand2 (successorf node expnode fringe heuristicf)
  (let ((triples (funcall successorf (node-state node) :heuristicf heuristicf) ))
        
    (let  ((triples3 '()) 
          |# (fringe2 (queue-copy fringe)) #|  )
      ;(print (cadr triples)) 
      (if (not (q-empty fringe)) (progn  
            (mapcar (lambda  (a) (if (equal (member (cadr a)     (coerce (q-elements fringe) 'list) 
                 :test #'equal :key #'node-state) nil)  (setf triples3 (append triples3 (list a)))   nil ))triples )  
    (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
              )) 
             triples3)) ;apply mapcar to returned list of tuples from successor func
  (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
              ))
             triples) )
    ) )) ;return value of expand is list of constructed successor nodes

;EXPAND3 checks if successors are already on closed and discards if so 
(defun expandf (successorf node expnode closed heuristicf)
  (let ((triples (funcall successorf (node-state node) :heuristicf heuristicf) ))
        
    (let  ((triples3 '()) )
       
           (if   (not (equal (length closed) nil))    ;if a successor is NOT in closed list, expand it and add to fringe 
              (progn (mapcar (lambda  (b) (if  (equal (member (cadr b)     closed
                 :test #'equal :key #'identity) nil)   (setf triples3 (append triples3 (list b)))   nil ))triples )
               ;expand nodes here
               ;(print triples3)
              (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
               )) 
              triples3))
             (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
               )) 
              triples) )

            
            
            ) ;apply mapcar to returned list of tuples from successor func
            
    ) ) ;return value of expand is list of constructed successor nodes


;EXPAND4 checks if successors are already on closed and fringe  and discards if so 
(defun expand4 (successorf node expnode closed fringe heuristicf)
  (let ((triples (funcall successorf (node-state node) :heuristicf heuristicf) ))
        
    (let  ((triples3 '()) )
        ;if fringe and closed are NOT empty 
       (cond   ( (and (not (equal (length closed) nil)) (not (equal (q-empty fringe) nil)))   ;if a successor is NOT in closed list or fringe , expand it and add to fringe 
               
                (progn (mapcar (lambda  (b) (if  (and (equal (member (cadr b)     closed
                 :test #'equal :key #'identity) nil) (equal (member (cadr b)     (coerce (q-elements fringe) 'list) 
                 :test #'equal :key #'node-state) nil))   (setf triples3 (append triples3 (list b)))   nil ))triples )
               ;expand nodes here
               ;(print triples3)
              (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
               )) 
              triples3)))

               ;if fringe is empty but closed is not empty 
               ( (and (not (equal (length closed) nil))  (equal (q-empty fringe) nil))     
                   (progn (mapcar (lambda  (b) (if  (equal (member (cadr b)     closed
                 :test #'equal :key #'identity) nil)   (setf triples3 (append triples3 (list b)))   nil ))triples )
               ;expand nodes here
               ;(print triples3)
              (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
               )) 
              triples3))  )

                ;if closed is empty but fringe is not empty 
               ((and  (equal (length closed) nil)  (not (equal (q-empty fringe) nil)))  
                 (progn (mapcar (lambda  (b) (if (equal (member (cadr b)     (coerce (q-elements fringe) 'list) 
                 :test #'equal :key #'node-state) nil)   (setf triples3 (append triples3 (list b)))   nil ))triples )
               ;expand nodes here
               ;(print triples3)
              (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
               )) 
              triples3)) )
               ;both fringe and closed are empty 
            (t 
             (mapcar (lambda (action-state-cost)
              (let ((action (car action-state-cost))
                    (state (cadr action-state-cost))
                    (cost (caddr action-state-cost)))
                   (make-node :state state                 ;create a node from ea. successor
                           :parent node
                           :action action
                           :g-cost (+ (node-g-cost node);parent path cost + step cost
                                         1)
                           :f-cost (+(+ (node-g-cost node)1)cost);f=g+h cost 
                           :depth (1+ (node-depth node))) 
               )) 
              triples) ) )
            ) ;apply mapcar to returned list of tuples from successor func
    ) ) ;return value of expand is list of constructed successor nodes





;action sequence. if were at goal this function iterates from goal to root printing
;list of sequence of actions that resulted in goal state, # steps to reach completed state, number of nodes expanded


(defun action-sequence (node expnode &optional (actions nil))
  (if (node-parent node)   ;if were not at root
     (action-sequence (node-parent node) expnode
                     (cons (node-action node) actions))  ;returns list of actions from start to goal
    (cons actions (cons (length actions) (cons expnode nil) ))    ;at end of recursion, return list
    ) )

;to avoid infinite loops in tree search we turn the problem into a graph search
;by adding a list of visited nodes that gets passed along through search algorithm
;and a predicate function samep that is used to compare 2 node states for equality
;in the builtin member function

(defun general-search (initial-state successorf goalp
                                     &key (samep #'eql)
                                     (enqueue #'enqueue-LIFO)
                                     (key #'identity))
  (let ((fringe (make-q :enqueue enqueue :key key)))
    (q-insert fringe (list (make-node :state initial-state)))
    (graph-search fringe nil successorf goalp samep expnode)
    ))


;5 parameters to graph-search versus 3 to tree search
;(member item list &key test key) applies item test to key(list) for each element of list and returns sublist if true , else nil
;in our case since were comparing node-state to node-state of each element of closed we need need to use eql or equal as samep predicate function
(defun graph-search (fringe closed successorf goalp samep expnode heuristicf)
  (unless (q-empty fringe)
    (let ((node (q-remove fringe)));unless frontier is empty, remove a node based on queueing
            ;(mapcar (lambda (a) (print (node-state a)) (print (node-f-cost a))) (coerce (q-elements fringe) 'list))
            ;(print (node-state node))
            ;(print (node-f-cost node));function and store in local var, node
    (cond        ((progn  (funcall goalp (node-state node)) );are we at goal node?
                 (progn  (action-sequence node expnode) ))
                 ((progn  (member (node-state node) closed;can remove the clause here in A* case, covered below
                 :test #'equal :key #'identity) ) ;is node-state part of visited list ?
                 (graph-search fringe closed successorf goalp samep expnode heuristicf) );if yes, call graph- search on rest of fringe
                 (t (progn (let ((success (expand2 successorf node expnode fringe heuristicf)));else, dflt case, expand successors
                 ;in A* case, test for whether expanded nodes are on fringe or closed list here and only add them to fringe
                 ;if they are not on either or if their cost is less, can return new list of successors using mapcar in this manner
                 (incf expnode (length success)) (graph-search (q-insert fringe success);add successors to frontier based on queueing funct and add node to
                               (cons (node-state node) closed);visited list all in recursive call to graph-search
                               successorf goalp samep expnode heuristicf)  )))
           ))))
