JOHN TERZIS - JT2514
8-PUZZLE A* STAR GRAPH SEARCH
ARTIFICIAL INTELLIGENCE
PROFESSOR ALEXANDER PASIK
SPRING 2012


This version of A* for the 8-puzzle checks if a node removed from fringe is
on visited (closed) list and if so does not expand it.
It also checks that successors are not on fringe before expanding them as per
Norvig's general graph algorithm. 


Extra Credit: 
We chose to use manhattan distance + linear conflict as our dominant heuristic.
Linear conflict on its own is an admissable heuristic because it underestimates the true cost
to the goal by relaxing the problem constraints and adding costs that would apply in reality if 
and only if tiles could uproot and fly over eachother. Specifically, for each line, if two squares 
tj , tk are on the same line, and both have goals on that line, and tj appears after tk yet its goal 
is to the left of tk, then we have a conflict b/c for tj to reach its goal tk will have to move 
"out of its way" first, requiring an extra 2 moves. Thus, for every pair of tiles that exhibit 
linear conflict, we add 2 to the cost. Manhattan distance is admissable and underestimates 
the cost to reach the goal in actuality. If we add linear conflict to MD, we still have an 
admissable heuristic because we are merely adding the minimum cost of resolving an actual linear 
conflict on the board and in order to reach the goal state,ALL linear conflicts must be resolved. 
So MD+LC is still admissable and furthermore dominates MD and the misplaced tiles heuristics 
since misplaced tiles <= MD <= MD+LC for every node n in the state space. This follows from the 
fact that LC >= 0 for every node n. SO MD+LC will strictly expand less nodes than MD or Misplaced 
Tiles except in cases where MD+LC expands more nodes on the goal contour, C*. It follows that MD+LC is 
optimal, optimally efficient, and consistent.




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



CASE 2)

(8 7 2 5 0 3 1 4 6)

misplaced

(("right" "down" "left" "left" "up" "up" "right" "down" "down" "left" "up" "up"
  "right" "down" "right" "down" "left" "left" "up" "right" "right" "down"
  "left" "left" "up" "up")
 26 72839)

manhattan

(("right" "down" "left" "left" "up" "up" "right" "down" "down" "left" "up" "up"
  "right" "down" "right" "down" "left" "left" "up" "right" "right" "down"
  "left" "left" "up" "up")
 26 6923)

extracredit

(("left" "down" "right" "up" "right" "up" "left" "left" "down" "right" "up"
  "right" "down" "left" "down" "right" "up" "left" "up" "left" "down" "down"
  "right" "up" "left" "up")
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


Case 4)

initial state: (6 3 5 1 0 2 7 8 4)

output

misplaced:

(("left" "up" "right" "down" "right" "down" "left" "left" "up" "up" "right"
  "down" "right" "up" "left" "left")
 16 1242)

manhattan:

(("left" "up" "right" "down" "right" "down" "left" "left" "up" "up" "right"
  "down" "right" "up" "left" "left")
 16 260)

 extracredit:

(("left" "up" "right" "down" "right" "down" "left" "left" "up" "up" "right"
  "down" "right" "up" "left" "left")
 16 119)


Case 5)

initial state: (2 7 0 8 6 4 5 3 1)

output

misplaced:

(("down" "left" "down" "left" "up" "right" "up" "left" "down" "right" "right"
  "down" "left" "left" "up" "right" "right" "up" "left" "down" "right" "down"
  "left" "left" "up" "up")
26 79394)


manhattan:

(("down" "left" "down" "left" "up" "right" "up" "left" "down" "right" "right"
  "down" "left" "left" "up" "right" "right" "up" "left" "down" "right" "down"
  "left" "left" "up" "up")
 26 3293)



extracredit:

(("down" "left" "down" "left" "up" "right" "up" "left" "down" "right" "right"
  "down" "left" "left" "up" "right" "right" "up" "left" "down" "right" "down"
  "left" "left" "up" "up")
 26 1264)






