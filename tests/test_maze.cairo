%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from starkware.cairo.common.math import assert_not_equal

from contracts.libraries.structs import Grid
from contracts.board.maze import maze_access, maze

@view
func test__initialize{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*, 
        bitwise_ptr : BitwiseBuiltin*
    }():
    maze_access.initialize(5, 5)
    let board : Grid = maze.read()
    assert board.width = 5
    assert board.height = 5
    return ()
end