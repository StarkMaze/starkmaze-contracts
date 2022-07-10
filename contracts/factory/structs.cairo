struct CardinalDirection:
    member west : felt # 0
    member south : felt # 1
    member east : felt # 2
    member north : felt # 3
end

struct Location:
    member row : felt
    member col : felt
end

# Each cell is represented by 16-bits
# From left-to-right the bits represent west, south, east, north.
struct CellData:
    # The left-most set of 4-bits store the backtrack path
    member backtrack : CardinalDirection
    # The next set of 4-bits store the solution path
    member solution : CardinalDirection
    # The next set of 4-bits store if a cell is on the maze border
    member border : CardinalDirection
    # The right-most set of 4-bits stores which walls have been knocked down
    member walls : CardinalDirection
end

struct CellStack:
    member location : Location
    member cell : CellData
    # Check if the cell has already been visited
    member visited : felt
end

struct Compass:
    # next cell index
    member cell : CellStack
    # west = 0 | south = 1 | east = 2 | north = 3
    member cardinal_direction : felt
end
