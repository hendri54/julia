module displayLH

using Formatting
using Printf

export show_string_vector

# using Formatting
include("display/printf.jl")

"""
## Display string vector on fixed with screen
"""
function show_string_vector(sV :: Vector{T1},  width :: T2 = 80) where
    {T1 <: AbstractString,  T2 <: Integer}

    n = length(sV);
    if n < 1
        return nothing
    end

    iCol = 0;
    for s in sV
        len1 = length(s);
        if len1 > 0
            if iCol + len1 > width
                println(" ")
                iCol = 0;
            end
            print(s);
            iCol = iCol + len1;
            print("    ");
            iCol = iCol + 4;
        end
    end
    println(" ")
end

end # module
