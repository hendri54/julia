using LatexLHtest

@testset "LatexLH" begin
    @test LatexLHtest.CellColorTest();
    @test LatexLHtest.CellTest();
    @test LatexLHtest.TableTest();
    @test LatexLHtest.parameter_table_test();
end
