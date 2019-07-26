## Make deviations for testing
# Names are :d1 etc
function make_deviation(devNo :: Integer)
    dataV = devNo .+ collect(range(2.1, 3.4, length = 5));
    modelV = dataV .+ 0.7;
    wtV = dataV .+ 0.9;
    # scaleFactor = 12.0;
    shortStr = "dev$devNo";
    longStr = "Deviation $devNo"
    fmtStr = "%.2f";
    d = Deviation(Symbol("d$devNo"), modelV, dataV, wtV,
        shortStr, longStr, fmtStr);
    return d;
end

function deviationTest()
    d1 = Deviation();
    @test modelLH.isempty(d1);

    d = make_deviation(1);
    @test !modelLH.isempty(d)
    sDev, devStr = scalar_dev(d);
    @test isa(sDev, Float64);
    @test isa(devStr, AbstractString)
    dStr = short_display(d);
    @test dStr[1:4] == "dev1"

    return true
end


function devVectorTest()
    d = DevVector()
    @test length(d) == 0
    dev1 = make_deviation(1);
    modelLH.append!(d, dev1);
    @test length(d) == 1

    dev2 = make_deviation(2);
    modelLH.append!(d, dev2);
    @test length(d) == 2
    show(d);

    dev22 = modelLH.retrieve(d, :d2);
    @test !modelLH.isempty(dev22)
    @test dev22.dataV ≈ dev2.dataV
    @test modelLH.exists(d, :d2)
    @test !modelLH.exists(d, :notThere)

    modelV = dev22.dataV .+ 1.3;
    modelLH.set_model_values(d, :d2, modelV);
    dev22 = modelLH.retrieve(d, :d2);
    @test dev22.modelV ≈ modelV

    devV = scalar_devs(d);
    @test length(devV) == 2;
    scalarDev1, _ = scalar_dev(dev1);
    @test devV[1] == scalarDev1

    @test modelLH.isempty(retrieve(d, :notThere))
    dev = retrieve(d, :d1);
    @test dev.name == :d1
    return true
end
