%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from contracts.libraries.structs import Location
from contracts.board.maze import direction_access

@view
func test__retrieve_all_directions{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*
    }():
    let (dirs_len : felt, dirs : Location*) = direction_access.all()
    assert dirs_len = 4
    assert dirs[0] = Location(0, -1)
    assert dirs[1] = Location(1, 0)
    assert dirs[2] = Location(0, 1)
    assert dirs[3] = Location(-1, 0)
    return ()
end

@view
func test__retrieve_north_loc{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*
    }():
    let (x, y) = direction_access.location(1)
    assert x = 0
    assert y = -1
    return ()
end

@view
func test__retrieve_east_loc{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*
    }():
    let (x, y) = direction_access.location(2)
    assert x = 1
    assert y = 0
    return ()
end

@view
func test__retrieve_south_loc{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*
    }():
    let (x, y) = direction_access.location(4)
    assert x = 0
    assert y = 1
    return ()
end

@view
func test__retrieve_west_loc{
        syscall_ptr : felt*, 
        range_check_ptr, 
        pedersen_ptr : HashBuiltin*
    }():
    let (x, y) = direction_access.location(8)
    assert x = -1
    assert y = 0
    return ()
end