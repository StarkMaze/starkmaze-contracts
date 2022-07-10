%lang starknet

from contracts.factory.maze import generate_maze, _cell_neighbors, _walls_bitwise_and, _cell_in_bounds
from contracts.factory.structs import CardinalDirection, Location, CellData, CellStack, Compass

@external
func test_initialize_data{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals

    local contract_address : felt
    # We deploy contract and put its address into a local variable. Second argument is calldata array
    %{ ids.contract_address = deploy_contract("./contracts/factory/maze.cairo", [5, 5]).contract_address %}

    return ()
end