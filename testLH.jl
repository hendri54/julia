module testLH

export test_header, test_divider

function test_header(hdStr :: String)
    test_divider();
    println("Testing  $hdStr")
    return nothing
end

function test_divider()
    println("-------------------")
    return nothing
end


end # module
