using Test, checkLHtest

@testset "checkLH" begin
    @test checkLHtest.validate_test()
    @test checkLHtest.validate_scalar_test()
end

# ---------
