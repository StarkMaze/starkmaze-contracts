%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math_cmp import (is_in_range, is_not_zero)
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.uint256 import Uint256, uint256_add

from contracts.libraries.structs import Grid, Location
from contracts.libraries.randomness import randomness_access

from contracts.board.cell import cell_access
from contracts.board.direction import direction_access
from contracts.board.door import door_access

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


@storage_var
func player_location(address : felt) -> (loc : Location):
end

namespace maze_access:

    @external
    func initialize{
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
        }():
        alloc_locals
        let entry_cell : Location = entry.read()
        # Mark entry cell as visited
        cell_access.mark_visited(entry_cell, TRUE)

        _build(entry_cell)

        return ()
    end

    @view
    func get_player_location{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*,
            range_check_ptr,
        }(address : felt) -> (loc : Location):
        return player_location.read(address)
    end

end

func _build{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*
    }(current : Location):
    alloc_locals
    
    # Store current cell
    let (idx) = count_visited_cells.read()
    cell_access.set_cell(idx, current)

    # Get all possible dirs
    let dirs : Location* = direction_access.all()
    # Create array to store all neighbors
    let (local neighbors : Location*) = alloc()
    let (nbors_len : felt, nbors : Location*) = _neighbors(current, 4, neighbors, 4, dirs)
    let (res_len) = is_not_zero(nbors_len)

    if res_len == TRUE: 
    
        # Choose randomly one nbors
        # let (rand) = randomness_access.generate{hash_ptr=pedersen_ptr}(0, nbors_len)
        let rand = 0
        let nbor : Location = nbors[rand]
        let (visited) = cell_access.is_visited(nbor)
        
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        tempvar range_check_ptr = range_check_ptr

        if visited == FALSE:
            cell_access.mark_visited(nbor, TRUE)
            door_access.add(current, nbor)
            # Push to Stack for solution
            let (res,_) = uint256_add(idx, Uint256(1, 0))
            count_visited_cells.write(res)

            tempvar syscall_ptr : felt* = syscall_ptr
            tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
            tempvar range_check_ptr = range_check_ptr

            return _build(nbor)
        else:
            # Pop from Stack to current cell for solution
            tempvar syscall_ptr : felt* = syscall_ptr
            tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
            tempvar range_check_ptr = range_check_ptr
        end
    else:
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        tempvar range_check_ptr = range_check_ptr
    end
    
    return ()
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

    # wait Wednesday the 27'th release to uncomment
    #if res_x == TRUE and res_y == TRUE:
    #    return (TRUE)
    #end

    if x_and_y == TRUE:
        return (TRUE)
    end
    return (FALSE)
end



