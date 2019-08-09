@testset "Directories" begin
	newStr = "remove/this"
	add_to_path!(newStr)
	@test in(newStr, LOAD_PATH)
	remove_from_path!(newStr);
	@test !in(newStr, LOAD_PATH)
	n = length(LOAD_PATH)
	remove_from_path!(newStr);
	@test length(LOAD_PATH) == n
	
	srcPath = "abc/def";
	localPath, remotePath = PackageToolsLH.remote_and_local_path(srcPath);
	@test localPath == joinpath(PackageToolsLH.computerLocal.homeDir, srcPath)
	@test remotePath == joinpath(PackageToolsLH.computerLongleaf.homeDir, srcPath)
end

# -----------