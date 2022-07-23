%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from contracts.libraries.structs import Door

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

func _open{}():
    return ()
end