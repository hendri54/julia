# Exploring Julia language. Set up as sequence of unit tests
module juliaLH

using Test

function test_all()
    # Making an evenly spaced vector
    @test isa(collect(range(1, 2, length = 5)), Array{Float64,1})

    # Size of a scalar is ()
    @test size(1.1) == ()
end


end
