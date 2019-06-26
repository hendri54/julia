export std_std

using SpecialFunctions

function std_std(xStdV :: Vector{T1}, nObsV :: Vector{T2}, dbg :: Bool) where {T1 <: AbstractFloat, T2 <: Integer}
# Standard deviation of the standard deviation of a Normal sample with size nObs
#=
Source: http://stats.stackexchange.com/questions/631/standard-deviation-of-standard-deviation

IN
  xStd
     std dev of x
  nObs
     no of observations
=#

n = length(xStdV);

##  Main

stdStdV = zeros(n);
for ix = 1 : n
   nObs = Float64(nObsV[ix]);
   if nObs < 300
       # Gamma function from SpecialFunctions
      gamma1 = gamma((nObs - 1.0) / 2.0)
      gamma2 = gamma(nObs / 2.0)
   else
      # Approximation
      #  See https://en.wikipedia.org/wiki/Gamma_function#Approximations
      z1 = (nObs - 1.0) / 2.0 - 1.0;
      z2 = nObs / 2.0 - 1.0;
      gamma2 = 1.0;
      gamma1 = exp(0.5 * log(z1) + z1 * (log(z1) - 1) - 0.5 * log(z2) - z2 * (log(z2) - 1));
   end

   # Ratio of gamma2 / gamma1
   g21 = gamma2 / gamma1;

   stdStdV[ix] = xStdV[ix] / g21 * sqrt((nObs-1) / 2 - g21 ^ 2);
end


##  Output check
if dbg
   @assert (all(stdStdV .>= 0));
end

return stdStdV
end
