module modelLHtest

using modelLH
using Test

include("model/deviation_test.jl")

"""
## Parameter
"""
function paramTest()
    pValue = [1.1 2.2; 3.3 4.4]

    # Simple constructor
    p1 = Param(:p1, "param1", "\$p_{1}\$", pValue);
    @test p1.value == pValue
    @test size(p1.lb) == size(pValue)
    calibrate!(p1)
    @test p1.isCalibrated == true
    fix!(p1)
    @test p1.isCalibrated == false
    validate(p1)

    # Full constructor
    pValue2 = 1.23
    lb2 = -2.8
    ub2 = 7.3
    p2 = Param(:p2, "param2", "\$p_{2}\$", pValue2, pValue2 + 0.5,
        lb2, ub2, true)
    @test p2.value == pValue2
    @test size(p2.ub) == size(pValue2)
    newValue = 9.27
    set_value!(p2, newValue)
    @test p2.value ≈ newValue
    str1 = modelLH.short_string(p2)
    @test str1 == "p2: 9.27"

    update!(p2, value = 98.2)
    @test p2.value == 98.2
    @test p2.lb == lb2
    update!(p2, lb = -2.0, ub = 8.0)
    @test p2.lb == -2.0
    @test p2.value == 98.2
    validate(p2)

    return true
end


"""
## Parameter vector
"""
function pvectorTest()
    pv = ParamVector();
    @test length(pv) == 0
    p = Param(:p1, "param1", "sym1", [1.2 3.4; 4.5 5.6])
    modelLH.append!(pv, p)
    @test length(pv) == 1

    pOut, idx = retrieve(pv, :p11)
    @test idx == 0
    @test !exists(pv, :p11)
    pOut, idx = retrieve(pv, :p1)
    @test idx == 1
    @test pOut.name == :p1
    @test exists(pv, :p1)

    p = Param(:p2, "param2", "sym2", [2.2 4.4; 4.5 5.6])
    modelLH.append!(pv, p)
    modelLH.remove!(pv, :p1)
    @test length(pv) == 1
    @test exists(pv, :p2)
    @test !exists(pv, :p1)

    # Test replace
    p2 = Param(:p2, "param2", "sym2", 1.0);
    modelLH.replace!(pv, p2);
    p22, _ = retrieve(pv, :p2);
    @test p22.value == 1

    # Retrieve non-existing
    p3, idx = retrieve(pv, :notThere);
    @test isnothing(p3) && (idx == 0)

    # Parameter value
    pValue = param_value(pv, :p2);
    @test pValue == p2.value
    pValue = param_value(pv, :notThere);
    @test isnothing(pValue)

    return true
end

function pvectorDictTest()
    # Setup
    pv = ParamVector();
    p1 = Param(:p1, "param1", "sym1", [1.2 3.4 4.4; 4.5 5.6 7.7])
    calibrate!(p1)
    modelLH.append!(pv, p1)
    p2 = Param(:p2, "param2", "sym2", 2.0 .+ [1.2 3.4; 4.5 5.6])
    modelLH.append!(pv, p2)
    p3 = Param(:p3, "param3", "sym3", 2.0 .+ [1.2 3.4; 4.5 5.6])
    modelLH.append!(pv, p3)
    calibrate!(p3)

    d = make_dict(pv, true)
    @test d[:p1] == p1.value
    @test d[:p3] == p3.value
    @test length(d) == 2

    # Make vector and its inverse (make Dict from vector)
    isCalibrated = true;
    valV, lbV, ubV = make_vector(pv, isCalibrated);
    @test isa(valV,  Vector{Float64})
    @test valV == vcat(vec(p1.value), vec(p3.value))
    @test lbV == vcat(vec(p1.lb), vec(p3.lb))

    pDict, _ = vector_to_dict(pv, valV, isCalibrated);
    @test length(pDict) == 2
    @test pDict[:p1] == p1.value
    @test pDict[:p3] == p3.value

    return true
end


"""
## Test model
"""
mutable struct Obj1
    x :: Float64
    y :: Vector{Float64}
    z :: Array{Float64,2}
    # pv :: ParamVector
end

# function Obj1(x, y, z)
#     return Obj1(x, y, z, ParamVector())
# end

function init_obj1()
    px = Param(:x, "x obj1", "x1", 11.1, 9.9, 1.1, 99.9, true);
    valueY = [1.1, 2.2];
    py = Param(:y, "y obj1", "y1", valueY, valueY .+ 1.0,
        valueY .- 5.0, valueY .+ 5.0, true);
    valueZ = [3.3 4.4; 5.5 7.6];
    pz = Param(:z, "z obj1", "z1", valueZ, valueZ .+ 1.0,
        valueZ .- 5.0, valueZ .+ 5.0, true);
    pvector = ParamVector([px, py, pz])
    o1 = Obj1(px.value, py.value, pz.value);
    modelLH.set_values_from_pvec!(o1, pvector, true);
    return o1, pvector
end

mutable struct Obj2
    a :: Float64
    y :: Float64
    b :: Array{Float64,2}
    # pv :: ParamVector
end

# function Obj2(a, y, b)
#     return Obj2(a, y, b, ParamVector())
# end

function init_obj2()
    pa = Param(:a, "a obj2", "a2", 12.1, 7.9, -1.1, 49.9, true);
    valueY = 9.4;
    py = Param(:y, "y obj2", "y2", valueY, valueY .+ 1.0,
        valueY .- 5.0, valueY .+ 5.0, true);
    valueB = 2.0 .+ [3.3 4.4; 5.5 7.6];
    pb = Param(:b, "b obj2", "b2", valueB, valueB .+ 1.0,
        valueB .- 5.0, valueB .+ 5.0, true);
    pvector = ParamVector([pa, py, pb]);
    o2 = Obj2(pa.value, py.value, pb.value);
    modelLH.set_values_from_pvec!(o2, pvector, true);
    return o2, pvector
end

mutable struct TestModel
    o1 :: Obj1
    pvec1 :: ParamVector
    o2 :: Obj2
    pvec2 :: ParamVector
    a :: Float64
    y :: Float64
end

function init_test_model()
    o1, pvec1 = init_obj1();
    o2, pvec2 = init_obj2();
    return TestModel(o1, pvec1, o2, pvec2, 9.87, 87.73)
end

"""
Simulates the workflow for calibration

If model objects contain other model objects, just "reach in" and operate directly on
the nested objects.

The calibration operates on the param vector. Then we just copy the values from the
param vector into the object for convenience

There is no need to store the param vectors in the model objects

Simplest: Model objects have default constructors and constructors for param vectors
The model keeps them separate.
Benefit: one can save calibrated parameters by just saving the parameter vectors
"""
function modelTest()
    m = init_test_model()
    isCalibrated = true;

    # Sync calibrated model values with param vector
    modelLH.set_values_from_pvec!(m.o1, m.pvec1, isCalibrated);
    modelLH.set_values_from_pvec!(m.o2, m.pvec2, isCalibrated);

    # For each model object: make vector of param values
    v1, _ = make_vector(m.pvec1, isCalibrated);
    @test isa(v1, Vector{Float64})
    v2, _ = make_vector(m.pvec2, isCalibrated);
    @test isa(v2, Vector{Float64})

    # This is passed to optimizer as guess
    vAll = [v1; v2];
    @test isa(vAll, Vector{Float64})

    # Now we run the optimizer, which changes `vAll`

    # This step just for testing
    # These are the values that we expect to get back in the end
    d1 = make_dict(m.pvec1, isCalibrated);
    d2 = make_dict(m.pvec2, isCalibrated);


    # In the objective function: the guess is reassembled
    # into dicts which are then put into the objects

    # but they also need to be put into the param vectors +++++

    d11, nUsed1 = vector_to_dict(m.pvec1, vAll, isCalibrated);
    @test d11[:x] == d1[:x]
    @test d11[:y] == d1[:y]
    # copy into param vector; then sync with model object
    # needs to be one convenience function +++++
    modelLH.set_values_from_dict!(m.pvec1, d11);
    modelLH.set_values_from_pvec!(m.o1, m.pvec1, isCalibrated);
    @test m.o1.x ≈ d1[:x]
    @test m.o1.y ≈ d1[:y]
    deleteat!(vAll, 1 : nUsed1);

    d22, nUsed2 = modelLH.vector_to_dict(m.pvec2, vAll, isCalibrated);
    @test d22[:a] == d2[:a]
    @test d22[:b] == d2[:b]
    modelLH.set_values_from_dict!(m.pvec2, d22);
    modelLH.set_values_from_pvec!(m.o2, m.pvec2, isCalibrated);
    @test m.o2.a ≈ d2[:a]
    @test m.o2.b ≈ d2[:b]
    # Last object: everything should be used up
    @test length(vAll) == nUsed2

    # Test changing parameters
    d22[:a] = 59.34;
    modelLH.set_values_from_dict!(m.o2, d22);
    @test m.o2.a ≈ d22[:a]

    d22[:b] .+= 3.8;
    modelLH.set_values_from_dict!(m.pvec2, d22);
    modelLH.set_values_from_pvec!(m.o2, m.pvec2, isCalibrated);
    @test m.o2.b ≈ d22[:b]

    # continue here +++++
    # how to make that into a function that can be used generically?
    # or just do this by hand each time?
    return true
end

end # module
