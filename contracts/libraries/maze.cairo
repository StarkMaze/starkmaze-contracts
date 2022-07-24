%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math_cmp import is_in_range
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.uint256 import (Uint256, uint256_add)

from contracts.libraries.structs import Grid, Location
from contracts.libraries.cell import cell_access
from contracts.libraries.direction import direction_access

from contracts.libraries.constants import TRUE, FALSE

@storage_var
func entry() -> (loc : Location):
end

@storage_var
func exit() -> (loc : Location):
end

@storage_var
func maze() -> (grid : Grid):
end

@storage_var
func total_cells() -> (res : felt):
end

@storage_var
func count_visited_cells() -> (counter : Uint256):
end

namespace maze_access:

    @constructor
    func constructor{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(width : felt, height : felt):
        alloc_locals
        # Initialize size of the maze's grid
        local grid : Grid
        assert grid.width = width
        assert grid.height = height

        maze.write(grid)
        total_cells.write(width * height)

        # Define entry & exit cell
        let entry_cell : Location = Location(0, 0)
        entry.write(entry_cell)
        let exit_cell : Location = Location(grid.width - 1, grid.height - 1)
        exit.write(exit_cell)
        
        return ()
    end

    @external
    func build{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr,
            bitwise_ptr : BitwiseBuiltin*
        }() -> (grid : Grid):
        alloc_locals

        let grid : Grid = maze.read()
        let entry_cell : Location = entry.read()
        # let (nb_cells) = total_cells.read()

        _build(entry_cell, grid)

        return (grid=grid)
    end

end

func _build{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*
    }(current : Location, grid : Grid) -> (grid : Grid):
    alloc_locals

    cell_access.mark_visited(current, TRUE)

    # Mark entry cell as visited
    let (counter) = count_visited_cells.read()
    let (res,_) = uint256_add(counter, Uint256(1, 0))
    count_visited_cells.write(res)

    # Get all possible dirs
    let dirs : Location* = direction_access.all()
    # Create array to store all neighbors
    let (local neighbors : Location*) = alloc()
    let (nbors_len : felt, nbors : Location*) = _neighbors(current, 4, neighbors, 4, dirs)

    # If nbors_len > 0: 
        # Pseudo random number generator
        # Choose randomly one nbors
        # If visited -> is_visited(nbor):
            # Mark new cell as visited -> mark_visited(nbor, TRUE)
            # Add a door between current and new cell -> door_access.add(current, nbor)
            # Push new cell as current cell -> return _build(nbor, grid)
            # Push to Stack
        # Else:
            # Pop from Stack to current cell
        # End
    # End
    
    return _build(current, grid)
end

func _neighbors{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*
    }(current : Location, neighbors_len : felt, neighbors : Location*, dirs_len : felt, dirs : Location*) -> (nbors_len : felt, nbors : Location*):
    alloc_locals

    # Loop to check every directions
    if dirs_len == 0:
        return (neighbors_len, neighbors)
    end

    # Check dirs neighbors
    let neighbor_cell_x = current.x + dirs[0].x
    let neighbor_cell_y = current.y + dirs[0].y

    let (res) = _in_bounds(neighbor_cell_x, neighbor_cell_y)
    if res == TRUE:
        assert [neighbors] = Location(neighbor_cell_x, neighbor_cell_y)
        return _neighbors(current, neighbors_len - 1, neighbors + 1, dirs_len - 1, dirs + 1)
    end

    return _neighbors(current, neighbors_len - 1, neighbors, dirs_len - 1, dirs + 1)
end


func _in_bounds{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*
    }(x : felt, y : felt) -> (bool : felt):
    alloc_locals
    let grid : Grid = maze.read()

    let (res_x) = is_in_range(x, 0, grid.width)
    let (res_y) = is_in_range(y, 0, grid.height)
    let (x_and_y) = bitwise_and(res_x, res_y)

    if x_and_y == 1:
        return (TRUE)
    end
    return (FALSE)
end

#
# Comment pourrais-je avoir un tel résultat?
#
# if 0 < x < max_x:
    # Do something
# else:
    # Do something
#

# 
# Sachant qu'il n'y a pas d'opérateur "<" du au fait que Cairo soit un langage de bas niveau
# et que si j'utilise un assert cela va me faire une erreur et stopper ma function. Je souhaite 
# faire en sorte que si mon élément n'est pas dans mon range je puisse exécuter d'autres instructions
#
# assert_in_range(x, max_x, 0)
#




