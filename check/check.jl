#=
Replacement for validateattributes

All checks go through when there are NaN values

IN
    typeStr  ::  DataType
        e.g. Float64
        matches x being scalar or array of that type
  lb, ub
    can be scalars
=#
function validate(x, typeStr = []; sz = [], lb = [], ub = [], nonNan = true)

if isa(typeStr, DataType)
    @assert (typeof(x) == typeStr  ||  typeof(x) == Array{typeStr, ndims(x)})
end

  # if dropNan
  #   # Vector of nonNan values
  #   xNoNanV = filter(z -> !isnan(z),  vec(x));
  # end

  # Can check bounds including Nan values
  if !isempty(lb)
    if any(x .< lb)
      throw(ErrorException("Min x: $(minimum(x))"))
    end
  end
  if !isempty(ub)
    if any(x .> ub)
      throw(ErrorException("Max x: $(maximum(x))"))
    end
  end

  # Works when NaN present
  if !isreal(x)
    throw(ErrorException("Complex values encountered"))
  end
  if any(isinf.(x))
    throw(ErrorException("Inf encountered"))
  end

  if nonNan   #  &&  !dropNan
    if any(isnan.(x))
      throw(ErrorException("NaN encountered"))
    end
  end

  # Size of a scalar is ()
  if length(sz) > 0
    if !isequal(size(x), sz)
      throw(DimensionMismatch("size(x) = $(size(x)),  sz = $sz"))
    end
  end
end
