"""
Rsync to remote machine. Same folder relative to `homedir()`

srcDir
	source directory on local machine
	must be relative to homedir() on both machines
	if absolute path is given, it must hang off homedir()

Fails if local or remote paths contain spaces
#ToDo: How to make the interpolation work when there are quotes around the objects?
"""
function rsync_command(srcDir :: String;  remoteName :: Symbol = :longleaf,  trialRun :: Bool = false)
    @assert run_local()  "Can only be run on local machine"
	localDir, remoteDir = remote_and_local_path(srcDir,  tgCompName = remoteName);

	# This ensures that `localDir` ends in `/`
    localDir = joinpath(localDir, "");
    @assert localDir[end] == '/'

    # Ensure that remote dir does NOT end in "/"
    if remoteDir[end] == '/'
    	remoteDir = remoteDir[1 : (end-1)];
    end

    switchStr = "-atuzv";
    if trialRun
        switchStr = switchStr * "n";
    end

	compRemote = get_computer(remoteName);
    remoteStr = "$(compRemote.sshStr):$remoteDir";
    cmdStr = `rsync $switchStr --delete --exclude .git $localDir $remoteStr`
	return cmdStr
end


"""
rsync_pkg

Upload the package's `develop_dir()` where its code is stored
"""
function rsync_pkg(pkgName :: String; remoteName :: Symbol = defaultRemote, trialRun :: Bool = false)
	rCmd = rsync_command(develop_dir(pkgName),  remoteName = remoteName,  trialRun = trialRun);
	show(rCmd)
    run(rCmd)
end


function rsync_shared(;remoteName :: Symbol = defaultRemote,  trialRun :: Bool = false)
	rCmd = rsync_command(shared_dir(),  remoteName = remoteName,  trialRun = trialRun);
	show(rCmd)
	run(rCmd)
end


function rsync_sbatch(;remoteName :: Symbol = defaultRemote,  trialRun :: Bool = false)
	rCmd = rsync_command(sbatch_dir(), remoteName = remoteName, trialRun = trialRun);
	show(rCmd)
	run(rCmd)
end


"""
Copy a file to a remote machine using scp
Assumes that local and remote path are the same relative to `homedir()`

test this +++++
"""
function remote_copy(filePath :: String;  srcCompName :: Symbol = :local,
	tgCompName :: Symbol = defaultRemote,  trialRun :: Bool = false)

	localPath, remotePath = remote_and_local_path(filePath;  srcCompName = srcCompName,  tgCompName = tgCompName);
	
	if srcCompName == :local
		compRemote = get_computer(tgCompName);
		@assert isfile(localPath)  "File does not exist: $localPath"
	else
		compRemote = get_computer(srcCompName);
	end
	sshStr = "$(compRemote.sshStr):";	

	if srcCompName == :local
		rcCmd = `scp $localPath $sshStr$remotePath`
	else
		rcCmd = `scp $sshStr$localPath $remotePath`
	end
	if !trialRun
		run(rcCmd)
	else
		show(rcCmd)
	end
	return rcCmd
end


"""
Upload to git

It would be easier to run a bash script, but this yields a permission denied error (why?)
"""
function git_upload(pkgName :: String)
    repoDir = develop_dir(pkgName);
    @assert isdir(repoDir);
    run(Cmd(`git add .`, dir = repoDir))
    # Commit fails if there is nothing to commit
    try
	    run(Cmd(`git commit -am "update"`, dir = repoDir));
	catch
	    println("git commit failed")
	end
    run(Cmd(`git push origin master`, dir = repoDir));
end
