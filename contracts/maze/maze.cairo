%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_caller_address

###############
# CONSTRUCTOR #
###############

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let entry_point = Cell(row=0, col=0)
    cell.write(0, entry_point)
    return ()
end

#############
# VARIABLES #
#############

struct Cell:
    member row : felt
    member col : felt
end

@storage_var
func cell(idx : felt) -> (cell : Cell):
end

@storage_var
func cell_counter() -> (value : felt):
end

###########
# GETTERS #
###########

#############
# EXTERNALS #
#############

