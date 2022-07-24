%lang starknet

from starkware.cairo.common.hash import hash2
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin

namespace randomness_access:

    func generate{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr,
            hash_ptr : HashBuiltin*,
            bitwise_ptr : BitwiseBuiltin*,
        }(min : felt, max : felt) -> (number : felt):

        return (1)
    end

end