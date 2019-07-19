module Test3

using InteractiveUtils
using Test1

function codetype()
    code_warntype(stdout, Test1.bar, (Int,))
end

end  # module
