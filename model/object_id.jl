"""
Unique ID for a model object

Contains own id and a tuple of parent ids, so one knows exactly where the object
is placed in the model tree
"""

export SingleId, ObjectId, has_index, make_child_id


"""
## Id for one object. Does not keep track of location in model
"""
struct SingleId
    name :: Symbol
    index :: Array{Int}
end

# Object without index
function SingleId(name :: Symbol)
    return SingleId(name, Array{Int,1}())
end

function SingleId(name :: Symbol, idx :: T1) where T1 <: Integer
    return SingleId(name, [idx])
end

function has_index(this :: SingleId)
    return !Base.isempty(this.index)
end

function isequal(id1 :: SingleId, id2 :: SingleId)
    return (id1.name == id2.name)  &&  (id1.index == id2.index)
end

function isequal(id1V :: Vector{SingleId},  id2V :: Vector{SingleId})
    outVal = length(id1V) == length(id2V);
    if outVal
        for i1 = 1 : length(id1V)
            outVal = outVal && isequal(id1V[i1], id2V[i1]);
        end
    end
    return outVal
end

function make_string(id :: SingleId)
    if !has_index(id)
        outStr = "$(id.name)"
    elseif length(id.index) == 1
        outStr = "$(id.name)$(id.index)"
    else
        outStr = "$(id.name)$(id.index)"
    end
    return outStr
end


"""
## Complete ID

Store parent IDs as vector, not tuple (b/c empty tuples are tricky)
"""
struct ObjectId
    ownId :: SingleId
    parentIds :: Vector{SingleId}
end

function ObjectId(ownId :: SingleId)
    return ObjectId(ownId, Vector{SingleId}());
end

function ObjectId(name :: Symbol, parentIds :: Vector{SingleId} = Vector{SingleId}())
    return ObjectId(SingleId(name),  parentIds)
end

function ObjectId(name :: Symbol, index :: Vector{T1},
    parentIds :: Vector{SingleId} = Vector{SingleId}()) where T1 <: Integer

    return ObjectId(SingleId(name, index),  parentIds)
end

function ObjectId(name :: Symbol, idx :: T1,
    parentIds :: Vector{SingleId} = Vector{SingleId}()) where T1 <: Integer

    return ObjectId(SingleId(name, [idx]),  parentIds)
end

function convert_to_parent_id(oId :: ObjectId)
    return vcat(oId.parentIds, oId.ownId) :: Vector{SingleId}
end

function make_child_id(obj :: T1, name :: Symbol,
    index :: Vector{T2} = Vector{Int}()) where {T1 <: ModelObject, T2 <: Integer}

    return ObjectId(name, index, convert_to_parent_id(obj.objId))
end

function make_child_id(objId :: ObjectId, name :: Symbol,
    index :: Vector{T2} = Vector{Int}()) where {T2 <: Integer}

    return ObjectId(name, index, convert_to_parent_id(objId))
end

function isequal(id1 :: ObjectId,  id2 :: ObjectId)
    outVal = isequal(id1.ownId, id2.ownId);
    if length(id1.parentIds) != length(id2.parentIds)
        outVal = false;
    else
        for i1 = 1 : length(id1.parentIds)
            outVal = outVal && isequal(id1.parentIds[i1], id2.parentIds[i1]);
        end
    end
    return outVal
end

function make_string(id :: ObjectId)
    outStr = "";
    if !Base.isempty(id.parentIds)
        for i1 = 1 : length(id.parentIds)
            outStr = outStr * make_string(id.parentIds[i1]) * " > ";
        end
    end

    outStr = outStr * make_string(id.ownId);
    return outStr
end

# ----------
