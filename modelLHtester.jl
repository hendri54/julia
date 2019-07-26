using modelLHtest

@testset "modelLH" begin
    println("Testing modelLH")
    @test modelLHtest.single_id_test()
    @test modelLHtest.object_id_test()
    @test modelLHtest.paramTest()
    @test modelLHtest.pvectorTest()
    @test modelLHtest.get_pvector_test()
    @test modelLHtest.pvectorDictTest()
    @test modelLHtest.report_test()
    @test modelLHtest.modelTest()
    @test modelLHtest.deviationTest()
    @test modelLHtest.devVectorTest()

    @test modelLHtest.merge_object_arrays_test()
end
