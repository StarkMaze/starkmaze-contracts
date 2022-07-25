%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from contracts.libraries.structs import Location

from contracts.board.maze import maze_access, player_location

namespace move_access:

    @external
    func up{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }():
        _move(0, -1)
        return ()
    end

    @external
    func right{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }():
        _move(1, 0)
        return ()
    end

    @external
    func down{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }():
        _move(0, 1)
        return ()
    end

    @external
    func left{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }():
        _move(-1, 0)
        return ()
    end



end

func _move{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(x : felt, y : felt):
    let (sender_address) = get_caller_address()
    let (current_cell : Location) = maze_access.get_player_location(sender_address)
    let after_moved = Location(x=current_cell.x + x, y=current_cell.y + y)
    player_location.write(sender_address, after_moved)
    return ()
end