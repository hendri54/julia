"""
Simple minded density for weighted data

Compute cdf
Take its derivative

OUT
    densityV  ::  Float64
        mass / interval width
    midV  ::  Float64
        interval mid points
"""
function density_weighted(xV :: Array{T,1}, wtV :: Array{T,1}, dbg :: Bool) where T <: Real

## Input check

n = length(xV);
if dbg
    @assert (all(wtV .>= 0))
    @assert (size(wtV) == size(xV))
end

## Main

# Construct cdf
# Drop too small weights
idxV = findall(wtV .> 1e-6);
n = length(idxV);
if n < 2
    error("No observations");
end

sortM = sortslices([xV[idxV] wtV[idxV]],  dims = 1);
cumWtV = cumsum(sortM[:,2]) ./ sum(sortM[:,2]);
xSortV = sortM[:,1];

# Density = d(cumulative weight) / dx
densityV = (cumWtV[2:n] - cumWtV[1 : (n-1)]) ./ (xSortV[2:n] - xSortV[1 : (n-1)]);
xMidV = 0.5 .* (xSortV[2:n] + xSortV[1 : (n-1)]);


## Output check
if dbg > 10
    @assert (all(densityV .> 0));
end
return densityV, xMidV

end
