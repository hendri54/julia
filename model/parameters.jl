"""
## Parameter

Default value must always be set. Determines size of inputs.
Everything else can be either empty or must have the same size.
"""

export Param
export calibrate!, fix!, set_value!, update!, validate

mutable struct Param{T1 <: Any, T2 <: AbstractString}
    name :: Symbol
    description :: T2
    symbol :: T2
    value :: T1
    defaultValue :: T1
    lb :: T1
    ub :: T1
    isCalibrated :: Bool
end


## Constructor when not calibrated
function Param(name :: Symbol, description :: T2, symbol :: T2, defaultValue :: T1) where
    {T1 <: Any,  T2 <: AbstractString}

    return Param(name, description, symbol, defaultValue, defaultValue,
        defaultValue .- 0.001, defaultValue .+ 0.001, false)
end


function validate(p :: Param)
    sizeV = size(p.defaultValue);
    if !Base.isempty(p.value)
        @assert size(p.value) == sizeV
    end
    if !Base.isempty(p.lb)
        @assert size(p.lb) == sizeV
        @assert size(p.ub) == sizeV
    end
    return nothing
end


"""
## Change / update
"""
function calibrate!(p :: Param)
    p.isCalibrated = true
    return nothing
end

function fix!(p :: Param)
    p.isCalibrated = false
    return nothing
end

function set_value!(p :: Param, vIn)
    p.value = vIn
end

function update!(p :: Param; value = nothing, defaultValue = nothing,
    lb = nothing, ub = nothing, isCalibrated = nothing)
    if !isnothing(value)
        set_value!(p, value)
    end
    if !isnothing(lb)
        p.lb = lb;
    end
    if !isnothing(ub)
        p.ub = ub;
    end
    if !isnothing(defaultValue)
        p.defaultValue = defaultValue;
    end
    if !isnothing(isCalibrated)
        p.isCalibrated = isCalibrated;
    end
    return nothing
end


"""
## Show
"""
function short_string(p :: Param)
    # improve value formatting +++
    return "$(p.name): $(p.value)"
end

function report_param(p :: Param)
    # improve value formatting +++
    println("$(p.name): $(p.description): $(p.value)")
end



# -----------
