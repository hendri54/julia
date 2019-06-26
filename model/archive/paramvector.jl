"""
How to store the parameters?
Dictionary is obvious, but need to keep it ordered for making and extracting
guess vectors

Workflow:
Construct a model which contains a bunch of ModelObjects

Loading and saving parameter values:
Best to make ModelObjects largely independent of Pvectors
Input a dictionary that maps symbols -> values
ModelObject goes through all potentially calibrated parameters
If they are fixed: set them to defaults
If they are calibrated: set them from the dictionary
Save just the dictionary (the other info is never exogenous)
"""
mutable struct ParamVector
  pv :: Dict{Symbol, modelLH.ParamStruct}

  # Transformed guesses lie in this range
  guessMin :: Float64;
  guessMax :: Float64;

  # Constructor usually has no entries
  function ParamVector()
    # pv = Array(pstruct_lh.pstruct, 1);
    p = new()
    # Create array of 0 length
    p.pv = Dict{Symbol, modelLH.ParamStruct}();
    p.guessMin = 1.0
    p.guessMax = 2.0
    return p
  end
end


function length(this :: ParamVector)
  return Base.length(this.pv);
end


## Add or update
function add_or_update!(this :: ParamVector, nameStr :: Symbol,
   symStr, descrStr, valueM, defaultValueM, lbM, ubM, doCal)
   ps = modelLH.ParamStruct(nameStr, symStr, descrStr, valueM, defaultValueM, lbM,
      ubM, doCal);
    if param_exists(this, nameStr)
      replace!(this, ps);
    else
      add!(this, ps);
    end
end


## Add new parameter
function add!(this :: ParamVector, ps  ::  modelLH.ParamStruct)
    if param_exists(this, ps.name)
     error( "$(ps.name) already exists");
    else
        this.pv[ps.name] = ps;
    end
    return nothing
end


## Replace existing parameter
function replace!(this :: ParamVector, ps :: modelLH.ParamStruct)
   this.pv[ps.name] = ps;
   return nothing
end


## Update an existing pstruct
function update!(this :: ParamVector, nameStr :: Symbol; newValue = [],
    newDefaultValue = [], newLb = [], newUb = [])

   @assert (param_exists(this, nameStr));
   ps = retrieve(this, nameStr);
   # Call update on the existing pstruct
   modelLH.update!(ps; value = newValue, defaultValue = newDefaultValue,
      lb = newLb,  ub = newUb);
   # Store back into pVec
   this.pv[nameStr] = ps;
   return nothing
end


## Does entry exist?
function param_exists(this :: ParamVector, nameStr :: Symbol)
    return haskey(this.pv, nameStr);
end


"""
Retrieve by name
This makes a copy to avoid side effects when user modifies retrieved pstruct
"""
function retrieve(this :: ParamVector, nameStr :: Symbol)
    @assert (param_exists(this, nameStr));
    return deepcopy(this.pv[nameStr]);
end


## Get value
function param_value(this :: ParamVector, nameStr :: Symbol)
    ps = retrieve(this, nameStr);
    return ps.valueM
end


## Get scalar value (only if stored value is scalar)
function get_scalar_value(this :: ParamVector, nameStr :: Symbol)
   ps = retrieve(this, nameStr);
   if isa(ps.valueM, Float64)
      return ps.valueM
   elseif length(ps.valueM) == 1
      return ps.valueM[1]
   else
      error("Not a scalar parameter")
   end
end


## Get calibration status
function set_cal_status(this :: ParamVector, nameStr :: Symbol)
   ps = retrieve(this, nameStr);
   return ps.doCal
end


"""
Make a Dict with all the params
IN:
  doCalIn
    Only elements that match specified doCal value
OUT:
    pList  ::  Dict{Symbol, Any}
        maps names into values
"""
function param_list(this :: ParamVector, doCalIn)
  pList = Dict{Symbol, Any}();
  for name in keys(this.pv)
    ps = this.pv[name];
    if isempty(doCalIn)  ||  ps.doCal == doCalIn
      pList[name] = ps.valueM
    end
  end
  return pList
end


"""
Make a vector of all calibrated parameter values
More robust: create an object that keeps track of all sizes and index positions +++
IN
   doCalIn
      only params with doCal in doCalV are put into guessV
"""
function parameters_as_vector(pv :: ParamVector, doCalIn)
   nMax = 100;
   guessV = Vector{Float64}(nMax);
   lbV = Vector{Float64}(nMax);
   ubV = Vector{Float64}(nMax);

   pList = param_list(pv, doCalIn);

   idxLast = 0;
   for nameStr in keys(pList)
      ps = retrieve(pv, nameStr);
      if isa(ps.valueM, Array)
         idxV = idxLast + (1 : Base.length(ps.valueM));
         idxLast = idxV[end];
      else
         idxV = idxLast + 1;
         idxLast = idxV;
      end
      guessV[idxV] = ps.valueM;
      lbV[idxV] = ps.lbM;
      ubV[idxV] = ps.ubM;
   end

   # Drop spare elements
   if idxLast < nMax
      guessV = guessV[1 : idxLast];
      lbV = lbV[1 : idxLast];
      ubV = ubV[1 : idxLast];
   end
   return guessV, lbV, ubV
end


"""
Make vector into parameter values
Inverts parameters_as_vector
IN
   guessV  ::  Vector{Float64}
      created by parameters_as_vector
OUT
   updated values in pv
"""
# test this +++++
function vector_to_values(this :: ParamVector, guessV :: Vector{Float64},
   doCalIn :: Bool)
   pList = param_list(this, doCalIn);

   idxLast = 0;
   for nameStr in keys(pList)
      ps = retrieve(this, nameStr);
      if isa(ps.valueM, Array)
         idxV = idxLast + (1 : Base.length(ps.defaultValueM));
         idxLast = idxV[end];
         sizeV = size(ps.defaultValueM);
         ps.valueM = reshape(guessV[idxV], sizeV);
      else
         idxV = idxLast + 1;
         idxLast = idxV;
         ps.valueM = guessV[idxV];
      end
      replace!(this, ps);
   end
   return nothing
end
