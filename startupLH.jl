# Julia startup script

push!(LOAD_PATH, pwd())

using OhMyREPL
using Printf
using Random, StatsBase
using Test

using Revise
@async Revise.wait_steal_repl_backend()

using projectLH

# -----------
