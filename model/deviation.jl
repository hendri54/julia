using displayLH
import Base.show
export Deviation, scalar_dev, short_display
export DevVector, append!, length, retrieve, scalar_devs, show

"""
Deviation struct
"""
mutable struct Deviation{T1 <: AbstractString, T2 <: AbstractFloat}
    name  :: T1     # eg 'fracEnterIq'
    modelV  :: Array{T2}   # model values
    dataV  :: Array{T2}    # data values
    # relative weights, sum to 1; may be scalar
    wtV  :: Array{T2}
    scaleFactor  :: T2    # multiply model and data by this when constructing scalarDev
    shortStr  :: T1       # eg 'enter/iq'
    longStr  :: T1        # eg 'fraction entering college by iq quartile'
    fmtStr  :: T1         # for displaying the deviation
end


## Scalar deviation
# scaleFactor used to be inside the sum of squares
function scalar_dev(d :: Deviation)
   devV = d.wtV .* ((d.modelV - d.dataV)) .^ 2;
   scalarDev = d.scaleFactor .* sum(devV);
   scalarStr = sprintf1(d.fmtStr, scalarDev);

   return scalarDev, scalarStr
end


## Formatted short deviation for display
function short_display(d :: Deviation)
   _, scalarStr = scalar_dev(d);
   return d.shortStr * ": " * scalarStr;
end


"""
Deviation vector
"""
mutable struct DevVector
    dv :: Vector{Deviation}
end

function DevVector()
    DevVector(Vector{Deviation}())
end

function length(d :: DevVector)
    return length(d.dv)
end

function append!(d :: DevVector, dev :: Deviation)
    Base.push!(d.dv, dev)
end

function retrieve(d :: DevVector, dName :: T1) where
    T1 <: AbstractString

    n = length(d);
    if n < 1
        return nothing
    else
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
            return d.dv[dIdx]
        else
            return nothing
        end
    end
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
    if n < 1
        return nothing
    else
        devV = Vector{Float64}(undef, n);
        for i1 in 1 : n
            dev,_ = scalar_dev(d.dv[i1]);
            devV[i1] = dev;
        end
        return devV
    end
end

# -------------
