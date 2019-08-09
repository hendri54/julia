using PackageToolsLH, Test

@testset "Projects" begin
	pName = "TestPkg2LH";
	p = PackageToolsLH.get_project(pName);
	@test isa(p, PackageToolsLH.Project);

	@test PackageToolsLH.project_exists(pName)

#	PackageToolsLH.project_start(pName);
	# check that the environment is activated +++
	# then undo it +++
#	PackageToolsLH.project_start()

	PackageToolsLH.project_upload(pName, remoteName = :longleaf, trialRun = true);
end

# ---------------
