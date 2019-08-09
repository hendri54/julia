struct Computer
	name :: Symbol
	homeDir :: String
	sshStr :: String
end

computerLocal = Computer(:local, "/Users/lutz", "");

computerLongleaf = Computer(:longleaf, "/nas/longleaf/home/lhendri",
	"lhendri@longleaf.unc.edu");

# Known computers
computerV = Dict([:local => computerLocal,  :longleaf => computerLongleaf]);


"""
get_computer
"""
function get_computer(compName = :current)
	if compName == :current
		return current_computer();
	else
		return computerV[compName];
	end
end


"""
current_computer()
"""
function current_computer()
	outComp = nothing;
	for (k, comp) in computerV
		if isdir(comp.homeDir)
			outComp = comp;
			break
		end
	end
	@assert isa(outComp, Computer)
	return outComp
end


"""
run_local()

Running on local or remote compute
"""
function run_local()
    return isdir(computerLocal.homeDir)
end
