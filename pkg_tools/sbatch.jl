# Writing sbatch files
# This will usually be written to `sBatchDir`

function write_sbatch_file(filePath :: String, cmdPath :: String, outPath :: String;
	timeStr :: String = "3-00",  nNodes :: Int = 1,  memKB :: Int = 24576)

	io = open(filePath, "w");
	write(io, "#!/bin/bash \n\n")
	write(io, "#SBATCH -N $nNodes \n")
	write(io, "#SBATCH -t $timeStr \n")
	write(io, "#SBATCH -p general \n")
	write(io, "#SBATCH --mem $memKB \n")
	write(io, "#SBATCH -o '$outPath' \n")
	write(io, "#SBATCH --mail-type=end \n")
	write(io, "#SBATCH --mail-user=lhendri@email.unc.edu \n")
	write(io, " \n");
	write(io, "julia '$cmdPath'")
	close(io);
	return nothing
end

# ----------