using Test1
using Test

@testset "Test1" begin
    O1 = Test1.Obj1();

    @test isempty(model_objects(123))

    O121 = "O121";
    @test model_objects(O121) == [Test1.selfObj]
    outV, _ = collect_model_objects(O121, :self);
    @test outV == [O121]

    O12 = Test1.Obj12();
    outV, nameV = collect_model_objects(O12, :self);
    @test outV == [O12.o121, O12.o122]
    @test nameV == [:o121, :o122]
end

# ----------
