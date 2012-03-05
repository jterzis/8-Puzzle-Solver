
;implement successor function for 8 puzzle 
;
;node-state = '(0 1 2 3 4 5 6 7 8)
;returns all successors of node-state as list of tuples (action, state, cost)

;define a function that swaps two elements in a list

(defun swap (mylist indx1 indx2)
  
(let  ((tmp (elt mylist indx1)) );let creates a ptr to a variable not a copy ! 
  (setq newlist (copy-list mylist))
  (setf (elt newlist indx1) (elt newlist indx2))
  (setf (elt newlist indx2) tmp) newlist
  ))

;heuristic for misplaced nodes , returns last element of mapcar resultant list 
;works with no known issues 
(defun misplaced (node-state)
   (car(last (let ((cnt 0)) (mapcar (lambda (a)   
                        (if (not (equal a (elt node-state a))) (incf cnt))cnt ) '(0 1 2 3 4 5 6 7 8)
   )) ) ) ) 


;heuristic for manhattan distance .
(defstruct md tile xcord ycord)

(defun manhattan (node-state)
  ;generate list of md structs for goal state with corresponding x,y cords
  (let ((goalcoords  (mapcar (lambda (a) (make-md :tile a 
                               :xcord (cond ((<= a 2) a)
                                            ((and (> a 2) (<= a 5)) (- a 3))
                                            ((and (> a 5) (<= 8)) (- a 6))
                                            )
                               :ycord (cond ((<= a 2) 2)
                                            ((and (> a 2) (<= a 5)) 1)
                                            ((and (> a 5) (<= 8)) 0)
                                            )
                               )) '(0 1 2 3 4 5 6 7 8))) 
        (cnt -1))
       (apply '+ (mapcar (lambda (b) (incf cnt) 
                                (if (equal b 0) 0 (+ (abs (- (md-xcord (elt goalcoords b)) (md-xcord (elt goalcoords cnt)))) 
                                   (abs (- (md-ycord (elt goalcoords b)) (md-ycord (elt goalcoords cnt)))) ) )
                                
                 ) node-state) )  ;divide heuristic by 2 
    )
  )


;Gaschnig's Heuristic;  Locate position if Blank, X. If X does not contain its goal element, swap goal element with X.
;Otherwise, swap a misplaced tile with X. Repeat and take total number of moves. This heuristic dominates misplaced tiles.

(defun gaschnig (node-state)
  ;find position of the Blank
  (let ((cnt 0)
        (goal '(0 1 2 3 4 5 6 7 8))
        (x 0);location of tile to swap with blank
        (cntmoves 0))
    ;(loop for y in node-state do (if (equal y 0) (return cnt) (incf cnt) )) ;find position of blank
    ;while were not in goal state swap a tile depending on whether blank is in goal spot or not 
    (loop while (not (equal goal node-state)) do (incf cntmoves)
      (loop for z in node-state do (if (equal z 0) (return cnt) (incf cnt) )) ;find position of blank

          (cond ((not (equal cnt 0));if blank is not in its goal spot 
           (progn (setf node-state (swap node-state cnt (apply '+ (mapcar 
                    (lambda (a) (if (equal a (elt goal cnt))x (progn(incf x)0))) node-state)) ) );location of element that should be in space cnt 
            (setf x 0) (setf cnt 0)) )

           ((equal cnt 0) (progn (setf node-state (swap node-state cnt 
                                                        (loop for i in goal do (if (not(equal (elt node-state i) i)) (return i)0
                                                                        ))) )  (setf cnt 0)))
           )
       )cntmoves)
  );return count of moves made 


;Two tiles tj and tk are in linear conflict if tj and tk are in the same line , the goal positions of tj and tk are both in that line
;, tj is to the right of tk, and goal positoin of tj is to the left of the goal position of tk
(defun linearconflict (node-state)
   (let ((goal '(0 1 2 3 4 5 6 7 8))
        (lcost 0))
     (progn  (if (and (member (elt node-state 0) (subseq goal 0 3))  (member (elt node-state 1) (subseq goal 0 3)) 
                 (< (elt node-state 1) (elt node-state 0)))
                  (unless (or (equal (elt node-state 0) 0)(equal (elt node-state 1) 0)) (setf lcost (+ lcost 2)) ) )
           (if (and (member (elt node-state 1) (subseq goal 0 3))  (member (elt node-state 2) (subseq goal 0 3)) 
                 (< (elt node-state 2) (elt node-state 1)))
                  (unless (or (equal (elt node-state 1) 0)(equal (elt node-state 1) 2)) (setf lcost (+ lcost 2)) ) )
           (if (and (member (elt node-state 3) (subseq goal 3 6))  (member (elt node-state 4) (subseq goal 3 6)) 
                 (< (elt node-state 8) (elt node-state 4)))
                  (unless (or (equal (elt node-state 3) 0)(equal (elt node-state 4) 0)) (setf lcost (+ lcost 2)) ) )

           (if (and (member (elt node-state 4) (subseq goal 3 6))  (member (elt node-state 5) (subseq goal 3 6)) 
                 (< (elt node-state 5) (elt node-state 4)))
                  (unless (or (equal (elt node-state 4) 0)(equal (elt node-state 5) 0)) (setf lcost (+ lcost 2)) ) )

           (if (and (member (elt node-state 6) (subseq goal 6 9))  (member (elt node-state 7) (subseq goal 6 9)) 
                 (< (elt node-state 7) (elt node-state 6)))
                 (unless (or (equal (elt node-state 6) 0)(equal (elt node-state 1) 7)) (setf lcost (+ lcost 2)) ))

           (if (and (member (elt node-state 7) (subseq goal 6 9))  (member (elt node-state 8) (subseq goal 6 9)) 
                 (< (elt node-state 8) (elt node-state 7)))
                  (unless (or (equal (elt node-state 7) 0)(equal (elt node-state 8) 0)) (setf lcost (+ lcost 2)) ) )
           )
     lcost)
   )




;set dominant heuristic equal to max of gaschnig , misplaced, and manhattan 
(defun extracredit2 (node-state)
  (let ((maximum  (max (gaschnig node-state)
  (manhattan node-state)
   ) )) maximum )
   )

;set the dominant heuristic to equal manhattan+linear conflict
(defun extracredit (node-state)
  (let ((x (+ (manhattan node-state) (linearconflict node-state))) ) 
    x)
  )

;create random solvable state generator. note that a solvable state is one where the pair of adjacent
;positions to the blank are in order 
(defun random-case ()
  (let ((q 1))
    (loop while (equal q 1) do 
            (setf q 0)
          (let ((rstate '())
        ( relm (random 9) ) 
        (z 0)
        (invers 0))
     (loop for i in '(0 1 2 3 4 5 6 7 8) do (loop while (not (equal (member relm  rstate :test #'equal :key #'identity) nil)) 
                                                  do  (setf relm (random 9))  ) 
           (setf rstate  (append rstate (list relm)) )) ;while the random number is  already in the list, keep generating random numbers
    ;check that number of inversions in random state is even
   (if (evenp (car (last (mapcar (lambda (a) (let ((m z)) 
                             (loop while (< m 9) do (if (< (elt rstate m)a) (incf invers) ) (incf m)) (incf z) )  invers)rstate)) )) 
      rstate
     (setf q 1)
    )
 (unless (equal q 1) (return rstate)) ) ) ) )


(defun find-best (&key (h1 #'manhattan) (h2 #'extracredit) ) 
  ( let ((rcase (random-case)))
    (loop while (< (car (last (8-puzzle rcase h1))) (car (last (8-puzzle rcase h2))) ) do (setf rcase (random-case)))
 (return   (8-puzzle rcase h1) (8-puzzle rcase h1) )

  )

  
  )


;return (action, state, cost) tuples corresponding to successors of a state
;given a heursistic and current state. Successorf creates 2-4 successors per state. 
(defun successorf (n-state &key (heuristicf #'misplaced) )
  (cond 
    ((eql (elt n-state 0) 0) (list (list "right" (swap n-state 0 1) (funcall heuristicf  (swap n-state 0 1)) ) 
                             (list "down" (swap n-state 0 3) (funcall heuristicf (swap n-state 0 3) ) ) ) )  
     ((eql (elt n-state 1) 0) (list (list "left" (swap n-state 0 1) (funcall heuristicf  (swap n-state 0 1)) ) 
                             (list "down" (swap n-state 1 4) (funcall heuristicf (swap n-state 1 4) ) ) 
                            (list "right" (swap n-state 1 2) (funcall heuristicf (swap n-state 1 2) ) )   ) )  
     ((eql (elt n-state 2) 0) (list (list "left" (swap n-state 2 1) (funcall heuristicf  (swap n-state 2 1)) ) 
                             (list "down" (swap n-state 2 5) (funcall heuristicf (swap n-state 2 5) ) ) ) )  
     ((eql (elt n-state 3) 0) (list (list "right" (swap n-state 3 4) (funcall heuristicf  (swap n-state 3 4)) ) 
                             (list "up" (swap n-state 3 0) (funcall heuristicf (swap n-state 3 0) ) ) 
                             (list "down" (swap n-state 3 6) (funcall heuristicf (swap n-state 3 6) ) )  ) )  

     ((eql (elt n-state 4) 0) (list (list "right" (swap n-state 4 5) (funcall heuristicf  (swap n-state 4 5)) ) 
                             (list "down" (swap n-state 4 7) (funcall heuristicf (swap n-state 4 7) ) ) 
                             (list "left" (swap n-state 4 3) (funcall heuristicf (swap n-state 4 3) ) ) 
                            (list "up" (swap n-state 4 1) (funcall heuristicf (swap n-state 4 1) ) ) ) )  
     ((eql (elt n-state 5) 0) (list (list "up" (swap n-state 5 2) (funcall heuristicf  (swap n-state 5 2)) ) 
                             (list "left" (swap n-state 5 4) (funcall heuristicf (swap n-state 5 4) ) ) 
                             (list "down" (swap n-state 5 8) (funcall heuristicf (swap n-state 5 8) ) ) ) )  
     ((eql (elt n-state 6) 0) (list (list "up" (swap n-state 6 3) (funcall heuristicf  (swap n-state 6 3)) ) 
                             (list "right" (swap n-state 6 7) (funcall heuristicf (swap n-state 6 7) ) ) ) )  
     ((eql (elt n-state 7) 0) (list (list "up" (swap n-state 7 4) (funcall heuristicf  (swap n-state 7 4)) ) 
                             (list "right" (swap n-state 7 8) (funcall heuristicf (swap n-state 7 8) ) ) 
                             (list "left" (swap n-state 7 6) (funcall heuristicf (swap n-state 7 6) ) ) ) )  
     ((eql (elt n-state 8) 0) (list (list "left" (swap n-state 8 7) (funcall heuristicf  (swap n-state 8 7)) ) 
                             (list "up" (swap n-state 8 5) (funcall heuristicf (swap n-state 8 5) ) ) ) )  
    
    ) 
  
  ) 



