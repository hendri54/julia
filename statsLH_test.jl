module statsLH_test

using Base.Test

reload("statsLH")
using statsLH

include("stats/std_std_test.jl")

function test_all()
    std_w_test()
    std_std_test()
end

function std_w_test()
    n = Int64(1e4);
    rng = MersenneTwister(1234);
    z = randn(rng, Float64, (1, n));
    wtV = ones(1, n);
    zStd, zMean = std_w(z, wtV)
    println("zMean = $zMean,  zStd = $zStd")
    @test zMean ≈ 0.0 atol=0.01
    @test zStd ≈ 1.0 atol = 1e-3

    zStd2 = std(z)
    @test zStd2 ≈ zStd atol = 1e-4
end

end
