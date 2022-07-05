%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (get_caller_address, get_block_timestamp)
from contracts.maze.maze import (Cell, cell)

#############
# VARIABLES #
#############

@storage_var
func game() -> (running : felt):
end

@storage_var
func entry_timestamp(user : felt) -> (timestamp : felt):
end

@storage_var
func exit_timestamp(user : felt) -> (timestamp : felt):
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

@view
func get_route_time{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(user : felt) -> (timestamp : felt):
    let (sender) = get_caller_address()
    let (entry) = entry_timestamp.read(sender)
    let (exit) = exit_timestamp.read(sender)
    return (exit - entry)  
end

#############
# EXTERNALS #
#############

@external
func launch_game{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    let (block_timestamp) = get_block_timestamp()
    let (sender) = get_caller_address()

    game.write(1)
    entry_timestamp.write(sender, block_timestamp)
    return ()
end

@external
func end_game{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    let (block_timestamp) = get_block_timestamp()
    let (sender) = get_caller_address()
    
    game.write(0)
    exit_timestamp.write(sender, block_timestamp)
    return ()
end

@external
func move_right{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    _move(0, 1)
    return ()
end

@external
func move_down{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    _move(1, 0)
    return ()
end

@external
func move_left{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    _move(0, -1)
    return ()
end

@external
func move_up{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }():
    _move(-1, 0)
    return ()
end

#############
# INTERNALS #
#############

func _move{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(row : felt, col : felt):
    let (current_cell : Cell) = get_character_cell(0)
    let after_moved = Cell(row=current_cell.row + row, col=current_cell.col + col)
    cell.write(0, after_moved)
    return ()
end