;queue data structure implemented as a struct
;enqueue is a function name
;key is a function name used in priority queue to calc cost of each item (ie node) 
;for purposes of adding into priority queue 
;so a key function for a node would take 1 arg: a node. 
;return f(n)=g(n)+h(n) in the case of A* best first search
;to make key's job easy, store f as another attribute for each node struct so key 
;just accesses that element of node and returns it 
;actual queue of nodes adt stored as a list or array defined heap  in elements

;priority queue works without any known issues 

(defstruct q (enqueue #'enqueue-FIFO)
            (key #'identity)
            (last nil)
            (elements nil))


(defun q-empty (q) 
  "returns T if queue is empty"
  (= (length (q-elements q)) 0))


(defun q-front (q) 
  ;"returns the element at the front of the queue"
  ;"prints an error if queue is empty"
(elt (q-elements q) 0)
)


;(elt x n) works for both lists and arrays

(defun q-remove (q)
  "removes elements at front of queue"
  (if (listp (q-elements q))
    (pop (q-elements q))
    (heap-pop (q-elements q) (q-key q))))

;(pop x) alters x by removing the car
;then returns the item removed 

(defun q-insert (q items)
  ;"inserts the items into the queue according to the queue's
  ;enqueuing function. Returns the altered queue"
  ;"treats list item as one unit when inserting"
  (funcall (q-enqueue q) q items)
  q)

"remember funcall calls its first argument on the rest"

;the three enqueueing fusnctions LIFO, FIFO, PRIORITY
;(nconc x y) is destructive version of (append xy)

(defun enqueue-LIFO (q items)
  "adds a list of items to the front of the queue"
  (setf (q-elements q) (nconc items (q-elements q)))
  items)

(defun enqueue-FIFO (q items)
  "adds a list of items to the end of the queue"
  (if (q-emptyp q)
    (setf (q-elements q) items)
    (setf (cdr (q-last q)) items))  ;else set 1 past last item in q to items
  (setf (q-last q) (last items))   ;always set q-last pointer to point to last item in queue
  items) ;returns list of items in queue


(defun enqueue-priority (q items)
  "Inserts the items by priority of key values"
  (when (null (q-elements q))
    (setf (q-elements q) (make-heap)));if q-elements is empty, create heap
  (mapc (lambda (item) ;apply heap-insert to each item in items list
          (heap-insert (q-elements q) item (q-key q)))
        items);note, heap insert takes key function of queue struct as arg 
  items)

;heap specific functions 



;heap implemented as dynamic array in memory
(defun make-heap (&optional (size 100))
  (make-array size :fill-pointer 0 :adjustable t))


(defun heap-val (heap i key) (funcall key (elt heap i)))
(defun heap-parent (i) (floor (1- i) 2))
(defun heap-left (i) (+ 1 i i))
(defun heap-right (i) (+ 2 i i))
(defun heap-leafp (heap i) (> i (1- (floor (length heap) 2))))

(defun heapify (heap i key)
  ;assume that the children of i are heaps, but that heap[i] may be larger than 
  ;its children. if it is , move heap[i] down
  (unless (heap-leafp heap i)
    (let ((left-index (heap-left i))
          (right-index (heap-right i)))
      (let ((smaller-index
              (if (and (< right-index (length heap))
                       (<(heap-val heap right-index key)
                         (heap-val heap left-index key)))
                right-index 
                left-index)))
        (when (> (heap-val heap i key)
                 (heap-val heap smaller-index key))
          (rotatef (elt heap i)
                   (elt heap smaller-index))
          (heapify heap smaller-index key))))
     ))



(defun heap-pop (heap key)
  ;pops the lowest valued item off the heap
  (let ((min (elt heap 0)))
    (setf (elt heap 0) (elt heap (1- (length heap))))
    (decf (fill-pointer heap))
    (heapify heap 0 key)
    min))

;(vector-push-extend value array) adds the value to the next available position in array
;incrementing the fill-pointer and increasing the size of the array if necessary
;for 8 puzzle, were inserting a node with key = #'node-f-cost for total cost f=g+h
(defun heap-insert (heap item key)
  ;puts an item into heap
  (vector-push-extend nil heap)
  (setf (elt heap (heap-find-pos heap (1- (length heap))
                                 (funcall key item) key))
        item)
  )

(defun heap-find-pos (heap i val key)
  ;bubbles up from i to find the position for val, moving items down in the process
  (cond ((or (zerop i)
             (< (heap-val heap (heap-parent i) key) val))
         i)
        (t (setf (elt heap i) (elt heap (heap-parent i)))
           (heap-find-pos heap (heap-parent i) val key))
        ))



