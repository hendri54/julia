# Startup on longleaf
# Experimental. Attempt to make unregistered packages available

using OhMyREPL, Pkg

# ENV["JULIA_PKG_DEVDIR"] = joinpath(homedir(), "julia")

# Now we need to `add` all unregistered packages
# None of this is automatic. If `TestPkg2LH` uses `TestPkgLH`, the latter must be added first.
githubUrl = "https://github.com/hendri54/"

pkgNameV = ["TestPkgLH",  "TestPkg2LH"]
for pkgName in pkgNameV
	ps = PackageSpec(name = pkgName,  url = githubUrl * pkgName)
	Pkg.add(ps)
end

# This just makes sure everything was loaded
using TestPkg2LH
TestPkg2LH.show_version()


# -------
