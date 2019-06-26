using vectorLH
using Printf

##
function extreme_value_one_option_test()
    prefScale = 0.4;
    d = ExtremeValueDecision(prefScale, true, true);
    nTypes = 3;
    value_iV = collect(range(32.0, 48.0, length = nTypes));
    prob_iV, eVal_iV = extreme_value_decision(d, value_iV);

    @test prob_iV == ones(Float64, nTypes)
    @test eVal_iV ≈ value_iV

    # Not demeaned
    d2 = ExtremeValueDecision(prefScale, false, true);
    prob_iV, eVal2_iV = extreme_value_decision(d2, value_iV);
    @test prob_iV == ones(Float64, nTypes)
    @test all(eVal2_iV .> eVal_iV)
    return true
end

##
function extreme_value_decision_test(demeaned :: Bool)
    n = 4;
    prefScale = 0.4;
    d = ExtremeValueDecision(prefScale, demeaned, true);

    # Row vector of values (as matrix)
    value_xV = collect(range(100.0, 110.0, length = n)');
    # @bp

    for nTypes in [1, 3]
       if nTypes == 1
          value_ixM = value_xV;
       else
          value_ixM = collect(range(1.0, 0.9, length = nTypes)) *
            collect(range(100.0, 110.0, length = n)');
       end

       prob_ixM, eVal_iV = econLH.extreme_value_decision(d, value_ixM);
       @test check_by_sim(d, value_ixM, prob_ixM, eVal_iV);
    end
    return true
end


"""
Test by simulation
"""
function check_by_sim(d :: ExtremeValueDecision,  value_ixM :: Array{T,2},
    prob_ixM :: Array{T,2},  eVal_iV :: Array{T,1})    where T <: AbstractFloat

    Random.seed!(123);
    nTypes, n = size(value_ixM);
    success = true;

    for iType = 1 : nTypes
        success1 = check_one_by_sim(d, vec(value_ixM[iType,:]),  vec(prob_ixM[iType,:]),
            eVal_iV[iType]);
        success = success && success1;
    end

    return success
end


## Check one type by simulation
function check_one_by_sim(d :: ExtremeValueDecision,  valueV :: Vector{F},
    probV :: Vector{F},  eVal :: F)  where  F <: AbstractFloat

    # Random vars for all alternatives
    n = length(valueV);
    nSim = Int64(5e5);
    randM = rand(Gumbel(),  nSim, n);
    if d.demeaned
        randM .-= 0.5772;
    end

    # Values including pref shocks, by simulation, option
    valueM = valueV'  .-  randM .* d.prefScale;
    @assert size(valueM) == (nSim, n)

    # Find the max index for each simulation
    # findmax returns cartesian index tuples
    maxV, maxCartIdxV = findmax(valueM, dims = 2);
    @assert length(maxV) == nSim

    maxIdxV = zeros(Int64, nSim);
    for i1 = 1 : nSim
        cIdx = maxCartIdxV[i1];
        maxIdxV[cIdx[1]] = cIdx[2];
    end

    # Count how often each index occurs
    cntV = vectorLH.count_indices(maxIdxV) ./ nSim;
    diffV = cntV .- probV;

    if any(abs.(diffV) .> 5e-3)
       println("True probs:  ");
       @show probV
       println("\nSim probs:   ");
       @show cntV
       success = false;
   else
       success = true;
    end

    # Check expected value
    simVal = mean(maxV);
    if abs(simVal ./ eVal - 1.0) > 5e-3
       @printf "Discrepancy in values: %.3f vs %.3f \n"  simVal eVal;
       success = false;
    end

    return success
end

# ---------------
