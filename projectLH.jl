module projectLH

using configLH
import Base.show
export project_start

const initFile = "init.jl"

"""
## User interface
"""
function project_start(pName  ::  AbstractString)
    proj = get_project(pName);
    project_start(proj);
    return proj
end


"""
## Internals
"""
mutable struct Project
    name :: AbstractString
    progDir  ::  AbstractString
    dirsOnPath :: AbstractString
end


function show(proj :: Project)
    println("Project [$(proj.name)]");
    println("\tin: $(proj.progDir)")
end


function shared_dirs()
    # compS = configLH.computer_info();
    outV = configLH.shared_dir();
end


function project_dir(pYear :: Integer)
    return joinpath(homedir(),  "Documents",  "projects",  "p$pYear")
end


"""
## Start a project
"""
function project_start(proj :: Project)
    println("Starting project $(proj.name)");
    println("Dir:  $(proj.progDir)")
    @assert isdir(proj.progDir)  "Not found: $(proj.progDir)"
    push!(LOAD_PATH, proj.progDir);
    push!(LOAD_PATH, proj.dirsOnPath);
    cd(proj.progDir);
    initPath = joinpath(proj.progDir, initFile);
    if isfile(initPath)
        include(initPath);
    end
    return nothing
end


"""
## Project Definitions
Newest at the top
"""
function get_project(pName :: AbstractString)
    if pName == "test"
        progDir = configLH.shared_dir();
        proj = Project(pName, progDir, shared_dirs())
    elseif pName == "sampleModel"
        # Code to try out modeling code (setting parameters etc)
        progDir = joinpath(configLH.julia_dir(), "sample_model")
        proj = Project(pName, progDir, shared_dirs())
    elseif pName == "collegeQuality"
        # Model with college quality (Oksana, Tatyana)
        progDir = joinpath(project_dir(2019), "college_stratification", "github", "progs");
        proj = Project(pName, progDir, shared_dirs())
    else
        error("Invalid project $pName")
    end
    return proj
end


end # module
