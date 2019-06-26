module modelLH_test

using Base.Test;

reload("modelLH");
using modelLH;

include("model/pstruct_test.jl");
# include("model/param_vector_test.jl");

function test_all()
    pstruct_test();
    param_vector_test();
end


# too long, refactor +++++
function param_vector_test()
   param_vector_basic_test();
   param_vector_list_test();
end

function param_vector_basic_test()
   println("\nTesting ParamVector")
   pv = modelLH.ParamVector();

   @test modelLH.length(pv) == 0
   @test !modelLH.param_exists(pv, :test1)

   # test1: calibrated
   ps1 = modelLH_test.make_param_struct(1, true);

   # test2: not calibrated
   ps2 = modelLH_test.make_param_struct(2, false);

   # test3: not calibrated
   ps3 = modelLH_test.make_param_struct(3, false);

   # test4: calibrated
   ps4 = modelLH_test.make_param_struct(4, true);

   modelLH.add!(pv, ps1);
   @test modelLH.length(pv) == 1

   modelLH.add!(pv, ps2);
   modelLH.add!(pv, ps3);

   ps2a = modelLH.retrieve(pv, ps2.name);
   @test ps2a.valueM ≈ ps2.valueM  atol = 1e-7

   ps1a = modelLH.retrieve(pv, ps1.name);
   @test ps1a.lbM ≈ ps1.lbM  atol = 1e-7

   value2 = modelLH.get_scalar_value(pv, ps2.name);
   @assert value2 ≈ ps2.valueM  atol = 1e-7

   modelLH.update!(pv, ps2.name; newUb = ps2.ubM .+ 0.1);
   ps2b = modelLH.retrieve(pv, ps2.name);
   @test ps2b.ubM ≈ (ps2.ubM .+ 0.1)  atol = 1e-6
   ps1a = modelLH.retrieve(pv, ps1.name);
   @test ps1a.lbM ≈ ps1.lbM  atol = 1e-7

   # Retrieve
   pList = modelLH.param_list(pv, true);
   @test pList[ps1.name] ≈ ps1.valueM  atol = 1e-7
   @test length(pList) == 1

   # List of objects
   pList2 = modelLH.param_list(pv, false);
   @test pList2[ps2.name] ≈ ps2.valueM  atol = 1e-7
   @test pList2[ps3.name] ≈ ps3.valueM  atol = 1e-7
   @test length(pList2) == 2

   # Add or update
   modelLH.add_or_update!(pv, :update1, "symUpd1", "update 1",
      1.2, 1.8, -0.1, 2.6, true);
   ps = modelLH.retrieve(pv, :update1);
   @test ps.valueM == 1.2

   return nothing
end


function param_vector_list_test()
   pv = modelLH.ParamVector();
   ps1 = modelLH_test.make_param_struct(1, true);
   ps2 = modelLH_test.make_param_struct(2, false);
   ps3 = modelLH_test.make_param_struct(3, true);
   ps4 = modelLH_test.make_param_struct(4, true);
   modelLH.add!(pv, ps1);
   modelLH.add!(pv, ps2);
   modelLH.add!(pv, ps3);
   modelLH.add!(pv, ps4);

   doCalIn = true;
   guessV, lbV, ubV = modelLH.parameters_as_vector(pv, doCalIn);
   @test  isa(guessV, Vector{Float64})

   # For testing: perturbe the already stored guesses
   # To make sure that `vector_to_values` restores them
   modelLH.update!(pv, :test1, newValue = modelLH.get_value(ps1) .+ 0.1);
   modelLH.update!(pv, :test2, newValue = modelLH.get_value(ps2) .+ 0.1);
   modelLH.update!(pv, :test3, newValue = modelLH.get_value(ps3) .+ 0.1);
   modelLH.update!(pv, :test4, newValue = modelLH.get_value(ps4) .+ 0.1);

   # Was updating successful?
   @assert modelLH.param_value(pv, :test1) ≈ modelLH.get_value(ps1) .+ 0.1
   @assert modelLH.param_value(pv, :test2) ≈ modelLH.get_value(ps2) .+ 0.1

   modelLH.vector_to_values(pv, guessV, doCalIn);

   # Check that the calibrated objects have been restored to guessV
   @test modelLH.param_value(pv, :test1) ≈ modelLH.get_value(ps1)
   @test modelLH.param_value(pv, :test3) ≈ modelLH.get_value(ps3)
   @test modelLH.param_value(pv, :test4) ≈ modelLH.get_value(ps4)

   # But the non-calibrated have not been changed
   @test modelLH.param_value(pv, :test2) ≈ modelLH.get_value(ps2) .+ 0.1
end


## Make a ParamStruct for testing
function make_param_struct(nameCounter :: Integer, doCal :: Bool)
   if iseven(nameCounter)
      valueV = Float64(nameCounter);
   else
      valueV = [1.1 2.2; 3.3 4.4] + Float64(nameCounter);
   end
   nameSymbol = Symbol("test$nameCounter");
   nameStr = "test$nameCounter";
   ps = modelLH.ParamStruct(nameSymbol, nameStr, nameStr * " description",
      valueV, valueV - 2.0, valueV - 2.5, valueV + 0.8, doCal);

   @assert ps.doCal == doCal
   return ps
end

end
