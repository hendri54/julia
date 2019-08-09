"""
This file is to be run once when a new version is installed.
"""
Pkg.add("OhMyREPL")
Pkg.add("Revise")
Pkg.add("BSON")
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("Debugger")
Pkg.add("Distributions")
Pkg.add("FileIO")
Pkg.add("Formatting")
Pkg.add("JLD")
Pkg.add("Plots")
Pkg.add("Profile")
# Pkg.add("ProfileView")
Pkg.add("SpecialFunctions")
Pkg.add("StatProfilerHTML")
Pkg.add("StatsBase")
Pkg.add("StatsFuns")

# This may not run as expected (from the REPL, I had to use `] add`)
Pkg.add("https://github.com/hendri54/ConfigLH.git")
