using Pkg, Test
using PackageToolsLH

#include(joinpath(@__DIR__,  "package_tools.jl"))

@testset "Package tools" begin
    pkgName = "TestPkgLH";
    comp = PackageToolsLH.current_computer();
    @test isa(comp, PackageToolsLH.Computer)
    
    @test isdir(PackageToolsLH.julia_dir())
    @test isa(PackageToolsLH.julia_dir(compName = :longleaf),  String)
    
    @test isdir(PackageToolsLH.test_file_dir())
    @test isdir(PackageToolsLH.shared_dir())
    @test isdir(PackageToolsLH.project_dir(2019))
    @test isdir(PackageToolsLH.develop_dir(pkgName))
    @test isa(PackageToolsLH.develop_dir(pkgName, compName = :longleaf), String)

    @test pkg_exists(pkgName)
    @test !pkg_exists("Abc")

    ps = PackageToolsLH.get_pkg_spec(pkgName);
    @test isa(ps, Pkg.Types.PackageSpec)

    ps = PackageToolsLH.local_pkg_spec(pkgName);
    @test isa(ps, Pkg.Types.PackageSpec)

    ps = PackageToolsLH.local_pkg_spec(pkgName, compName = :longleaf);
    @test isa(ps, Pkg.Types.PackageSpec)

	# Testing these changes `Project.toml`
	Pkg.activate(PackageToolsLH.test_file_dir())
    add_pkg(pkgName)
    remove_pkg(pkgName)

    develop_pkg(pkgName)
    test_pkg(pkgName)
    remove_pkg(pkgName)    
    
	include("pkg_tools/directories_test.jl")	
	include("pkg_tools/file_transfer_test.jl")
	include("pkg_tools/projects_test.jl")
	include("pkg_tools/sbatch_test.jl")
end

# ------------
