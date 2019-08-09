using Pkg
Pkg.add("https://github.com/hendri54/ConfigLH")
Pkg.activate(".")
Pkg.build()
Pkg.test(; coverage=true)

# end
