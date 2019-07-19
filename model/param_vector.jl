"""
Parameter vector

Intended workflow:
    See `SampleModel`
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
    `make_guess`
    `set_params_from_guess!`
    These are called on the top level model object

Parameters contain values, not just default values
They are kept in sync with values in object
"""

import Base.length, Base.append!
export ParamVector
export append!, exists, make_dict, make_vector
export param_value, retrieve, vector_to_dict

mutable struct ParamVector
    objId :: ObjectId
    pv :: Vector{Param}
end

## Constructor
function ParamVector(id :: ObjectId)
    return ParamVector(id, Vector{Param}())
end

function length(pvec :: ParamVector)
    return Base.length(pvec.pv)
end

# Check that param vector matches model object
function check_match(pvec :: ParamVector, objId :: ObjectId)
    return modelLH.isequal(pvec.objId, objId)
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

function change_calibration_status!(pvec :: ParamVector, pName :: Symbol,
    doCal :: Bool)

    _, idx = retrieve(pvec, pName);
    @assert (idx > 0)  "$pName does not exist"
    if doCal
        calibrate!(pvec.pv[idx])
    else
        fix!(pvec.pv[idx])
    end
end

function change_value!(pvec :: ParamVector, pName :: Symbol, newValue)
    _, idx = retrieve(pvec, pName);
    @assert (idx > 0)  "$pName does not exist"
    set_value!(pvec.pv[idx], newValue);
    return nothing
end


"""
## Report

Reports calibrated (or fixed) parameters for one ParamVector
"""
function report_params(pvec :: ParamVector, isCalibrated :: Bool)
    objId = make_string(pvec.objId);
    println("Object id:  $objId")
    n = length(pvec);
    if n < 1
        return nothing
    end
    for i1 = 1 : n
        if pvec.pv[i1].isCalibrated == isCalibrated
            report_param(pvec.pv[i1])
        end
    end
    return nothing
end


"""
Number of calibrated parameters
"""
function n_calibrated_params(pvec :: ParamVector, isCalibrated :: Bool)
    nParams = 0;
    nElem = 0;
    n = length(pvec);
    if n > 0
        for i1 = 1 : n
            if pvec.pv[i1].isCalibrated == isCalibrated
                nParams += 1;
                nElem += length(pvec.pv[i1].value);
            end
        end
    end
    return nParams, nElem
end

"""
## Collect values or default values into Dict

Used to go back and forth between guess and model parameters
"""
function make_dict(pvec :: ParamVector, isCalibrated :: Bool,
    useValues :: Bool)

    n = length(pvec);
    if n < 1
        pd = nothing
    else
        pd = Dict{Symbol, Any}()
        for i1 in 1 : n
            p = pvec.pv[i1];
            if p.isCalibrated == isCalibrated
                if useValues
                    pd[p.name] = p.value;
                else
                    pd[p.name] = p.defaultValue;
                end
            end
        end
    end
    return pd
end

# Typically, useValues when calibrated; defaults otherwise
function make_dict(pvec :: ParamVector, isCalibrated :: Bool)
    if isCalibrated
        useValues = true;
    else
        useValues = false;
    end
    make_dict(pvec, isCalibrated, useValues)
end


"""
## Make vector of values, lb, ub for optimization algorithm
"""
function make_vector(pvec :: ParamVector, isCalibrated :: Bool)
    T1 = ValueType;
    valueV = Vector{T1}();
    lbV = Vector{T1}();
    ubV = Vector{T1}();

    n = length(pvec);
    if n > 0
        # p = pvec.pv[1];
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
    end
    return valueV :: Vector{T1}, lbV :: Vector{T1}, ubV :: Vector{T1}
end


"""
## Make vector from a list of param vectors
"""
function make_vector(pvv :: Vector{ParamVector}, isCalibrated :: Bool)
    outV = Vector{ValueType}();
    lbV = Vector{ValueType}();
    ubV = Vector{ValueType}();
    for i1 = 1 : length(pvv)
        v, lb, ub = make_vector(pvv[i1], isCalibrated);
        append!(outV, v);
        append!(lbV, lb);
        append!(ubV, ub);
    end
    return outV :: Vector{ValueType}, lbV :: Vector{ValueType}, ubV :: Vector{ValueType}
end


"""
## Make a vector into a Dict

The inverse of `make_vector`
Used to go back from vector to model parameters

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
## Set fields in struct from param vector (using values, not defaults)
"""
function set_values_from_pvec!(x, pvec :: ParamVector, isCalibrated :: Bool)
    d = make_dict(pvec, isCalibrated, true);
    set_values_from_dict!(x, d);
    return nothing
end


"""
## Set default values from param vector
Typically for non-calibrated parameters
"""
function set_default_values!(x, pvec :: ParamVector, isCalibrated :: Bool)
    d = make_dict(pvec, isCalibrated, false);
    set_values_from_dict!(x, d);
    return nothing
end


"""
## Sync all values from param vector into object
"""
function sync_values!(x, pvec :: ParamVector)
    set_values_from_pvec!(x, pvec, true);
    set_default_values!(x, pvec, false);
end


"""
## Check that param vector values are consistent with object values
"""
function check_calibrated_params(x, pvec)
    d = make_dict(pvec, true);
    valid = true;
    for (pName, pValue) in d
        isValid = getproperty(x, pName) ≈ pValue;
        if ~isValid
            valid = false;
            @warn "Invalid value: $pName"
        end
    end
    return valid
end

function check_fixed_params(x, pvec)
    # Make dict of default values for non-calibrated params
    d = make_dict(pvec, false);
    valid = true;
    for (pName, pValue) in d
        isValid = getproperty(x, pName) ≈ pValue;
        if ~isValid
            valid = false;
            @warn "Invalid value: $pName"
        end
    end
    return valid
end


"""
## Copy values from vector into param vector and object
Calibrated parameters
Uses the first `nUsed` values in `vAll`
"""
function sync_from_vector!(x, pvec :: ParamVector, vAll :: Vector{ValueType})
    d11, nUsed1 = vector_to_dict(pvec, vAll, true);
    set_values_from_dict!(pvec, d11);
    set_values_from_pvec!(x, pvec, true);
    return nUsed1
end

# The same using vector inputs
# OUT: vAll: remaining values of vAllInV
function sync_from_vector!(xV, pvecV :: Vector{ParamVector}, vAllInV :: Vector{ValueType})
    vAll = copy(vAllInV);
    for i1 = 1 : length(pvecV)
        # check that ParamVector matches model object
        @assert check_match(pvecV[i1], xV[i1].objId);
        nUsed = sync_from_vector!(xV[i1], pvecV[i1], vAll);
        deleteat!(vAll, 1 : nUsed);
    end
    # Last object: everything should be used up
    # @assert isempty(vAll)  "Not all vector elements used"

    return vAll
end

# ------------------
