module modelLH

import Base.show
using Formatting

export ModelObject
export collect_model_objects, collect_pvectors, validate

const ValueType = Float64

include("model/parameters.jl")
include("model/param_vector.jl")
include("model/deviation.jl")


"""
## Abstract model object

Must have

Model may contain a ParamVector, but need not.

Child objects may be vectors. Then the vector must have a fixed element type that is
a subtype of `ModelObject`
"""

abstract type ModelObject end

# There is currently nothing to validate
# Code permits objects without ParamVector or child objects
function validate(m :: T1) where T1 <: ModelObject
    # @assert isa(m.hasParamVector, Bool)
    # @assert isa(get_child_objects(m), Vector)
    return nothing
end


"""
## Find the child objects
"""
function get_child_objects(o :: T1) where T1 <: ModelObject
    childV = Vector{Any}();
    for pn in propertynames(o)
        obj = getproperty(o, pn);
        if isa(obj, Vector)
            if eltype(obj) <: ModelObject
                append!(childV, obj)
            end
        else
            if typeof(obj) <: ModelObject
                push!(childV, obj);
            end
        end
    end
    return childV :: Vector
end


"""
## Find the ParamVector
"""
function get_pvector(o :: T1) where T1 <: ModelObject
    found = false;
    pvec = ParamVector();

    # Try the default field
    if isdefined(o, :pvec)
        if isa(o.pvec, ParamVector)
            pvec = o.pvec;
            found = true;
        end
    end

    if !found
        for pn = propertynames(o)
            obj = getproperty(o, pn);
            if isa(obj, ParamVector)
                pvec = obj;
                found = true;
                break;
            end
        end
    end
    return pvec :: ParamVector
end


"""
Does object contain ParamVector
"""
function has_pvector(o :: T1) where T1 <: ModelObject
    return length(get_pvector(o)) > 0
end


"""
## Collect all model objects inside an object
"""
function collect_model_objects(o :: T1) where T1 <: ModelObject
    outV = Vector{Any}();
    if has_pvector(o)
        push!(outV, o);
    end

    # Objects contained in `o`; including `selfObj` if `o` contains
    # calibrated parameters
    objV = get_child_objects(o);
    if !isempty(objV)
        for i1 = 1 : length(objV)
            append!(outV, collect_model_objects(objV[i1]));
        end
    end
    return outV :: Vector
end


function collect_pvectors(o)
    objV = collect_model_objects(o);
    pvecV = Vector{ParamVector}();
    for i1 = 1 : length(objV)
        push!(pvecV, get_pvector(objV[i1]));
    end
    return pvecV :: Vector{ParamVector}
end


"""
## Make vector of parameters and bounds for an object
Including nested objects
"""
function make_guess(m :: ModelObject)
    pvecV = collect_pvectors(m);
    guessV, lbV, ubV = modelLH.make_vector(pvecV, true);
    return guessV :: Vector{Float64}, lbV :: Vector{Float64}, ubV :: Vector{Float64}
end


"""
## Make vector of guesses into model parameters

how to deal with guess transformations +++++
"""
function set_params_from_guess!(m :: ModelObject, guessV :: Vector{Float64})
    # Copy guesses into model objects
    pvecV = collect_pvectors(m);
    objV = collect_model_objects(m);
    # Copy param vectors into model
    vOut = sync_from_vector!(objV, pvecV, guessV);
    # Make sure all parameters have been used up
    @assert isempty(vOut)
    return nothing
end


end
