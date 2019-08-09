# -------- Packages


"""
Does package exist?
"""
function pkg_exists(pkgName :: String)
    return haskey(pkgList, pkgName)
end


"""
Package spec points to github
"""
function get_pkg_spec(pkgName :: String)
    @assert pkg_exists(pkgName)  "Package $pkgName does not exist"
    return PackageSpec(name = pkgName,
        url = githubUrl * pkgName,
        uuid = pkgList[pkgName]);
end


"""
Package spec for local develop
"""
function local_pkg_spec(pkgName :: String; compName = :current)
    @assert pkg_exists(pkgName)  "Package $pkgName does not exist"
    return PackageSpec(name = pkgName,
        path = develop_dir(pkgName, compName = compName),
        uuid = pkgList[pkgName]);
end


#"""
#Package spec for remote develop
#"""
#function remote_pkg_spec(pkgName :: String; comp = computerLongleaf)
#    @assert pkg_exists(pkgName)  "Package $pkgName does not exist"
#    return PackageSpec(name = pkgName,
#        path = develop_dir(pkgName; comp = comp),
#        uuid = pkgList[pkgName]);
#end


"""
activate_pkg
"""
function activate_pkg(pkgName :: String)
	pDir = develop_dir(pkgName);
	@assert isdir(pDir)
	@assert pkg_exists(pkgName)  "Package $pkgName does not exist"
	Pkg.activate(pDir);
end


"""
Remove package
"""
function remove_pkg(pkgName :: String)
    Pkg.rm(get_pkg_spec(pkgName))
end


"""
Develop package. Best to track by local dir.
"""
function develop_pkg(pkgName :: String)
    println("Develop package $pkgName")
    ps = local_pkg_spec(pkgName; compName = :current);
    Pkg.develop(ps)
end


"""
Add package; point to github url
"""
function add_pkg(pkgName :: String)
    Pkg.add(get_pkg_spec(pkgName))
end


"""
Update package
"""
function update_pkg(pkgName :: String)
    Pkg.update(get_pkg_spec(pkgName))
end


"""
test_pkg

Activates the package environment. Otherwise not clear how to run `Pkg.test`
when package not registered.
"""
function test_pkg(pkgName :: String)
	pDir = develop_dir(pkgName);
	Pkg.activate(pDir);
	Pkg.test();
end


"""
test_all_packages

Test all packages registered here
"""
function test_all_packages()
	for (k, pkgName) in pkgList
		test_pkg(pkgName)
	end
end

