"""
## Parameter vector test
"""

# Make a ParamVector for testing
# Alternates between calibrated and fixed parameters
function init_pvector(n :: Integer)
    pv = ParamVector();
    for i1 = 1 : n
        p = init_parameter(i1);
        if isodd(i1)
            calibrate!(p);
        end
        modelLH.append!(pv, p);
    end
    return pv
end

function init_parameter(i1 :: Integer)
    pSym = Symbol("p$i1");
    pName = "param$i1";
    pDescr = "sym$i1";
    valueM = i1 .+ collect(1 : i1) * [1.0 2.0];
    return Param(pSym, pName, pDescr, valueM)
end


"""
## Test basic operations
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


"""
## Vector to Dict and back
"""
function pvectorDictTest()
    pv = init_pvector(3);
    d = make_dict(pv, true)
    p1, _ = retrieve(pv, :p1);
    p3, _ = retrieve(pv, :p3);
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
## Finding ParamVector in object
"""
mutable struct M1 <: ModelObject
    pvec :: ParamVector
end

mutable struct M2 <: ModelObject
    x :: ParamVector
    y :: Float64
end

mutable struct M3 <: ModelObject
    y :: Float64
end

function get_pvector_test()
    m1 = M1(ParamVector());
    @test modelLH.get_pvector(m1) == m1.pvec

    m2 = M2(ParamVector(), 1.2);
    @test modelLH.get_pvector(m2) == m2.x

    m3 = M3(1.2);
    pvec3 = modelLH.get_pvector(m3);
    @test length(pvec3) == 0
    return true
end



# -------------
