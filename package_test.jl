# Testing reloading of packages

ENV["JULIA_PKG_DEVDIR"] = joinpath(homedir(), "Documents/julia")

using Pkg, OhMyREPL, Revise

# Need uuid for `test`
ps = PackageSpec(name = "TestPkgLH", url = "https://github.com/hendri54/TestPkgLH.git",
    uuid = "430be53e-b6e1-11e9-3835-cd004dc5e9d7")

Pkg.add(ps)
using TestPkgLH

TestPkgLH.print_version()

Pkg.update(ps)

TestPkgLH.print_version()

Pkg.develop(ps)

TestPkgLH.print_version()

Pkg.rm(ps)
Pkg.add(ps)
TestPkgLH.print_version()

Pkg.activate("TestPkgLH")

Pkg.test("TestPkgLH")

# For test, we cannot use package name or package spec or
# `pkg"test"`
# Pkg.test(ps)
# But [test works when activated "by hand"

# The only way of getting the updated version is REPL restart

# ---------
