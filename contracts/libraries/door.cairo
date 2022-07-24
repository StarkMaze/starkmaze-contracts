%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_or

from contracts.libraries.structs import Door, Location

from contracts.libraries.constants import TRUE, FALSE

@storage_var
func doors(door : Door) -> (bool : felt):
end

namespace door_access:

    @external
    func add{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(from_ : Location, to : Location):
        let door : Door = Door(from_, to)
        doors.write(door, TRUE)
        return ()
    end

    @view
    func contains{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(from_ : Location, to : Location) -> (bool : felt):
        let door : Door = Door(from_, to)
        return doors.read(door)
    end

    @external
    func north{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr,
            bitwise_ptr : BitwiseBuiltin*
        }(loc: Location) -> (bool : felt):
        let north = Location(0, -1)
        return _open_in_direction(loc, north)
    end

    @external
    func east{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr,
            bitwise_ptr : BitwiseBuiltin*
        }(loc: Location) -> (bool : felt):
        let east = Location(1, 0)
        return _open_in_direction(loc, east)
    end

    @external
    func south{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr,
            bitwise_ptr : BitwiseBuiltin*
        }(loc: Location) -> (bool : felt):
        let south = Location(0, 1)
        return _open_in_direction(loc, south)
    end

    @external
    func west{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr,
            bitwise_ptr : BitwiseBuiltin*
        }(loc: Location) -> (bool : felt):
        let west = Location(-1, 0)
        return _open_in_direction(loc, west)
    end

end

func _open_in_direction{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*
    }(loc : Location, dir : Location) -> (bool : felt):
    # Get dirs location
    let dir_loc_x : Location = Location(loc.x + dir.x, loc.y)
    let dir_loc_y : Location = Location(loc.x, loc.y + dir.y)

    # Check if there is a door between two cells
    let (res_x) = door_access.contains(loc, dir_loc_x)
    let (res_y) = door_access.contains(loc, dir_loc_y)

    let (x_or_y) = bitwise_or(res_x, res_y)
    return (bool=x_or_y)
end