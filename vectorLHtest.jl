module vectorLHtest

using Test
# include("vectorLH.jl")
using vectorLH


function countbool_test()
    xV = [true, false, true, false];
    @test vectorLH.countbool(xV) == 2
end

function count_elem_test()
    omitNan = true;
    xV = [7,1,3,1,1,3,4,NaN];
    countM = vectorLH.count_elem(xV, omitNan);
    @test countM == [1 3;  3 2; 4 1; 7 1]

    xV = [7,1,3,1,1,3,4];
    countV = vectorLH.count_indices(xV);
    @test countV == [3, 0, 2, 1, 0, 0, 1]
end

end
