using matrixLHtest

@testset "matrixLH" begin
    println("Testing matrixLH")
    matrixLHtest.accumarray_test()
    matrixLHtest.round_to_grid_test()
    # return true
end
