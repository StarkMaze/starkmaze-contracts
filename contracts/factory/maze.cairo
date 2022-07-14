%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
# https://www.cairo-lang.org/docs/reference/common_library.html?highlight=bitwise#common-library-bitwise
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_lt, assert_not_equal, assert_in_range
from starkware.cairo.common.uint256 import Uint256, uint256_add
from contracts.factory.structs import CardinalDirection, Location, CellData, Compass, CellStack

#############
# VARIABLES #
#############

@storage_var
func total_cells() -> (value : felt):
end

@storage_var
func cell_stack_counter() -> (value : felt):
end

@storage_var
func start() -> (cell : CellStack):
end

@storage_var
func visited_cells() -> (value : felt):
end

@storage_var
func n_rows() -> (value : felt):
end

@storage_var
func n_cols() -> (value : felt):
end

##########
# EVENTS #
##########

###########
# GETTERS #
###########

@view
func grid_size{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }() -> (n_rows : felt, n_cols : felt):
    let (max_row) = n_rows.read()
    let (max_col) = n_cols.read()
    return (max_row, max_col)
end

###############
# CONSTRUCTOR #
###############

@constructor
func constructor{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(numRows : felt, numCols : felt):
    # Initialize size of the maze's grid
    let grid = numRows * numCols
    n_rows.write(numRows)
    n_cols.write(numCols)

    # Entry point
    let start_cell_data = CellData(
        CardinalDirection(0,0,0,0),
        CardinalDirection(0,0,0,0),
        CardinalDirection(0,0,0,0),
        CardinalDirection(0,0,0,0)
    )
    let start_cell_loc = Location(0,0)

    total_cells.write(grid)
    start.write(CellStack(start_cell_loc, start_cell_data, 1))
    visited_cells.write(1)

    return ()
end

###########
# GETTERS #
###########

@view
func get_cell_location{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(cell_stack : CellStack) -> (row : felt, col : felt):
    let cell_row = cell_stack.location.row
    let cell_col = cell_stack.location.col
    return (row=cell_row, col=cell_col)
end

#############
# EXTERNALS #
#############

func generate_maze{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr
    }() -> (grid : CellStack**):
    alloc_locals

    # Create 2D array to store numRows * numCols CellStacks
    let (grid : CellStack**) = alloc()
    # Array of unvisited neighbors cells
    let (unvisited_neighbors : Compass*) = alloc()

    # Store maze solving route
    let (path_stack : CellStack*) = alloc()
    let (idx) = cell_stack_counter.read()
    let (start_cell : CellStack) = start.read()
    assert path_stack[idx] = start_cell
    
    # Array of dirs that allow us to check every ajdacent cell
    let dirs : Location* = alloc()
    assert dirs[0] = Location(0, -1) # west
    assert dirs[1] = Location(1, 0) # south
    assert dirs[2] = Location(0, 1) # east
    assert dirs[3] = Location(-1, 0) # north

    # 
    # loop while assert_lt(visited_cells_, total_cells_)
    #
    let visited_cells_ = visited_cells.read()
    let total_cells_ = total_cells.read()

    let dir_counter = 0
    _cell_neighbors(unvisited_neighbors, start_cell, dirs, dir_counter)
    #
    # end loop
    #

    return (grid)
end

#############
# INTERNALS #
#############

# Create state : Return the only neighbors that don't have downed walls
# Check if all walls are still up
func _cell_neighbors{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr
    }(unvisited_neighbors : Compass*, current_cell : CellStack, dirs : Location*, dir_counter : felt) -> (unvisited_neighbors : Compass*):
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

    return _cell_neighbors(unvisited_neighbors + 1, current_cell, dirs + 1, dir_counter + 1)
end

# Check that the neighbor doesn't have any walls knocked down
func _walls_bitwise_and{
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

func _walls_bitwise_or{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr
    }(cell : CellStack, direction_bits : CardinalDirection) -> (knocked_down_wall : CardinalDirection):
    alloc_locals

    let (west_bit) = bitwise_or(cell.cell.walls.west, direction_bits.west)
    let (south_bit) = bitwise_or(cell.cell.walls.south, direction_bits.south)
    let (east_bit) = bitwise_or(cell.cell.walls.east, direction_bits.east)
    let (north_bit) = bitwise_or(cell.cell.walls.north, direction_bits.north)

    return (CardinalDirection(west_bit, south_bit, east_bit, north_bit))
end

# Check if current cell is already inside of the maze
func _cell_in_bounds{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(col : felt, row : felt):
    let (max_row, max_col) = grid_size()
    assert_in_range(row, 0, max_row)
    assert_in_range(col, 0, max_col)
    return ()
end

func _connect_cells{
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

func _visit_cell{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    
    return ()
end