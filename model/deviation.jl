"""
Model/data deviations for calibration

Intended workflow:
* Set up deviations while defining model. Load in the data.
* After solving the model: fill in model values.
* Compute deviations for calibration.
* Report deviations.
* Show model fit. (All the last steps can simply work of the deviation vector)
"""

using displayLH
import Base.show, Base.isempty, Base.length
export Deviation, scalar_dev, short_display
export DevVector, append!, length, retrieve, scalar_devs, show

const DevType = Float64

"""
Deviation struct
"""
mutable struct Deviation
    name  :: Symbol     # eg 'fracEnterIq'
    modelV  :: Array{DevType}   # model values
    dataV  :: Array{DevType}    # data values
    # relative weights, sum to 1
    wtV  :: Array{DevType}
    # scaleFactor  :: T2    # multiply model and data by this when constructing scalarDev
    shortStr  :: String       # eg 'enter/iq'
    longStr  :: String   # eg 'fraction entering college by iq quartile'
    # For displaying the deviation. Compatible with `Formatting.sprintf1`
    # E.g. "%.2f"
    fmtStr  :: String
end


"""
Deviation vector
"""
mutable struct DevVector
    dv :: Vector{Deviation}
end


"""
## Deviation struct
"""

# Empty deviation. Mainly as return object when no match is found
# in DevVector
function Deviation()
    return Deviation(:empty, [0.0], [0.0], [0.0], "", "", "")
end


function isempty(d :: Deviation)
    return d.name == :empty
end


function set_model_values(d :: Deviation, modelV)
    @assert size(modelV) == size(d.dataV)
    d.modelV = modelV;
    return nothing
end


"""
## Scalar deviation

Scaled to produce essentially an average deviation.
That is: if all deviations in a vector are 0.1, then `scalar_dev = 0.1`
"""
function scalar_dev(d :: Deviation)
    @assert size(d.modelV) == size(d.dataV)

    devV = d.wtV ./ sum(d.wtV) .* ((d.modelV .- d.dataV) .^ 2);
    scalarDev = sum(devV) .^ 0.5;
    scalarStr = sprintf1(d.fmtStr, scalarDev);

    return scalarDev :: DevType, scalarStr
end


## Formatted short deviation for display
function short_display(d :: Deviation)
   _, scalarStr = scalar_dev(d);
   return d.shortStr * ": " * scalarStr;
end


"""
## Deviation vector
"""

function DevVector()
    DevVector(Vector{Deviation}())
end

function length(d :: DevVector)
    return Base.length(d.dv)
end

function append!(d :: DevVector, dev :: Deviation)
    @assert !modelLH.exists(d, dev.name)  "Deviation $(dev.name) already exists"
    Base.push!(d.dv, dev)
end

function set_model_values(d :: DevVector, name :: Symbol, modelV :: Array{DevType})
    dev = retrieve(d, name);
    @assert !modelLH.isempty(dev)
    set_model_values(dev, modelV)
    return nothing
end


"""
Retrieve

If not found: return empty Deviation
"""
function retrieve(d :: DevVector, dName :: Symbol)
    outDev = Deviation();

    n = length(d);
    if n > 0
        dIdx = 0;
        for i1 in 1 : n
            #println("$i1: $(d.dv[i1].name)")
            if d.dv[i1].name == dName
                dIdx = i1;
                break;
            end
            #println("  not found")
        end
        if dIdx > 0
            outDev = d.dv[dIdx];
        end
    end
    return outDev :: Deviation
end


function exists(d :: DevVector, dName :: Symbol)
    return !modelLH.isempty(retrieve(d, dName))
end


function show(d :: DevVector)
    if length(d) < 1
        println("No deviations");
    else
        lineV = Vector{String}();
        for i1 in 1 : length(d)
            dStr = short_display(d.dv[i1]);
            push!(lineV, dStr);
        end
    end
    displayLH.show_string_vector(lineV, 80);
end


function scalar_devs(d :: DevVector)
    n = length(d);
    if n > 0
        devV = Vector{DevType}(undef, n);
        for i1 in 1 : n
            dev,_ = scalar_dev(d.dv[i1]);
            devV[i1] = dev;
        end
    else
        devV = Vector{DevType}();
    end
    return devV
end

# -------------
