module matrixLHtest

using Random, Test
using matrixLH

function accumarray_test()
    subsM = [1 1; 2 1; 1 1; 2 2];
    valV = [1, 2, 3, 4];
    A = matrixLH.accumarray(subsM, valV, sum);
    @test A == [4.0 0.0; 2.0 4.0]

    # Vector
    A = matrixLH.accumarray(subsM[:,1], valV, sum);
    @test A == [4.0, 6.0]

    # Tim Holy version that is faster but only works on vectors
    A2 = matrixLH.accumarrayTH(subsM[:,1], valV)
    @test A2 == A
end


function round_to_grid_test()
    gridV = collect(range(1.0, 9.5, length = 7));
    Random.seed!(1234);
    xM = rand(4,3,2);
    idxM = round_to_grid(xM, gridV);

    isValid = true;
    for i1 in 1 : size(xM)[3]
        for i2 in 1 : size(xM)[2]
            for i3 in 1 : size(xM)[1]
                d1V = abs.(xM[i3,i2,i1] .- gridV);
                d2 = abs(xM[i3,i2,i1] - gridV[idxM[i3,i2,i1]]);
                isValid = isValid && all(d2 .< d1V .+ 1e-5)
            end
        end
    end
    @test isValid
end

end
