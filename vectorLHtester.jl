using vectorLHtest

@testset "vectorLH" begin
    println("Test set vectorLH")
    vectorLHtest.countbool_test()
    vectorLHtest.count_elem_test()
    # return true
end
