module econLH

using StatsFuns

include("econ/extreme_value_decision.jl")


"""
Present value of a function of time
First value is not discounted.
"""
function present_value(f, R :: T1, T :: T2) where
    {T1 <: AbstractFloat, T2 <: Integer}

    return sum(f.(1 : T) ./ (R .^ (1:T))) .* R;
end

end # module
