export CRRA, utility, marginal_utility, cons_growth, cons_path,
    euler_deviation, lifetime_utility,
    pv_consumption

mutable struct CRRA <: UtilityOneArg
   sigma  ::  Float64
   dbg  ::  Bool
end

function utility(uS :: CRRA, cM :: Array{T1}) where
    T1 <: AbstractFloat

    if uS.dbg
        @assert all(cM .> 0.0)  "Negative consumption"
    end

  if uS.sigma == 1.0
    utilM = log(cM)
  else
     oneMinusSigma = 1.0 - uS.sigma;
     utilM = (cM .^ oneMinusSigma) ./ oneMinusSigma .- 1.0
     # muM = cM .^ (-pSigma)
  end
  return utilM
end


function marginal_utility(uS :: CRRA, cM :: Array{T1}) where
    T1 <: AbstractFloat

    if uS.dbg
        @assert all(cM .> 0.0)  "Negative consumption"
    end

    if uS.sigma == 1.0
        muM = 1.0 ./ cM;
    else
        muM = cM .^ (-uS.sigma);
    end
    return muM
end


"""
Euler equation deviation
"""
function euler_deviation(uS :: UtilityOneArg, beta :: T1, R :: T1,
    cV :: Vector{T1}) where T1 <: AbstractFloat

    muV = marginal_utility(uS, cV);
    T = length(muV);
    return muV[2 : T] .* beta .* R ./ muV[1 : (T-1)] .- 1.0;
end


function cons_growth(uS :: CRRA,  betaR :: T1) where
    T1 <: AbstractFloat

    return betaR .^ (1.0 ./ uS.sigma)
end


"""
Present value of consumption as multiple of c1
Periods 1...T. First not discounted
"""
function pv_consumption(uS :: CRRA,
    beta :: T1, R :: T1, T :: T2) where
    {T1 <: AbstractFloat, T2 <: Integer}

    g = cons_growth(uS, beta * R);
    return ((g/R) ^ T - 1.0) / (g/R - 1.0)
end


"""
Consumption path
"""
function cons_path(uS :: CRRA, beta :: T1, R :: T1, T :: T2,
    ltIncome :: T1) where {T1 <: AbstractFloat, T2 <: Integer}

    c1 = ltIncome ./ pv_consumption(uS, beta, R, T);
    g = cons_growth(uS, beta .* R);
    return c1 .* (g .^ (0 : (T-1)))
end

"""
Lifetime utility, given present value of income
"""
function lifetime_utility(uS :: CRRA, beta :: T1, R :: T1, T :: T2,
    ltIncome :: T1) where {T1 <: AbstractFloat, T2 <: Integer}

    if uS.dbg
        @assert ltIncome .> 0.0  "Negative income"
    end
    utilV = utility(uS, cons_path(uS, beta, R, T, ltIncome));
    return sum((beta .^ (0 : (T-1))) .* utilV);
end


# -----------
