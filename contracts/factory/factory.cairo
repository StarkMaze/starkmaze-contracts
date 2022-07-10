%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy

#############
# VARIABLES #
#############

@storage_var
func salt() -> (value : felt):
end

@storage_var
func factory_class_hash() -> (class_hash : felt):
end

##########
# EVENTS #
##########

@event
func maze_contract_deployed(contract_address : felt):
end

###############
# CONSTRUCTOR #
###############

@constructor
func constructor{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(factory_class_hash_ : felt):
        factory_class_hash.write(value=factory_class_hash_)
    return ()
end

###########
# GETTERS #
###########



#############
# EXTERNALS #
#############

@external
func deploy_maze_contract{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr,
    }():
    let (current_salt) = salt.read()
    let (class_hash) = factory_class_hash.read()
    let (contract_address) = deploy(
        class_hash=class_hash,
        contract_address_salt=current_salt,
        constructor_calldata_size=0,
        constructor_calldata=cast(new (), felt*),
    )

    salt.write(value=current_salt + 1)

    maze_contract_deployed.emit(
        contract_address=contract_address
    )
    return ()
end

