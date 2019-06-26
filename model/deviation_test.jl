function make_deviation(devNo :: Integer)
    modelV = devNo .+ collect(range(2.1, 3.4, length = 5))
    dataV = modelV .+ 0.7;
    wtV = modelV .+ 0.9;
    scaleFactor = 12.0;
    shortStr = "dev$devNo";
    longStr = "Deviation $devNo"
    fmtStr = "%.2f";
    d = Deviation("d$devNo", modelV, dataV, wtV,
        scaleFactor, shortStr, longStr, fmtStr);
    return d;
end

function deviationTest()
    d = make_deviation(1);
    sDev, devStr = scalar_dev(d);
    @test isa(sDev, Float64);
    @test length(sDev) == 1
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

    devV = scalar_devs(d);
    @test length(devV) == 2;
    scalarDev1, _ = scalar_dev(dev1);
    @test devV[1] == scalarDev1

    @test isnothing(retrieve(d, "notThere"))
    dev = retrieve(d, "d1");
    @test dev.name == "d1"
    return true
end
