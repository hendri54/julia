# With Revise it seems that `using` is the right approach, not `include`
# Run this with `using`
# module test_allLH

# using Test

@testset "All" begin
    include("configLHtester.jl")
    # using configLH_test

    include("displayLHtester.jl")
    # using displayLH_test

    include("econLHtester.jl")
    include("filesLHtester.jl")
    # using filesLH_test
    include("LatexLHtester.jl")
    include("matrixLHtester.jl")
    include("modelLHtester.jl")
    # using matrixLHtest

    include("productionFunctionsLHtester.jl")
    # using productionFunctionsLH_test

    include("projectLHtester.jl")
    # using projectLH_test

    include("statsLHtester.jl")
    # using statsLH_test

    include("utilityFunctionsLHtester.jl");
    # using utilityFunctionsLH_test

    include("vectorLHtester.jl")
    # using vectorLH_test
end

# end
