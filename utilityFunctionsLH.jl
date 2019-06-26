module utilityFunctionsLH

abstract type UtilityFunction end
abstract type UtilityOneArg <: UtilityFunction end

include("econ/crra.jl")

end
