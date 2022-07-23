# Contracts

| Files                     | Objectives |
| ----------------------------- | ------------- |
| maze.cairo         | Generate maze. | 
| cell.cairo      | Check cell’s neighbors & mark the cell as visited. | 
| direction.cairo   | Check that the neighbor doesn't have any walls knocked down. |
| door.cairo       |  |
| structs.cairo       | Structs. |

# How does it work?

## Depth First Search Algorithm

### Steps :

1) Configure your grid's size (width, height)
2) Define an entry and exit cell.
3) Get current cell and search for his neighbors in using compass points.
4) Move in the direction of one of the cardinal points if the cell is not visited, otherwise mark them as visited.
5) 