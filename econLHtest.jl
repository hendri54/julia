module econLHtest

using Test
using Distributions, Random
using econLH

include("econ/extreme_value_decision_test.jl")

"""
Present value
"""
function present_value_test()
    R = 1.05;
    T = 3;

    function f(x)
        return 0.7 .* x
    end
    pv = econLH.present_value(f, R, T);
    @test length(pv) == 1
    @test isa(pv, Float64)
    @test pv ≈ f(1) + f(2) ./ R + f(3) ./ R^2
    return true
end

end
