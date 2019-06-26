module checkLH_test

using Test
include("checkLH.jl")
# using checkLH

function test_all()
    validate_test()
    return true
end

function validate_test()
    checkLH.validate(1.2, Float64)
    checkLH.validate([1.2, 2.3], Float64)
    checkLH.validate([1.2, 2.3], Float64, sz = (2,), lb = 1.0)
    checkLH.validate([1.2 2.1; 2.2 3.2], Float64, sz = (2,2))
    checkLH.validate(1.2, Float64, sz = ())
    checkLH.validate([1.2, 2.3], [], lb = 1.1)

    @test_throws DimensionMismatch checkLH.validate(1.2, Float64, sz = (2,))
    @test_throws ErrorException  checkLH.validate([2.1, 3.2], Float64, ub = 3.1)
end

end
