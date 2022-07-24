
%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from contracts.board.maze import maze_access

@constructor
func constructor{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr, 
        bitwise_ptr : BitwiseBuiltin*
    }(width : felt, height : felt):
    maze_access.initialize(width, height)
    return ()
end