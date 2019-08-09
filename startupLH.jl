# Julia startup script
# Should run on remote computer, which must replicate the same directory
# structure relative to `homedir()`

devDir = joinpath(homedir(), "Documents/julia");
@assert isdir(devDir);

ENV["JULIA_PKG_DEVDIR"] = devDir;

# Note that `sharedDir` cannot contain `Project.toml` for `using` to work
sharedDir = joinpath(devDir, "shared")
@assert isdir(sharedDir);
push!(LOAD_PATH, sharedDir);

using OhMyREPL
using Test
using Revise
@async Revise.wait_steal_repl_backend()

# This helps with managing packages
using PackageToolsLH

# -----------
