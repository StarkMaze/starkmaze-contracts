# Description

StarkMaze is a mini maze game! every day a new labyrinth will be generated. The player will have to solve this maze as quickly as possible. at the end of his game, an nft corresponding to the path he has traveled will be generated. The player can share his score directly on twitter.

# On-chain game computation

We decided to build a fully on-chain game. It mean that our maze generation algorithm will be coding and executing on-chain. 
First of all, we'll use depth first search to generate a perfect maze. A perfect maze is a maze with only one path between any two cells. Since there is only one path between any two points you can represent a perfect maze as a tree. Then use both depth first search and breadth first search to solve the maze. 

## 1- Maze generation

Depth First Search (DFS) :



DFS Algorithm in pseudocode :

1) Start at a random cell. (For now we decided to start all the time at top left)
2) Mark the current cell as visited, and get a list of its neighbors.
3) For each neighbor, starting with a randomly selected neighbor
4) If that neighbor hasn't been visited, remove the wall between this cell and that neighbor, and then recurse with that neighbor as the current cell.

Functions already implemented :

| Functions                     | Objectives |
| ----------------------------- | ------------- |
| ```generate_maze()```         | Generate maze. | 
| ```_cell_neighbors()```       | Return the only neighbors that don't have downed walls. | 
| ```_walls_bitwise_and()```    | Check that the neighbor doesn't have any walls knocked down. |
| ```_cell_in_bounds()```       | Check that the current cell is already inside the maze. |

## 2- Maze solving


## 3- Movements


## 4- Recuring game