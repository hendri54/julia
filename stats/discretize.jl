## Discretize given percentiles (unweighted)
function discretize_given_percentiles(inV :: Vector{Float64}, pctV :: Vector{Float64}, dbg :: Bool = false)
    edgeV = bin_edges_from_percentiles(inV, pctV, dbg);
    return discretize(inV, edgeV, dbg);
end


## Discretize given percentiles (weighted)
function discretize_given_percentiles(inV :: Vector{Float64}, wtV :: AbstractWeights,
   pctV :: Vector{Float64}, dbg :: Bool = false)

   edgeV = bin_edges_from_percentiles(inV, wtV, pctV, dbg);
   return discretize(inV, edgeV, dbg);
end


## Discretize given bounds
function discretize(inV :: Vector{Float64}, edgeV :: Vector{Float64}, dbg :: Bool = false)
    n = length(edgeV);
    outV = zeros(Int64, size(inV));
    for i1 = n : -1 : 2
        outV[inV .<= edgeV[i1]] .= i1 - 1;
    end
    outV[inV .<= edgeV[1]] .= 0;
    return outV
end


## Bin edges from percentiles
"""
Bin edges from percentiles (unweighted)
Lowest bin includes minimum of inV
"""
function bin_edges_from_percentiles(inV :: Vector{Float64}, pctV :: Vector{Float64}, dbg :: Bool = false)
    edgeV = quantile(inV, [0.0; pctV]);
    # Ensure that lowest point is inside edges
    edgeV[1] -= 1e-8;
    if dbg
        @assert (minimum(inV) >= edgeV[1])
    end
    return edgeV
end


## Bin edges from percentiles (weighted)
function bin_edges_from_percentiles(inV :: Vector{Float64},  wtV :: AbstractWeights,
   pctV :: Vector{Float64},  dbg :: Bool = false)

   # Quantile is also a built in function
   edgeV = [minimum(inV) - 1e-8; StatsBase.quantile(inV, wtV, pctV)];
   edgeV[end] += 1e-8;
   if dbg
      @assert (all(inV .> edgeV[1]))
      if edgeV[end] == 1.0
         @assert (all(inV .< edgeV[end]))
      end
   end
   return edgeV
end
