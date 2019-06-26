module filesLHtest

using Test;
# include("filesLH.jl")
using filesLH

struct saveS
    x1
    x2
    x3
end

function load_save_test()
    xS = saveS(1.23, "abc", [1.2 2.3; 3.4 4.5]);

    fPath = "load_save_test.jld"

    filesLH.save(fPath, xS);

    yS = filesLH.load(fPath);

    @test isequal(xS.x1, yS.x1)
    @test isequal(xS.x2, yS.x2)

    return true
end

end
