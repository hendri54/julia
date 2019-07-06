# With Revise it seems that `using` is the right approach, not `include`
# Run this with `using`
# module test_allLH

# Changing pwd is not advisable within tests. Does not seem to work (1.1)

# using Test

@testset "All" begin
    include("checkLHtester.jl")
    include("configLHtester.jl")
    include("displayLHtester.jl")
    include("econLHtester.jl")
    include("filesLHtester.jl")
    include("LatexLHtester.jl")
    include("matrixLHtester.jl")
    include("modelLHtester.jl")
    include("productionFunctionsLHtester.jl")
    include("projectLHtester.jl")
    include("statsLHtester.jl")
    include("utilityFunctionsLHtester.jl");
    include("vectorLHtester.jl")

    # sharedDir = pwd();
    # proj = project_start("sampleModel")
    # println(pwd())
    # include(joinpath(proj.progDir, "TestAll.jl"));
    # cd(sharedDir);
end

# end
