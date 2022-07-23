%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from contracts.libraries.structs import Door, Location

@storage_var
func door() -> (door : Door):
end

namespace door_access:

    func north{}():
        return ()
    end

    func west{}():
        return ()
    end

    func south{}():
        return ()
    end

    func east{}():
        return ()
    end

end

func _open_in_direction{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(loc : Location, dir : felt):

    return ()
end