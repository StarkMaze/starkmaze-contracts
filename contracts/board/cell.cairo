%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

from contracts.libraries.structs import Location
from contracts.board.direction import direction_access

@storage_var
func visited_cells(loc : Location) -> (bool : felt):
end

@storage_var
func cells(idx : Uint256) -> (loc : Location):
end

namespace cell_access:

    @view
    func is_visited{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc : Location) -> (bool : felt):
        return visited_cells.read(loc)
    end

    @external
    func mark_visited{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc : Location, bool : felt):
        visited_cells.write(loc, bool)
        return ()
    end

    @view
    func get_cell{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(idx : Uint256) -> (loc : Location):
        return cells.read(idx)
    end

    @external
    func set_cell{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(idx : Uint256, loc : Location):
        cells.write(idx, loc)
        return ()
    end

end