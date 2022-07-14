%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from contracts.libraries.cell import cell_access, CellStack, Location, Compass

struct Maze:
    member width : felt
    member cell_count : felt
end

@storage_var
func start() -> (cell : CellStack):
end

@storage_var
func cell_stack_counter() -> (value : felt):
end

@storage_var
func visited_cells() -> (value : felt):
end

namespace maze_acess:

    @constructor
    func constructor{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(width : felt):
        alloc_locals
        # Initialize size of the maze's grid
        local maze : Maze
        assert maze.width = width
        assert maze.cell_count = width * width

        let (entry_point) = cell_access.entry_point()
        start.write(entry_point)
        visited_cells.write(1)
        
        return ()
    end

    # @params : width - The number of rows/columns
    # @ returns : maze - The created maze
    @external
    func generate_maze{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            bitwise_ptr : BitwiseBuiltin*,
            range_check_ptr
        }(width : felt) -> (maze : Maze):
        alloc_locals

        local maze : Maze
        
        # Array of unvisited neighbors cells
        let (unvisited_neighbors : Compass*) = alloc()
        # Store maze solving route
        let (path_stack : CellStack*) = alloc()
        let (idx) = cell_stack_counter.read()
        let (start_cell : CellStack) = start.read()
        assert path_stack[idx] = start_cell

        let (directions) = search_all_directions()

        # 
        # loop while assert_lt(visited_cells_, total_cells_)
        #
        let visited_cells_ = visited_cells.read()
        # maze.cell_count

        let dir_counter = 0
        cell_access.neighbors(unvisited_neighbors, start_cell, directions, dir_counter)
        #
        # end loop
        #

        return (maze=maze)
    end

    func search_all_directions{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }() -> (directions : Location*):
        # Array of dirs that allow us to check every ajdacent cell
        let directions : Location* = alloc()
        assert directions[0] = Location(0, -1) # west
        assert directions[1] = Location(1, 0) # south
        assert directions[2] = Location(0, 1) # east
        assert directions[3] = Location(-1, 0) # north

        return (directions=directions)
    end

end