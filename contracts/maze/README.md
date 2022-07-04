# Core Contract : Maze.cairo

Build maze in deploying cells :

X 0 1 1 1
0 1 1 0 Y
0 0 0 0 1
1 0 1 0 1
1 1 1 1 1

nile invoke maze build_cell 0 0 0
nile invoke maze build_cell 0 1 0
nile invoke maze build_cell 0 2 1
nile invoke maze build_cell 0 3 1
nile invoke maze build_cell 0 4 1

nile invoke maze build_cell 1 0 0
nile invoke maze build_cell 1 1 1
nile invoke maze build_cell 1 2 1
nile invoke maze build_cell 1 3 0
nile invoke maze build_cell 1 4 0

nile invoke maze build_cell 2 0 0
nile invoke maze build_cell 2 1 0
nile invoke maze build_cell 2 2 0
nile invoke maze build_cell 2 3 0
nile invoke maze build_cell 2 4 1

nile invoke maze build_cell 3 0 1
nile invoke maze build_cell 3 1 0
nile invoke maze build_cell 3 2 1
nile invoke maze build_cell 3 3 0
nile invoke maze build_cell 3 4 1

nile invoke maze build_cell 4 0 1
nile invoke maze build_cell 4 1 1
nile invoke maze build_cell 4 2 1
nile invoke maze build_cell 4 3 1
nile invoke maze build_cell 4 4 1