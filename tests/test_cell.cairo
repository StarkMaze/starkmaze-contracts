%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

from contracts.libraries.structs import Location
from contracts.libraries.constants import TRUE, FALSE
from contracts.board.maze import cell_access

@view
func test__mark_visited{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*, 
    }():
    let idx : Uint256 = Uint256(0, 0)
    let loc : Location = Location(1, 3)
    cell_access.set_cell(idx, loc)
    let cell_loc : Location = cell_access.get_cell(idx)
    assert cell_loc.x = 1
    assert cell_loc.y = 3

    cell_access.mark_visited(loc, TRUE)
    let (bool) = cell_access.is_visited(loc)
    assert bool = TRUE

    return ()
end