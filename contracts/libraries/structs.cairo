struct Location:
    member x : felt
    member y : felt
end

struct Door:
    member from_ : Location
    member to : Location
end

struct Grid:
    member width : felt
    member height : felt
    member doors : Door*
    member visited : Location*
end