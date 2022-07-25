%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

from contracts.libraries.structs import Location
from contracts.libraries.constants import TRUE, FALSE

from contracts.movement.move import move_access
from contracts.board.maze import maze_access

@view
func test__movement{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*, 
    }():
    move_access.right()
    move_access.down()
    move_access.left()
    move_access.down()
    move_access.down()
    move_access.right()
    move_access.right()
    move_access.right()
    move_access.up()
    move_access.up()
    move_access.up()

    let (sender_address) = get_caller_address()
    let (loc : Location) = maze_access.get_player_location(sender_address)
    assert loc.x = 3
    assert loc.y = 0
    return ()
end

@view
func test__move_up{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*, 
    }():
    move_access.up()
    let (sender_address) = get_caller_address()
    let (loc : Location) = maze_access.get_player_location(sender_address)
    assert loc.x = 0
    assert loc.y = -1
    return ()
end

@view
func test__move_right{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*, 
    }():
    move_access.right()
    let (sender_address) = get_caller_address()
    let (loc : Location) = maze_access.get_player_location(sender_address)
    assert loc.x = 1
    assert loc.y = 0
    return ()
end

@view
func test__move_down{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*, 
    }():
    move_access.down()
    let (sender_address) = get_caller_address()
    let (loc : Location) = maze_access.get_player_location(sender_address)
    assert loc.x = 0
    assert loc.y = 1
    return ()
end

@view
func test__move_left{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*, 
    }():
    move_access.left()
    let (sender_address) = get_caller_address()
    let (loc : Location) = maze_access.get_player_location(sender_address)
    assert loc.x = -1
    assert loc.y = 0
    return ()
end