using vectorLHtest

@testset "vectorLH" begin
    println("Test set vectorLH")
    vectorLHtest.countbool_test()
    vectorLHtest.count_elem_test()
    vectorLHtest.counts_from_fractions_test()
    vectorLHtest.counts_to_indices_test()
    vectorLHtest.scale_vector_test()
end
