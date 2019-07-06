module filesLHtest

using Test;
# include("filesLH.jl")
using configLH, filesLH

struct saveS
    x1
    x2
    x3
end

function file_path()
    return joinpath(configLH.test_dir(), "load_save_test.jld")
end

function load_save_test()
    xS = saveS(1.23, "abc", [1.2 2.3; 3.4 4.5]);

    fPath = file_path();

    filesLH.save(fPath, xS);

    yS = filesLH.load(fPath);

    @test isequal(xS.x1, yS.x1)
    @test isequal(xS.x2, yS.x2)

    return true
end

end
