# Print numeric vector (or array with 1 dim)
#=
IN
    fmtStr
        formatting string that works with Formatting package
=#
function sprintf{T <: Number}(fmtStr :: String, x :: Array{T})
    x2 = vec(x)
    outStr = "";
    for xVal in x2
      outStr = outStr * format(fmtStr, xVal)
    end
    return outStr
end


function printf{T <: Number}(fmtStr :: String,  x :: Array{T})
    print(displayLH.sprintf(fmtStr, x));
    return nothing
end
