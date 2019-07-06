using Test1
using Test

@testset "Test1" begin
    O1 = Test1.Obj1();

    @test isempty(model_objects(123))

    O121 = "O121";
    @test model_objects(O121) == [Test1.selfObj]
    @test collect_model_objects(O121) == [O121]

    O12 = Test1.Obj12();
    @test collect_model_objects(O12) == [O12.o121, O12.o122]
end

# ----------
