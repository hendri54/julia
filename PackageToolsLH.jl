"""
Package handling code

This is not in a package because it is designed to help with loading
unregistered packages

Assumes that packages hang off a common directory `julia_dir()`
"""
module PackageToolsLH

export pkg_exists, activate_pkg, develop_pkg, add_pkg, remove_pkg, test_pkg
export rsync_pkg, rsync_shared
export add_to_path!, remove_from_path!

using Pkg, Test

## Mapping of names to UUIDs
pkgList = Dict(["TestPkgLH" => "430be53e-b6e1-11e9-3835-cd004dc5e9d7",
    "TestPkg2LH" => "4e2d2e59-2624-5a4c-88c1-3d17c23cb908",
    "CommonLH" => "96c8dc4a-d23f-53b2-b478-aad5d5ab80bd",
    "EconLH" => "e3939c25-9e30-5b59-80eb-f399ae42cd76",
    "ModelParams" => "4089ccbe-b1dc-5f86-a141-4606b18b4241",
    "SampleModel" => "baca8756-f3e0-5c0e-9c56-99e4124d7c11"]);


githubUrl = "https://github.com/hendri54/";

include("pkg_tools/computers.jl")
include("pkg_tools/directories.jl")
include("pkg_tools/packages.jl")
include("pkg_tools/file_transfer.jl")

# --------  rsync


end # module
