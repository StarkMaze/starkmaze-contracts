%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import (Uint256, uint256_add)

from contracts.libraries.structs import Grid, Location
from contracts.libraries.cell import cell_access, direction_access

const TRUE = 'TRUE'
const FALSE = 'FALSE'

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

namespace maze_acess:

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

    func build{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }() -> (grid : Grid):
        let grid = maze.read()
        let entry_cell = entry.read()
        let nb_cells = total_cells.read()

        _build(entry_cell, grid, nb_cells)

        return ()
    end

end

func _build{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(current : Location, grid : Grid, nb_cells : felt) -> (grid : Grid):
    alloc_locals

    cell_access.mark_visited(current, 'TRUE')

    let (counter) = count_visited_cells.read()
    let (res,_) = uint256_add(counter, Uint256(1, 0))
    count_visited_cells.write(res)

    # Get all possible dirs
    let dirs : Location* = direction_access.all()
    # Create array to store all neighbors
    let (local neighbors : Location*) = alloc()
    cell_access.neighbors(current, 4, neighbors, 4, dirs)
    
    #let (res) = _in_bounds(neighbor_cell_x, neighbor_cell_y)
    #if  res == TRUE:

    #end


    return _build(current, grid, nb_cells)
end

func _in_bounds{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(x : felt, y : felt) -> (bool : felt):

    return ('')
end