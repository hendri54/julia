function pstruct_test()
  sizeV = (2, 4, 3)
  valueV = rand(sizeV);
  defaultValueV = rand(sizeV);
  p = modelLH.ParamStruct(:test1, "alpha1", "test structure", valueV, defaultValueV,
    -ones(valueV), 2 .* ones(valueV),  true);
    @assert  p.defaultValueM ≈ defaultValueV  atol = 1e-7

  modelLH.update!(p, ub = valueV .+ 0.1);
  @assert p.ubM ≈ valueV .+ 0.1  atol = 1e-7

  modelLH.validate(p);

  return nothing
end
