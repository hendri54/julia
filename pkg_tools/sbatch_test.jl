@testset "sbatch" begin

	filePath = joinpath(PackageToolsLH.test_file_dir(), "sbatch_test.sl");
	if isfile(filePath)
		rm(filePath);
	end
	cmdPath = joinpath(PackageToolsLH.test_file_dir(), "test1.jl");
	outPath = joinpath(PackageToolsLH.test_file_dir(), "test1.out");
	timeStr = "7-00";
	
	PackageToolsLH.write_sbatch_file(filePath, cmdPath, outPath,  timeStr = timeStr);
	@test isfile(filePath)
	
	# Show on screen
	println("------------")
	for line in eachline(filePath)
	   println(line)
   end
   println("-------------")
end