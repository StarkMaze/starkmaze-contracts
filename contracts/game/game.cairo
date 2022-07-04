%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.maze.maze import (Cell, cell)

#############
# VARIABLES #
#############

@storage_var
func game() -> (running : felt):
end

###########
# GETTERS #
###########

@view
func get_character_cell{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(idx : felt) -> (current_cell : Cell):
    let (current_cell) = cell.read(idx)
    return (current_cell)
end

@external
func launch_game{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    game.write(1)
    return ()
end

@external
func move_right{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    let (current_cell : Cell) = get_character_cell(0)
    let after_moved = Cell(row=current_cell.row, col=current_cell.col + 1)
    cell.write(0, after_moved)
    return ()
end

@external
func move_down{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    return ()
end

@external
func move_left{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    return ()
end

@external
func move_up{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    return ()
end

@external
func end_game{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    game.write(0)
    return ()
end