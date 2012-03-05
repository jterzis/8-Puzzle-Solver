This version checks if a node removed from fringe is
on visited (closed) list and if so does not expand it.
It also checks that successors are not on fringe before expanding them .





CASE 1)

initial state (5 4 2 6 1 3 7 0 8)


misplaced

(("left" "up" "right" "right" "up" "left" "left" "down" "right" "up" "right"
  "down" "left" "up" "left")
 15 959)


manhattan:

(("left" "up" "right" "right" "up" "left" "left" "down" "right" "up" "right"
  "down" "left" "up" "left")
 15 156)

extracredit:

(("left" "up" "right" "right" "up" "left" "left" "down" "right" "up" "right"
  "down" "left" "up" "left")
 15 130)



version3 case 2)

(8 7 2 5 0 3 1 4 6)

manhattan
(("right" "down" "left" "left" "up" "up" "right" "down" "down" "left" "up" "up"
  ...)
 26 6923)


extracredit
(("left" "down" "right" "up" "right" "up" "left" "left" "down" "right" "up"
  "right" ...)
 26 2467)


CASE 3)

initial state (4 3 6 5 8 1 0 7 2)

misplaced

(("right" "up" "up" "right" "down" "down" "left" "up" "left" "up" "right"
  "right" "down" "left" "left" "up" "right" "down" "down" "left" "up" "right"
  "up" "left")
 24 27932)


manhattan

(("right" "up" "up" "right" "down" "down" "left" "up" "left" "up" "right"
  "right" "down" "left" "left" "up" "right" "down" "down" "left" "up" "right"
  "up" "left")
 24 2748)



extracredit


(("right" "up" "up" "right" "down" "down" "left" "up" "left" "up" "right"
  "right" "down" "left" "left" "up" "right" "down" "down" "left" "up" "right"
  "up" "left")
 24 1434)


Case 1)

initial state: (7 8 1 5 0 2 4 3 6)

output


manhattan:

(("up" "right" "down" "left" "left" "down" "right" "right" "up" "left" "left"
  "up" "right" "down" "left" "down" "right" "up" "up" "left")
 20 444)


extracredit:

(("up" "right" "down" "left" "left" "down" "right" "right" "up" "left" "left"
  "up" "right" "down" "left" "down" "right" "up" "up" "left")
 20 547)


Case 2)

initial state: (6 3 5 1 0 2 7 8 4)

output

misplaced:

manhattan:

(("left" "up" "right" "down" "right" "down" "left" "left" "up" "up" "right"
  "down" "right" "up" "left" "left")
 16 260)

 extracredit:

(("left" "up" "right" "down" "right" "down" "left" "left" "up" "up" "right"
  "down" "right" "up" "left" "left")
 16 119)


Case 3)

initial state: (6 3 5 1 0 2 7 8 4)

output 

misplaced:

(("left" "up" "right" "down" "right" "down" "left" "left" "up" "up" "right"
  "down" "right" "up" "left" "left")
 16 1257)

manhattan

(("left" "up" "right" "down" "right" "down" "left" "left" "up" "up" "right"
  "down" "right" "up" "left" "left")
 16 187)

extracredit 

(("left" "up" "right" "down" "right" "down" "left" "left" "up" "up" "right"
  "down" "right" "up" "left" "left"))
 16 79)

Case 4)

initial state: (2 7 0 8 6 4 5 3 1)

output

misplaced:



manhattan:

(("down" "left" "down" "left" "up" "right" "up" "left" "down" "right" "right"
  "down" ...)
 26 3293)


extracredit:

(("down" "left" "down" "left" "up" "right" "up" "left" "down" "right" "right"
  "down" ...)

 26 1264)


Case 5:



