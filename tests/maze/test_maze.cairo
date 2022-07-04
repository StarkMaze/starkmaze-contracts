%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from contracts.game.game import (move_right, Cell, cell, get_character_cell)

@view
func test_move_right{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    let entry_point = Cell(row=0, col=0)
    cell.write(0, entry_point)

    let (current_cell) = get_character_cell(0)
    assert current_cell.row = 0
    assert current_cell.col = 0

    move_right()
    let (current_cell) = get_character_cell(0)
    assert current_cell.row = 0
    assert current_cell.col = 1
    return ()
end
