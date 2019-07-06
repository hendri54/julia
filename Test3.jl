module Test3

import Test1.foo
using Test1

struct T1
    x :: Float64
end

function foo(x :: T1)
    println("Test1.foo")
    return x.x
end

function run()
    t = T1(1.2);
    println(foo(t));
    Test1.bar(t)
end

end  # module
