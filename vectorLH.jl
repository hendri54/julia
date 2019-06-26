module vectorLH

using StatsBase

export countbool

# Count number of true elements in a vector
function countbool(xV :: Array{Bool, 1})
  count(z -> (z == true), xV)
end


"""
Count the number of times each element occurs in a vector
NaN is kept as a separate value unless `omitNan` is set

OUT
    outM
        matrix with values and counts as columns
"""
function count_elem(xV :: Array{T,1}, omitNan = false) where T <: Any
    if omitNan
        dictV = countmap(filter(y -> ~isnan(y), xV));
    else
        dictV = countmap(xV);
    end

    # Make dict into vector of counts
    countM = hcat([[key, val] for (key, val) in dictV]...)';
    # countV = zeros(T, size(xV));
    # for (key, val) in dictV
    #     countV[key] = val;
    # end
    return sortslices(countM, dims=1)
end


"""
Count the number of times each element occurs in a vector
Return vector of counts
Assumes that values are integer indices
"""
function count_indices(xV :: Array{T,1}) where T <: Integer
    countM = count_elem(xV, false);
    countV = zeros(Int64, maximum(countM[:,1]));
    countV[countM[:,1]] = countM[:, 2];
    return countV;
end

end
