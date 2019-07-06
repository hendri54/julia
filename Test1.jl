module Test1

function foo(x)
    println("Test1.foo")
    return -x.x
end

function bar(x)
    println(foo(x))
end

end
