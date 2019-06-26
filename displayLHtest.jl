module displayLHtest

using Test
using displayLH

function sprintf_test()
    fmtStr = "{:.1f} "
    z = [1.11 2.22]
    x = displayLH.sprintf(fmtStr, z)
    @test x == "1.1 2.2 "
    displayLH.printf(fmtStr, z)
    return true
end


function show_string_vector_test()
    sV = ["aaaa aaaa", "bbb bbb bbb", "cccccc cccccc cccccc", "dddddddddd"];

    displayLH.show_string_vector(sV, 25);
    return true
end

end
