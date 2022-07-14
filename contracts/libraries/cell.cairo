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
        return (entry_point=cell_stack)
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
        let (row, col) = get_loc(current_cell)
        # Check dirs neighbors
        let neighbor_cell_row = row + directions[0].row
        let neighbor_cell_col = col + directions[0].col

        # Check if neighbor is in grid range
        # WARNING : Check if function stop after assert
        # is_in_bounds(neighbor_cell_row, neighbor_cell_col)
        local neighbor : CellStack
        assert neighbor.location = Location(neighbor_cell_row, neighbor_cell_col)
        assert neighbor.cell = CellData(
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0),
            CardinalDirection(0,0,0,0)
        )
        assert neighbor.visited = 0

        # Check if neighbor is unvisited
        # WARNING : Check if function stop after assert
        walls_bitwise_and(neighbor, wall_bits)
        assert unvisited_neighbors[0] = Compass(neighbor, dir_counter)

        return neighbors(unvisited_neighbors + 1, current_cell, directions + 1, dir_counter + 1)
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

    func get_loc{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(cell_stack : CellStack) -> (row : felt, col : felt):
        let cell_row = cell_stack.location.row
        let cell_col = cell_stack.location.col

        return (row=cell_row, col=cell_col)
    end

    # Check that the neighbor doesn't have any walls knocked down
    func walls_bitwise_and{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            bitwise_ptr : BitwiseBuiltin*,
            range_check_ptr
        }(cell : CellStack, wall_bits : CardinalDirection):
        alloc_locals

        let (west_bit) = bitwise_and(cell.cell.walls.west, wall_bits.west)
        assert_not_equal(west_bit, 1)
        let (south_bit) = bitwise_and(cell.cell.walls.south, wall_bits.south)
        assert_not_equal(south_bit, 1)
        let (east_bit) = bitwise_and(cell.cell.walls.east, wall_bits.east)
        assert_not_equal(east_bit, 1)
        let (north_bit) = bitwise_and(cell.cell.walls.north, wall_bits.north)
        assert_not_equal(north_bit, 1)
        return ()
    end
    
end