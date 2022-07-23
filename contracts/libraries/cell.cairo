%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_operations
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or
from starkware.cairo.common.math import assert_lt, assert_not_equal, assert_in_range

from contracts.libraries.structs import Location

@storage_var
func entrance() -> (loc : Location):
end

namespace cell_access:

    func is_visited{}():
        return ()
    end

    func neighbors{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(current : Location) -> ():
        
        return ()
    end

end

func _mark_visited{}():
    return ()
end

func _open{}():
    return ()
end