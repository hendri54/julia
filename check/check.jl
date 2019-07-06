"""
## validate

Replacement for validateattributes
Numeric arrays only

All checks go through when there are NaN values

IN
    typeStr  ::  DataType
        e.g. Float64
        matches x being scalar or array of that type
  lb, ub
    can be scalars
"""
function validate(x, typeStr = Float64; sz = [], lb = [], ub = [], nonNan = true)
    if isa(typeStr, DataType)
        if !isa(x, Array{typeStr})
            throw(ErrorException("Not Array of $typeStr"))
        end
    end

    check_bounds(x, lb, ub);

    # Works when NaN present
    # if !isreal(x)
    #   throw(ErrorException("Complex values encountered"))
    # end
    if any(isinf.(x))
    throw(ErrorException("Inf encountered"))
    end

    if nonNan
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
    return nothing
end


"""
## Validate numerical scalar
"""
function validate_scalar(x, typeStr = Float64; lb = [], ub = [], nonNan = true)
    if isa(typeStr, DataType)
        if !isa(x, typeStr)
            throw(ErrorException("Not a $typeStr"))
        end
    end
    check_bounds(x, lb, ub);
    if any(isinf.(x))
        throw(ErrorException("Inf encountered"))
    end
    if nonNan
        if any(isnan.(x))
            throw(ErrorException("NaN encountered"))
        end
    end
    return nothing
end


"""
## Check bounds
"""
function check_bounds(x, lb, ub)
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
    return nothing
end

# -----------
