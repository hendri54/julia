using statsLHtest

@testset "statsLH" begin
    statsLHtest.std_w_test()
    statsLHtest.std_std_test()
    statsLHtest.discretize_test()
    statsLHtest.discretize_given_pct_weighted_test();
    statsLHtest.bin_edges_test();
    statsLHtest.bin_edges_weighted_test();
    statsLHtest.discretize_given_percentiles_test()
    statsLHtest.density_weighted_test()
    # return true
end
