using Random

function ces_test()
    # should have test code for production functions

    Random.seed!(173);
    n = 3;
    T = 5;
    substElast = 1.6;
    alphaV = collect(range(1.0, 2.0, length = n));
    alphaV = alphaV ./ sum(alphaV);
    xM = rand(T,n) .* 3.0;
    AV = rand(T) .* 9.4;

    fS = productionFunctionsLH.CES(substElast, alphaV, AV);
    productionFunctionsLH.check(fS);
    yV = productionFunctionsLH.output(fS, xM)

    # Marginal products
    mpM = productionFunctionsLH.mproducts(fS, xM);
    dx = 0.00001;
    for j = 1 : n
      x2M = copy(xM);
      x2M[:,j] = x2M[:,j] .+ dx;
      y2V = productionFunctionsLH.output(fS, x2M);
      derivV = (y2V - yV) ./ dx;
      @test  all(abs.(derivV .- mpM[:,j]) ./ max.(0.1, mpM[:,j]) .< 1e-3)
    end

    return true
end

# ------------------
