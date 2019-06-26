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
      outStr = outStr * format(fmtStr, xVal)
    end
    return outStr
end


function printf(fmtStr :: String,  x :: Array{T}) where T <: Number
    print(displayLH.sprintf(fmtStr, x));
    return nothing
end
