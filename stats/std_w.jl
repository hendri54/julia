export std_w

function std_w(xM :: Array{T}, wtM :: Array{T}) where T <: AbstractFloat
# Std dev, weighted data
#=
Negative weights are not allowed
=#

xV = vec(xM)
wtV = AnalyticWeights(vec(wtM))

## Input check
if any(wtV .< 0.0)
  error("Invalid weights")
end

# wtSum = sum(wtV);
# xMean = sum(xV .* wtV) / wtSum;
# xStd  = sqrt(sum(((xV .- xMean) .^ 2) .* wtV)  /  wtSum);

xMean, xStd = mean_and_std(xV, wtV, corrected = false);
# xStd = std(xV, wtV);

return xStd, xMean

end
