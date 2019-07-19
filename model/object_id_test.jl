# Testing ObjectId

function single_id_test()
    id1 = SingleId(:id1, [1, 2])
    @test id1.index == [1,2]
    @test has_index(id1)

    id11 = SingleId(:id1, [1, 2]);
    @test modelLH.isequal(id1, id11)

    id2 = SingleId(:id2, 3)
    @test id2.index == [3]

    id3 = SingleId(:id3);
    @test isempty(id3.index)
    @test !has_index(id3)
    @test modelLH.isequal(id3, SingleId(:id3))

    @test modelLH.isequal([id1, id2], [id1, id2])
    @test !modelLH.isequal([id1, id1], [id2, id1])
    @test !modelLH.isequal([id1, id2], [id1])

    return true
end

struct TestObj4 <: ModelObject
    objId :: ObjectId
end

function object_id_test()
    id1 = SingleId(:id1);
    o1 = ObjectId(id1);
    @test isempty(o1.parentIds)
    @test isequal(modelLH.make_string(id1), "id1")

    o2 = ObjectId(:id2, 2)
    @test o2.ownId.index == [2]
    pIdV = modelLH.convert_to_parent_id(o2);
    @test length(pIdV) == 1

    # Has id1 as parent
    o3 = ObjectId(:id3, 2, [id1]);
    @test isequal(o3.parentIds, [id1])
    pIdV = modelLH.convert_to_parent_id(o3);
    @test length(pIdV) == 2
    @test isequal(modelLH.make_string(o3), "id1 > id3[2]")

    o4 = ObjectId(:id4, pIdV);
    pId4V = modelLH.convert_to_parent_id(o4);
    @test modelLH.isequal(pId4V, [id1, SingleId(:id3, 2), SingleId(:id4)])

    obj4 = TestObj4(o4);
    childId = modelLH.make_child_id(obj4, :child);
    @test modelLH.isequal(childId.ownId,  SingleId(:child))
    @test modelLH.isequal(pId4V, childId.parentIds)

    return true
end

# -----------
