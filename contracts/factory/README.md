# Core Contract : Maze.cairo

## Our objective

Create a perfect maze, the simplest type of maze for a computer to generate and solve. A perfect maze is defined as a maze which has one and only one path from any point in the maze to any other point. This means that the maze has no inaccessible sections, no circular paths, no open areas. 

To go from a grid of unconnected cells to a perfect maze we need to knock down some of those walls. We'll choose a random cell to start from and traverse the grid using depth first search. Whenever a new cell is visited, the wall between the new cell and the previous cell is knocked down.

## Depth-First Search
 
This is the simplest maze generation algorithm. It works like this: 

1) Start at a random cell in the grid. 
2) Look for a random neighbor cell you haven't been to yet. 
3) If you find one, move there, knocking down the wall between the cells. If you don't find one, back up to the previous cell. 
4) Repeat steps 2 and 3 until you've been to every cell in the grid.

Functions already implemented :

| Functions                     | Objectives |
| ----------------------------- | ------------- |
| ```generate_maze()```         | Generate maze. | 
| ```_cell_neighbors()```       | Return the only neighbors that don't have downed walls. | 
| ```_walls_bitwise_and()```    | Check that the neighbor doesn't have any walls knocked down. |
| ```_cell_in_bounds()```       | Check that the current cell is already inside the maze. |
