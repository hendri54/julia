# Register ConfigLH package

cd(homedir())
cd(".julia/dev/ConfigLH")
ps = get_pkg_spec("ConfigLH")
Pkg.develop(ps)
Pkg.test(ps)

using ConfigLH
register(ConfigLH, regPath)
