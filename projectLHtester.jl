using projectLH

@testset "projectLH" begin
    pName = "test";
    @test isdir(projectLH.project_dir(2018));
    proj = projectLH.Project(pName, pwd(), pwd());
    show(proj);
    proj2 = projectLH.get_project(pName);
    @test proj2.name == pName;
    projectLH.project_start(pName)
end
