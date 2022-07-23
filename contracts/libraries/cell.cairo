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

    @view
    func is_visited{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc : Location) -> (bool : felt):
        return visited_cell.read(loc)
    end

    @external
    func neighbors{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(current : Location, nbors_len : felt, nbors : Location*, dirs_len : felt, dirs : Location*) -> (nbors_len : felt, nbors : Location*):
        alloc_locals

        # Loop to check every directions
        if dirs_len == 0:
            return (nbors_len=nbors_len, nbors=nbors)
        end

        # Check dirs neighbors
        let neighbor_cell_x = current.x + dirs[0].x
        let neighbor_cell_y = current.y + dirs[0].y

        assert [nbors] = Location(neighbor_cell_x, neighbor_cell_y)

        return neighbors(current, nbors_len - 1, nbors + 1, dirs_len - 1, dirs + 1)
    end

    @external
    func mark_visited{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc : Location, bool : felt):
        visited_cell.write(loc, bool)
        return ()
    end

end
