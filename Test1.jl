module Test1

using Profile, StatProfilerHTML

function profile_test(n)
    for i = 1:n
        A = randn(100,100,20)
        m = maximum(A)
        Am = mapslices(sum, A; dims=2)
        B = A[:,:,5]
        Bsort = mapslices(sort, B; dims=1)
        b = rand(100)
        C = B.*b
    end
end


function run_profiler(n)
    Profile.clear();
    @profile profile_test(n);
    Profile.print(stdout, maxdepth=7, mincount = 50)

    statprofilehtml()
end


end
