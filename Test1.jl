module Test1


@enum Fruit apple=1 orange=2 kiwi=3

function foo(apple)
    println("apple")
end

function foo(orange)
    println("orange")
end

abstract type AT end

struct A1 <: AT
    x
end

struct A2 <: AT
    z
end

function bar(z :: A1)
    println("A1")
end

function bar(z :: A2)
    println("A2")
end

end
