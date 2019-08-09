"""
docu_dir()
"""
function docu_dir(; compName = :current)
	comp = get_computer(compName);
	return joinpath(comp.homeDir, "Documents")
end


"""
project_dir()
"""
function project_dir(year1; compName = :current)
    joinpath(docu_dir(compName = compName), "projects", "p$year1");
end


"""
julia_dir()

Package code hangs off this directory
"""
function julia_dir(; compName = :current)
	comp = get_computer(compName);
	return joinpath(comp.homeDir, "Documents", "julia")
end


"""
shared_dir()

Directory for shared code
"""
function shared_dir(; compName = :current)
	return joinpath(julia_dir(compName = compName), "shared")
end


"""
sbatch_dir()

Command files (`sbatch`) and similar objects go here to be run on the remote machine
"""
function sbatch_dir(; compName :: Symbol = :current)
	return joinpath(julia_dir(compName = compName), "longleaf")
end


"""
test_file_dir()

Directory for test files
"""
function test_file_dir(; compName = :current)
	return joinpath(julia_dir(compName = compName), "test_files")
end


"""
Local develop dir
"""
function develop_dir(pkgName :: String; compName = :current)
    return joinpath(julia_dir(compName = compName), pkgName)
end


"""
Make a pair of local and remote paths, both in the same location relative to homedir()

srcPath
	can be absolute path on either machine or relative to `homedir()`
"""
function remote_and_local_path(srcPath :: String; srcCompName :: Symbol = :local,
	tgCompName :: Symbol = defaultRemote)
	
	srcComp = get_computer(srcCompName);
	tgComp = get_computer(tgCompName);
	
    if isabspath(srcPath)
    	if startswith(srcPath, srcComp.homeDir)
			srcPath = relpath(srcPath, srcComp.homeDir);    	
		elseif startswith(srcPath, tgComp.homeDir)
			srcPath = relpath(srcPath, tgComp.homeDir);    	
		else
			error("srcPath must be inside home directory:  $srcPath")
		end
	end

    localDir = joinpath(srcComp.homeDir, srcPath);
    remoteDir = joinpath(tgComp.homeDir, srcPath);
	return localDir, remoteDir
end


"""
add_to_path!

Add a directory to the LOAD_PATH without duplication
"""
function add_to_path!(newDir :: String)
	if !in(newDir, LOAD_PATH)
		push!(LOAD_PATH, newDir);
	end
	return nothing
end


"""
remove_from_path!

Remove a directory to the LOAD_PATH, if it exists
"""
function remove_from_path!(newDir :: String)
	idx = findfirst(x -> x == newDir, LOAD_PATH);
	if !isnothing(idx)
		deleteat!(LOAD_PATH, idx);
	end
	return nothing
end

