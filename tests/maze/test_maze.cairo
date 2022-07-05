%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from contracts.game.game import (
    move_right, move_down, move_left, move_up,
    Cell, cell, get_character_cell
)

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

@view
func test_move_down{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    let entry_point = Cell(row=0, col=0)
    cell.write(0, entry_point)

    let (current_cell) = get_character_cell(0)
    assert current_cell.row = 0
    assert current_cell.col = 0

    move_down()
    let (current_cell) = get_character_cell(0)
    assert current_cell.row = 1
    assert current_cell.col = 0
    return ()
end


@view
func test_move_left{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    let entry_point = Cell(row=0, col=0)
    cell.write(0, entry_point)

    let (current_cell) = get_character_cell(0)
    assert current_cell.row = 0
    assert current_cell.col = 0

    move_left()
    let (current_cell) = get_character_cell(0)
    assert current_cell.row = 0
    assert current_cell.col = -1
    return ()
end

@view
func test_move_up{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    let entry_point = Cell(row=0, col=0)
    cell.write(0, entry_point)

    let (current_cell) = get_character_cell(0)
    assert current_cell.row = 0
    assert current_cell.col = 0

    move_up()
    let (current_cell) = get_character_cell(0)
    assert current_cell.row = -1
    assert current_cell.col = 0
    return ()
end
