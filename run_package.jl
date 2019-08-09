# Attempt run package from terminal

using Pkg
# wrong directly for longleaf +++
cd("/Users/lutz/Documents/julia/ConfigLH");
#cd("/nas/longleaf/home/lhendri/julia/ConfigLH");
Pkg.activate(".");
using ConfigLH
println(ConfigLH.julia_dir());

# -----------