function g1(a)
    if a == 0
        f(x) = 2
    else
        f(x) = 3
    end
    println(f(1))
end

function g2(a)
    f = x -> 1
    if a == 0
        f(x) = 2
    else
        f(x) = 3
    end
    println(f(1))
end
function g3(a)
    f(x) = 1
    if a == 0
        f(x) = 2
    else
        f(x) = 3
    end
    println(f(1))
end
function g4(a)
    f = x -> 1
    if a == 0
        f = x -> 2
    else
        f = x -> 3
    end
    println(f(1))
end

g1(0) # 3
g2(0) # 3
g3(0) # 3
g4(0) # 2
# g1(1) #fails
g2(1) #1
g3(1) #3
g4(1) #1
