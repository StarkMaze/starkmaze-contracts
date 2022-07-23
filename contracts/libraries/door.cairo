%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or

from contracts.libraries.structs import Door, Location

@storage_var
func doors() -> (door : Door):
end

namespace door_access:

    func add{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(door: Door):
        doors.write(door)
        return ()
    end

    func contains{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }() -> (bool : felt):
        return doors.read()
    end


    func north{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc: Location) -> (bool : felt):
        return _open_in_direction(loc, '1')
    end

    func west{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc: Location) -> (bool : felt):
        return _open_in_direction(loc, '2')
    end

    func south{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc: Location) -> (bool : felt):
        return _open_in_direction(loc, '4')
    end

    func east{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(loc: Location) -> (bool : felt):
        return _open_in_direction(loc, '8')
    end

end

func _open_in_direction{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(loc : Location, dir : felt):

    return ()
end