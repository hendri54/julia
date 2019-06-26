function CRRA_test()
   println("CRRA_test")
   crraS = utilityFunctionsLH.CRRA(2.0, true);
   cM = collect(range(2.0, 3.0, length = 4)) * collect(range(1.5, 2.5, length = 5))';
   uM = utilityFunctionsLH.utility(crraS, cM);
   muM = utilityFunctionsLH.marginal_utility(crraS, cM);
   @test size(cM) == size(uM)
   @test all(muM .> 0)

   dc = 1e-4;
   u2M = utilityFunctionsLH.utility(crraS, cM .+ dc);
   mu2M = (u2M .- uM) ./ dc;
   @test muM ≈ mu2M  atol = 1e-5

   @test pv_consumption_test()
   @test euler_test()
   return true
end


function pv_consumption_test()
    crraS = utilityFunctionsLH.CRRA(2.0, true)
    R = 1.07;
    beta = 0.97;
    betaR = beta * R;
    T = 3;
    pv = pv_consumption(crraS, beta, R, T);
    g = cons_growth(crraS, betaR);
    # println("Consumption growth $g")
    pvTrue = 1 + g/R + (g/R)^2;
    @test pv ≈ pvTrue

    ltIncome = 17.3;
    cV = cons_path(crraS, beta, R, T, ltIncome);
    @test length(cV) == T  &&  all(cV .> 0.0)
    discV = (1/R) .^ (0 : (T-1));
    pv = sum(cV .* discV);
    @test pv ≈ ltIncome

    devV = euler_deviation(crraS, beta, R, cV);
    @test all(abs.(devV) .< 1e-4)

    utilV = utility(crraS, cV);
    betaV = beta .^ (0 : (T-1));
    ltUtil = sum(utilV .* betaV);
    @test ltUtil ≈ lifetime_utility(crraS, beta, R, T, ltIncome)
    return true
end


function euler_test()
    crraS = utilityFunctionsLH.CRRA(2.0, true)
    R = 1.07;
    beta = 0.97;
    T = 5;
    g = cons_growth(crraS, beta .* R);
    devV = euler_deviation(crraS, beta, R, g .^ (1:T));
    @test all(abs.(devV) .< 1e-4)
    return true
end
