# Print numeric vector (or array with 1 dim)
#=
IN
    fmtStr
        formatting string that works with Formatting package
=#
function sprintf(fmtStr :: String, x :: Array{T}) where T <: Number
    x2 = vec(x)
    outStr = "";
    for xVal in x2
      outStr = outStr * Formatting.format(fmtStr, xVal)
    end
    return outStr
end

# Scalar input
function sprintf(fmtStr :: String, x :: T1) where T1 <: Number
    return sprintf(fmtStr, [x])
end


function printf(fmtStr :: String,  x :: Array{T}) where T <: Number
    print(displayLH.sprintf(fmtStr, x));
    return nothing
end
