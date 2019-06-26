# Julia startup script

push!(LOAD_PATH, pwd())

using OhMyREPL
using Printf
using Random
using Test

using Revise
@async Revise.wait_steal_repl_backend()

using projectLH

# -----------
