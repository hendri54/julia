module vectorLHtest

using Test
using vectorLH


function countbool_test()
    xV = [true, false, true, false];
    @test vectorLH.countbool(xV) == 2
    return true
end

function count_elem_test()
    omitNan = true;
    xV = [7,1,3,1,1,3,4,NaN];
    countM = vectorLH.count_elem(xV, omitNan);
    @test countM == [1 3;  3 2; 4 1; 7 1]

    xV = [7,1,3,1,1,3,4];
    countV = vectorLH.count_indices(xV);
    @test countV == [3, 0, 2, 1, 0, 0, 1]
    return true
end

function counts_from_fractions_test()
    fracV = [0.21, 0.0, 0.79];
    n = 17;
    countV = vectorLH.counts_from_fractions(fracV, n, dbg = true);
    @test countV == [4, 0, 13]

    return true
end

function counts_to_indices_test()
    countV = [1, 0, 2, 0];
    outV = vectorLH.counts_to_indices(countV, dbg = true);
    @test outV[1] == [1, 1]
    @test isempty(outV[2])
    @test outV[3] == [2, 3]
    @test isempty(outV[4])

    out2V = vectorLH.counts_to_indices([0, 0], dbg = true);
    @test (isempty(out2V[1]) && isempty(out2V[2]))
    return true
end


"""
## Scale a vector
"""
function scale_vector_test()
    v = collect(1 : 0.1 : 2);
    v2 = copy(v);
    vectorLH.scale_vector!(v2, dbg = true);
    @test v2 ≈ v

    v2 = copy(v);
    vectorLH.scale_vector!(v2, xMin = 1.05, xMax = 1.8, dbg = true);
    @test vectorLH.validate_vector(v2, xMin = 1.05, xMax = 1.8);

    v2 = copy(v);
    vectorLH.scale_vector!(v2, xMin = 1.05, xMax = 1.8, vSum = 15.0, dbg = true);
    # Cannot guarantee bounds when a sum is given
    @test vectorLH.validate_vector(v2, vSum = 15.0);

    return true
end

end
