"""
Parameter vector

Intended workflow:
    See `modelTest()`
    Create a model object with parameters as fields
        Otherwise the code gets too cumbersome
        Constructor initializes parameter vector with defaults (or user inputs)
    During calibration
        Each object generates a Dict of calibrated parameters
        Make into a vector of Floats
        Optimization algorithm changes the floats
        Make floats back into Dict
        Copy back into model objects

Going from a vector of Dicts to a vector of Floats and back:
    Easy for a single `ParamVector`
    `modelTest()` contains flow for multiple objects

Parameters contain values, not just default values
They are kept in sync with values in object
"""

import Base.length, Base.append!
export ParamVector
export append!, exists, make_dict, make_vector
export param_value, retrieve, vector_to_dict

mutable struct ParamVector
    pv :: Vector{Param}
end

## Constructor
function ParamVector()
    return ParamVector(Vector{Param}())
end

function length(pvec :: ParamVector)
    return Base.length(pvec.pv)
end


"""
## Retrieve
Returns the index of a named parameter
First occurrence. Returns 0 if not found
"""
function retrieve(pvec :: ParamVector, pName :: Symbol)
    idxOut = 0;
    n = length(pvec);
    if n > 0
        for idx = 1 : n
            p = pvec.pv[idx];
            if p.name == pName
                idxOut = idx;
                found = true;
                break
            end
        end
    end
    if idxOut > 0
        p = pvec.pv[idxOut]
        return p, idxOut
    else
        return nothing, 0
    end
end

function exists(pvec :: ParamVector, pName :: Symbol)
    _, idx = retrieve(pvec, pName);
    return idx > 0
end

function param_value(pvec :: ParamVector, pName :: Symbol)
    p, idx = retrieve(pvec, pName);
    if idx > 0
        return p.value;
    else
        return nothing
    end
end


"""
## Modify
"""
function append!(pvec :: ParamVector,  p :: Param)
    @assert !exists(pvec, p.name)  "$(p.name) already exists"
    push!(pvec.pv, p)
    return nothing
end

function remove!(pvec :: ParamVector, pName :: Symbol)
    _, idx = retrieve(pvec, pName);
    @assert (idx > 0)  "$pName does not exist"
    deleteat!(pvec.pv, idx);
    return nothing
end

function replace!(pvec :: ParamVector, p :: Param)
    remove!(pvec, p.name);
    append!(pvec, p);
    return nothing
end


# test this +++++
function change_value!(pvec :: ParamVector, pName :: Symbol, newValue)
    _, idx = retrieve(pvec, pName);
    @assert (idx > 0)  "$pName does not exist"
    set_value!(pvec.pv[idx], newValue);
    return nothing
end

"""
## Collect into Dict
"""
function make_dict(pvec :: ParamVector, isCalibrated :: Bool)
    n = length(pvec);
    if n < 1
        pd = nothing
    else
        pd = Dict{Symbol, Any}()
        for i1 in 1 : n
            p = pvec.pv[i1];
            if p.isCalibrated == isCalibrated
                pd[p.name] = p.value;
            end
        end
    end
    return pd
end


"""
## Make vector of values, lb, ub for optimization algorithm
"""
function make_vector(pvec :: ParamVector, isCalibrated :: Bool)
    n = length(pvec);
    if n < 1
        valueV = nothing
        lbV = nothing;
        ubV = nothing;
    else
        p = pvec.pv[1];
        T1 = Float64;
        valueV = Vector{T1}();
        lbV = Vector{T1}();
        ubV = Vector{T1}();
        for i1 in 1 : n
            p = pvec.pv[i1];
            if p.isCalibrated == isCalibrated
                # Append works for scalars, vectors, and matrices (that get flattened)
                # Need to qualify - otherwise local append! is called
                Base.append!(valueV, p.value);
                Base.append!(lbV, p.lb);
                Base.append!(ubV, p.ub);
            end
        end

        @assert isa(valueV, Vector{T1})
        @assert isa(lbV, Vector{T1})
        @assert isa(ubV, Vector{T1})
    end
    return valueV, lbV, ubV
end


"""
## Make a vector into a Dict

The inverse of `make_vector`

OUT
    pd :: Dict
        maps param names (symbols) to values
    iEnd :: Integer
        number of elements of `v` used up
"""
function vector_to_dict(pvec :: ParamVector, v :: Vector{T1},
    isCalibrated :: Bool) where T1 <: AbstractFloat

    n = length(pvec);
    @assert n > 0  "Parameter vector is empty"

    pd = Dict{Symbol, Any}();
    # Last index of `v` used so far
    iEnd = 0;
    for i1 in 1 : n
        p = pvec.pv[i1];
        if p.isCalibrated == isCalibrated
            nElem = length(p.defaultValue);
            if nElem == 1
                pd[p.name] = v[iEnd + 1];
            else
                idxV = (iEnd + 1) : (iEnd + nElem);
                pd[p.name] = reshape(v[idxV], size(p.defaultValue));
            end
            iEnd += nElem;
        end
    end
    return pd, iEnd
end


"""
## Set values in param vector from dictionary

test this +++++
"""
function set_values_from_dict!(pvec :: ParamVector, d :: Dict{Symbol,Any})
    for (pName, newValue) in d
        change_value!(pvec, pName :: Symbol, newValue);
    end
    return nothing
end


"""
## Set fields in a struct from a Dict{Symbol, Any}
"""
function set_values_from_dict!(x,  d :: Dict{Symbol, Any})
    for (k, val) in d
        if k ∈ propertynames(x)
            setfield!(x, k, val);
        else
            @warn "Field $k not found"
        end
    end
    return nothing
end


"""
## Set fields in struct from param vector
"""
function set_values_from_pvec!(x, pvec :: ParamVector, isCalibrated :: Bool)
    d = make_dict(pvec, isCalibrated);
    set_values_from_dict!(x, d);
    return nothing
end

# ------------------
