"""
Rsync to longleaf

Fails if local or remote paths contain spaces
#ToDo: How to make the interpolation work when there are quotes around the objects?
"""
function rsync_command(pkgName :: String; trialRun :: Bool = false)
    @assert run_local()  "Can only be run on local machine"

	remoteName = :longleaf;
	compRemote = computerV[remoteName];
	# This ensures that `localDir` end in `/`
    localDir = joinpath(develop_dir(pkgName), "");
    @assert localDir[end] == '/'
    remoteDir = develop_dir(pkgName, compName = remoteName);
    switchStr = "-atuzv";
    if trialRun
        switchStr = switchStr * "n";
    end
    remoteStr = "$(compRemote.sshStr):$remoteDir";
    cmdStr = `rsync $switchStr --delete $localDir $remoteStr`
end

function rsync_pkg(pkgName :: String; trialRun :: Bool = false)
    run(rsync_command(pkgName, trialRun = trialRun))
end

function rsync_shared(;trialRun :: Bool = false)
    # switchStr = "-atuzv";
    # if trialRun
    #     switchStr = switchStr * "n";
    # end
    # cmdStr = `rsync $switchStr $localDir $remoteStr`
    rsync_pkg("shared"; trialRun = trialRun)
end


"""
Upload to git

test this +++++
"""
function git_upload(pkgName :: String)
    repoDir = develop_dir(pkgName);
    @assert isdir(repoDir);
    run(Cmd(`git add .`, dir = repoDir))
    run(Cmd(`git commit -am "update"`, dir = repoDir));
    run(Cmd(`git push origin master`, dir = repoDir));
end
