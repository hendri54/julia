module displayLH_test

using Base.Test

reload("displayLH")
using displayLH

function test_all()
    sprintf_test()
end

function sprintf_test()
    fmtStr = "{:.1f} "
    z = [1.11 2.22]
    x = displayLH.sprintf(fmtStr, z)
    @test x == "1.1 2.2 "
    displayLH.printf(fmtStr, z)
end

end
