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
	jointpath(julia_dir(), "TestPkg2LH"),  ["TestPkgLH"]);

projectV = Dict(["TestPkg2LH" => pTest,  "CollegeStrat" => pCollegeStrat]);


function get_project(pName :: String)
	@assert project_exists(pName);
	return projectV[pName]
end


function project_exists(pName :: String)
	return haskey(projectV, pName)
end
	

"""
project_start(pName :: String)

Activate a project environment
Issue `using P` afterwards (that cannot be done in the code here)
"""
function project_start(pName :: String)
	p = get_project(pName);
	activate_pkg(p.packageDir);
	println("Started project $pName")
end


"""
project_upload(pName :: String;  remoteName :: Symbol = :longleaf,  trialRun :: Bool = false)

Upload all project files, including dependencies, to remote computer

test this +++++
"""
function project_upload(pName :: String;  remoteName :: Symbol = :longleaf,  trialRun :: Bool = false)
	println("Uploading project code for  $remoteName")
	upload_dependencies(pName, remoteName = remoteName, trialRun = trialRun);
	rsync_shared(trialRun = trialRun);
	upload_project_code(pName, remoteName = remoteName, trialRun = trialRun);
end


function upload_dependencies(pName :: String;  remoteName :: Symbol = :longleaf;  trialRun :: Bool = false)
	@assert remoteName == :longleaf  
	# Need to change rsync_command to allow for other remote machine
	
	p = get_project(p);
	if !isempty(p.dependencies)
		for dName in p.dependencies
			rsync_pkg(pName, trialRun = trialRun);
		end
	end
	return nothing
end


# --------------