%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_operations
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or
from starkware.cairo.common.math import assert_lt, assert_not_equal, assert_in_range

from contracts.libraries.structs import Location
from contracts.libraries.direction import direction_access

@storage_var
func visited_cell(loc : Location) -> (bool : felt):
end

namespace cell_access:

    func is_visited{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc : Location):
        return visited_cell.read(loc)
    end

    
    func neighbors{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(current : Location, neighbors : Location*, dirs : Location*, dirs_len : felt) -> (neighbors : Location*):
        alloc_locals

        # Loop to check every directions
        if dir_counter == 0:
            return (neighbors=neighbors)
        end

        # Check dirs neighbors
        let neighbor_cell_x = current.x + dirs[0].x
        let neighbor_cell_y = current.y + dirs[0].y

        assert [neighbors] = Location(neighbor_cell_x, neighbor_cell_y)

        return neighbors(current, neighbors, dirs + 1, dirs_len - 1)
    end


    func mark_visited{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc : Location, bool : felt):
        visited_cell.write(loc, bool)
        return ()
    end

end
