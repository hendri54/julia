module checkLHtest

using Test
using checkLH

function validate_test()
    @test_throws ErrorException checkLH.validate(1.2, Float64)

    checkLH.validate([1.2, 2.3], Float64)
    checkLH.validate([1.2, 2.3], Float64, sz = (2,), lb = 1.0)
    checkLH.validate([1.2 2.1; 2.2 3.2], Float64, sz = (2,2))
    # checkLH.validate(1.2, Float64, sz = ())
    checkLH.validate([1.2, 2.3], [], lb = 1.1)

    @test_throws DimensionMismatch checkLH.validate([1.2, 2.3, 3.4], Float64, sz = (2,))
    @test_throws ErrorException  checkLH.validate([2.1, 3.2], Float64, ub = 3.1)

    return true
end

function validate_scalar_test()
    validate_scalar(1.1, Float64, lb = 0.9, ub = 1.2)
    validate_scalar(1, Integer, lb = 0.9, ub = 1.3)
    @test_throws ErrorException validate_scalar(1.1, [], lb = 1.2, ub = 1.3)
    @test_throws ErrorException validate_scalar(1.1, Integer, lb = 0.9, ub = 1.3)
    @test_throws ErrorException validate_scalar([1.1, 2.2], [], lb = 1.2, ub = 1.3)
    return true
end

end
