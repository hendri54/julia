using econLHtest

@testset "econLH" begin
    @test econLHtest.extreme_value_decision_test(true)
    @test econLHtest.extreme_value_decision_test(false)
    @test econLHtest.extreme_value_one_option_test()
    @test econLHtest.present_value_test()
end
