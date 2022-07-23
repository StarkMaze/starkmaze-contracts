%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from contracts.libraries.structs import Grid, Location

namespace maze_acess:

    @constructor
    func constructor{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(width : felt, height : felt):
        alloc_locals
        # Initialize size of the maze's grid
        local grid : Grid
        assert grid.width = width
        assert grid.height = height
        
        return ()
    end

    func build{}():
        return ()
    end

    func in_bounds{}():
        return ()
    end

end

func _build{}():
    return ()
end