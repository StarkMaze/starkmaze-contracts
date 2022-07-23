%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from contracts.libraries.structs import Location

const NORTH = '1'
const EAST  = '2'
const SOUTH = '4'
const WEST  = '8'

namespace direction_access:

    # Array of dirs that allow us to check every ajdacent cell
    func all{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }() -> (dirs : Location*):
        local dirs : Location*
        assert dirs[0] = Location(0, -1)
        assert dirs[1] = Location(1, 0)
        assert dirs[2] = Location(0, 1)
        assert dirs[3] = Location(-1, 0)

        return (dirs=dirs)
    end

    # Get location of a direction 
    func location{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(dir : felt) -> (row : felt, col : felt):
        if dir == NORTH:
            return (0, -1)
        end
        if dir == EAST:
            return (1, 0)
        end
        if dir == SOUTH:
            return (0, 1)
        end
        if dir == WEST:
            return (-1, 0)
        end
    end

    # Get opposite of a direction
    func opposite{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }():
        return ()
    end

end