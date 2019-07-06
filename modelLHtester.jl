using modelLHtest

@testset "modelLH" begin
    println("Testing modelLH")
    @test modelLHtest.paramTest()
    @test modelLHtest.pvectorTest()
    @test modelLHtest.get_pvector_test()
    @test modelLHtest.pvectorDictTest()
    @test modelLHtest.modelTest()
    @test modelLHtest.deviationTest()
    @test modelLHtest.devVectorTest()
end
