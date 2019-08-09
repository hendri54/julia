# File transfer test

@testset "File transfer" begin
    rCmd = PackageToolsLH.rsync_command("test1/test2", trialRun = true);
    println(rCmd)
    @test isa(rCmd, Cmd)
    cmdStr = "$rCmd";
    @test occursin("/Users/lutz/test1/test2/", cmdStr)
    @test occursin("lhendri@longleaf.unc.edu:/nas/longleaf/home/lhendri/test1/test2", cmdStr)

    pkgName = "TestPkgLH";
    PackageToolsLH.rsync_pkg(pkgName, remoteName = :longleaf, trialRun = true);
    PackageToolsLH.rsync_shared(remoteName = :longleaf, trialRun = true);
end

# ---------
