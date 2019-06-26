module configLHtest

using Test
# include("configLH.jl")
using configLH


function computer_test()
    currentComp = configLH.current_computer()
    @test currentComp == configLH.ComputerLocal

    ci = configLH.computer_info(currentComp)
    @test ci.runLocal
    @test isdir(ci.baseDir)
    ci = configLH.computer_info()
    @test ci.runLocal

    @test isdir(configLH.docu_dir(currentComp))
    @test isdir(configLH.docu_dir())

    @test configLH.running_local()

    @test isdir(configLH.shared_dir())
    @test isdir(configLH.julia_dir())

    @test isdir(configLH.project_dir(2018))
end

end
