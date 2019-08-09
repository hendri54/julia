# -------  Project Definitions

struct Project
	name :: String
	packageDir :: String
	dependencies :: Vector{String}
end


pCollegeStrat = Project("CollegeStrat",  
	joinpath(project_dir(2019), "college_stratification", "CollegeStrat"),
	["CommonLH", "EconLH", "ModelParams"]);

pTest = Project("TestPkg2LH",  
	joinpath(julia_dir(), "TestPkg2LH"),  ["TestPkgLH"]);

projectV = Dict(["TestPkg2LH" => pTest,  "CollegeStrat" => pCollegeStrat]);


function get_project(pName :: String)
	@assert project_exists(pName);
	return projectV[pName]
end


function project_exists(pName :: String)
	return haskey(projectV, pName)
end
	
	
# ------------  Running a project

"""
project_start(pName :: String)

Activate a project environment
Issue `using P` afterwards (that cannot be done in the code here)
"""
function project_start(pName :: String)
	p = get_project(pName);
	activate_pkg(pName);
	develop_dependencies(pName);
	println("Started project $pName")
end


"""
On the remote machine only, change all dependencies to `develop` so that their
paths in `Manifest.toml` are updated to match the local machine
"""
function develop_dependencies(pName :: String)
	if !run_local()
		p = get_project(pName);
		if !isempty(p.dependencies)
			for pkgName in p.dependencies
				develop_pkg(pkgName)
			end
		end
	end
	return nothing
end


"""
project_upload(pName :: String;  remoteName :: Symbol = :longleaf,  trialRun :: Bool = false)

Upload all project files, including dependencies, to remote computer
"""
function project_upload(pName :: String;  remoteName :: Symbol = defaultRemote,  trialRun :: Bool = false)
	println("Uploading project code for  $remoteName")
	upload_dependencies(pName, remoteName = remoteName, trialRun = trialRun);
	rsync_shared(remoteName = remoteName, trialRun = trialRun);
	upload_project_code(pName, remoteName = remoteName, trialRun = trialRun);
	rsync_sbatch(remoteName = remoteName, trialRun = trialRun);	
end


## Upload a project's dependencies
# This is not recursive.
function upload_dependencies(pName :: String;  remoteName :: Symbol = defaultRemote,  trialRun :: Bool = false)
	p = get_project(pName);
	if !isempty(p.dependencies)
		for dName in p.dependencies
			rsync_pkg(pName, remoteName = remoteName, trialRun = trialRun);
		end
	end
	return nothing
end


function upload_project_code(pName :: String;  remoteName :: Symbol = defaultRemote,  trialRun :: Bool = false)
	p = get_project(pName);
	rCmd = rsync_command(p.packageDir, remoteName = remoteName, trialRun = trialRun);
	show(rCmd)
	run(rCmd)
end


#"""
#Prepare to run code on remote machine
#"""
#function prepare_remote(pName :: String; remoteName :: Symbol = defaultRemote,  trialRun :: Bool = false)
#	project_upload(pName, remoteName = remoteName, trialRun = trialRun);
#	
#end

# --------------