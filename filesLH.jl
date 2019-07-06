module filesLH

# For loading / saving julia variables
using FileIO, JLD


"""
## Save a variable so that the name is known

Extension for saving Julia objects must be JLD
"""
function save(fPath, saveS)
    JLD.save(fPath,  "saveS", saveS)
   # jldopen(fPath, "w") do file
   #    write(file, "saveS", saveS)
   # end
   return nothing
end


"""
## Load a variable saved with save
# Types of variables loaded must be defined before load can be called
"""
function load(fPath)
    saveS = JLD.load(fPath, "saveS")
   # saveS = jldopen(fPath, "r") do file
   #    read(file, "saveS")
   # end
   return saveS
end


end
