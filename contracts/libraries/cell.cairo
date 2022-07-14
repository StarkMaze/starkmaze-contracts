%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_operations
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or
from starkware.cairo.common.math import assert_lt, assert_not_equal, assert_in_range

struct CardinalDirection:
    member west : felt # 0
    member south : felt # 1
    member east : felt # 2
    member north : felt # 3
end

struct Location:
    member row : felt
    member col : felt
end

# Each cell is represented by 16-bits
# From left-to-right the bits represent west, south, east, north.
struct CellData:
    # The left-most set of 4-bits store the backtrack path
    member backtrack : CardinalDirection
    # The next set of 4-bits store the solution path
    member solution : CardinalDirection
    # The next set of 4-bits store if a cell is on the maze border
    member border : CardinalDirection
    # The right-most set of 4-bits stores which walls have been knocked down
    member walls : CardinalDirection
end

struct CellStack:
    member location : Location
    member cell : CellData
    # Check if the cell has already been visited
    member visited : felt
end

struct Compass:
    member next_cell : CellStack
    # west = 0 | south = 1 | east = 2 | north = 3
    member cardinal_direction : felt
end

namespace cell_access:

    func entry_point{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }() -> (entry_point : CellStack):
        alloc_locals

        local cell_stack : CellStack
        assert cell_stack.cell = CellData(
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0)
        )
        assert cell_stack.location = Location(0,0)
        assert cell_stack.visited = 1
        return (cell_stack=cell_stack)
    end

    func neighbors{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            bitwise_ptr : BitwiseBuiltin*,
            range_check_ptr
        }(unvisited_neighbors : Compass*, current_cell : CellStack, directions : Location*, dir_counter : felt) -> (unvisited_neighbors : Compass*):
        alloc_locals

        # Loop to check every directions
        if dir_counter == 4:
            return (unvisited_neighbors)
        end

        let wall_bits = CardinalDirection(1,1,1,1)
        # Get current cell loc
        let (row, col) = get_cell_location(current_cell)
        # Check dirs neighbors
        #let neighbor_cell_row = row + dirs[dir_counter].row
        #let neighbor_cell_col = col + dirs[dir_counter].col
        let neighbor_cell_row = row + dirs[0].row
        let neighbor_cell_col = col + dirs[0].col

        # Check if neighbor is in grid range
        # WARNING : Check if function stop after assert
        _cell_in_bounds(neighbor_cell_row, neighbor_cell_col)

        let neighbor_cell_loc : Location = Location(neighbor_cell_row, neighbor_cell_col)
        let neighbor_cell_data : CellData = CellData(
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0)
        )
        # Create neighbor cell
        let neighbor : CellStack = CellStack(neighbor_cell_loc, neighbor_cell_data, 0)

        # Check if neighbor is unvisited
        # WARNING : Check if function stop after assert
        _walls_bitwise_and(neighbor, wall_bits)
        assert unvisited_neighbors[0] = Compass(neighbor, dir_counter)

        return neighbors(unvisited_neighbors + 1, current_cell, dirs + 1, dir_counter + 1
    end

    func is_in_bounds{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(col : felt, row : felt):
        let (max_row, max_col) = grid_size()
        assert_in_range(row, 0, max_row)
        assert_in_range(col, 0, max_col)
        return ()
    end

    func connect{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            bitwise_ptr : BitwiseBuiltin*,
            range_check_ptr
        }(from_cell : CellStack, to_cell : CellStack, compass : Compass):
        let compass_index = compass.cardinal_direction
        if compass_index == 0:
            let west_bits = CardinalDirection(1,0,0,0)
            
        end
        if compass_index == 1:
            let south_bits = CardinalDirection(0,1,0,0) 
            
        end
        if compass_index== 2:
            let east_bits = CardinalDirection(0,0,1,0) 
            
        end
        if compass_index == 3:
            let north_bits = CardinalDirection(0,0,0,1) 
            
        end

        return ()
    end
    
end