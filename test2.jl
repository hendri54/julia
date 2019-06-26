module test2

using BenchmarkTools

struct Sample{T<:AbstractFloat, F<:Function}
    a :: T
    foo :: F
end

function main()
    foo1(x) = x^1
    foo2(x) = x^2
    foo3(x) = x^3
    s1 = Sample(1., foo1)
    s2 = Sample(2., foo2)
    s3 = Sample(3., foo3)

    samples = (s1, s2, s3)

    b = 0.0;
    @btime begin
        for i = 1 : length($samples)
            $b += $foo1(2.0);
            $b += $foo2(2.0);
            $b += $foo3(2.0);
        end
    end

    println(b)


    b = 0.
    @btime begin
        for i=1:length($samples)
            $b = $b + $samples[i].a * $samples[i].foo(2.0)
        end
    end

    println(b)

    b = 0.0;
    @btime begin

        for s in $samples
            $b = $b + s.a * s.foo(2.0)
        end
    end
    println(b)

    b = 0.0;
    @btime begin
        $b = $b + $samples[1].a * $samples[1].foo(2.0)
        $b = $b + $samples[2].a * $samples[2].foo(2.0)
        $b = $b + $samples[3].a * $samples[3].foo(2.0)
    end
    println(b)

    # samples2 = [s1, s2, s3];

    # @btime begin
    #     b = 0.0;
    #     for s in samples
    #         b += s.a * s.foo;
    #     end
    # end
end

end
