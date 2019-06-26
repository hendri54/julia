module matrixLH

export round_to_grid

"""
accumarray for linear indices
Due to Tim Holy
"https://groups.google.com/forum/#!topic/julia-users/QwdFHbbasis"

IN
    subs :: Vector
"""
function accumarrayTH(subs, val, sz=(maximum(subs),))
    A = zeros(eltype(val), sz...)
    for i = 1:length(val)
        A[subs[i]] += val[i]
    end
    A
end



"""
accumarray for matrices
"https://groups.google.com/forum/#!topic/julia-users/QwdFHbbasis"
"""
function accumarray(subs, val :: Array{T,1}, fun=sum,
    sz=maximum(subs, dims=1))  where T <: Real

   counts = Dict()
   for i = 1:size(subs,1)
       # Append value
       counts[subs[i,:]] = [get(counts, subs[i,:], []); val[i...]]
   end

   A = zeros(T, sz...);
   for j = keys(counts)
        A[j...] = fun(counts[j])
   end
   return A
end


"""
## Round to grid
"""
function round_to_grid(xM :: Array{T}, gridV :: Vector{T}) where T <: AbstractFloat
    idxM = similar(xM, Int);
    for (i1, x) in enumerate(xM)
        iMin = findmin(abs.(gridV .- x));
        idxM[i1] = iMin[2];
    end
    return idxM
end

end
