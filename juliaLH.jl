# Helper code for Julia configuration
# This is contained in `ConfigLH`

using Pkg, PkgSkeleton
using Registrator


# const regPath = "/Users/lutz/Documents/julia/registryLH"


function create_private_registry()
    regUrl = githubUrl * "registryLH"
    create_registry(regPath, regUrl, description = "Lutz Hendricks registry")
end

function make_new_project(pkgPath :: String)
    PkgSkeleton.generate(pkgPath,
        skip_existing_dir = true, skip_existing_files = true)
end

# --------------
