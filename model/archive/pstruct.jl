"""
ParamStruct
Type that holds model parameters
Parameters are scalar or matrix; always Float64
"""
mutable struct ParamStruct
  name :: Symbol       # name, such as prefBeta
  symbolStr :: String  # symbol used in paper, e.g. "\beta"
  descrStr :: String    # Long description used in param tables
  # expected size, () for scalars, (3,) for vectors, etc
  # sizeV  ::  Tuple{Uint16}
  # Calibrated values
  valueM
  # default values if not calibrated; scalar or Matrix
  defaultValueM
  # bounds if calibrated
  lbM
  ubM
  # is it calibrated?
  doCal  ::  Bool

  # # Constructor
  # function ParamStruct(nameIn :: Symbol, symIn :: String, descrIn :: String,
  #   valueIn, lbIn, ubIn, doCalIn)
  #   ps = new()
  #   ps.name = nameIn
  #   ps.symbolStr = symIn
  #   ps.descrStr = descrIn
  #   ps.valueV = valueIn
  #   ps.lbV = lbIn
  #   ps.ubV = ubIn
  #   ps.doCal = doCalIn
  #   validate(ps)
  #   return ps
  # end
end


## Update with new data
function update!(this ::  ParamStruct; value = [], defaultValue = [], lb = [], ub = [])
    if !isempty(value)
        this.valueM = value;
    end
   if !isempty(defaultValue)
      this.defaultValueM = defaultValue;
   end
   if !isempty(lb)
      this.lbM = lb;
   end
   if !isempty(ub)
      this.ubM = ub;
   end
   # if !isempty(doCal)
   #    this.doCal = doCal;
   # end
   validate(this);
   return nothing;
end


## Get properties
function get_value(this :: ParamStruct)
   return this.valueM
end


## Change calibration status
# test +++
function calibrate!(this :: ParamStruct, doCal :: Bool)
   this.doCal = doCal;
end


## Validate
function validate(this :: ParamStruct)
    isValid = true;
    if eltype(this.defaultValueM) != Float64
        isValid = false;
    end
    if eltype(this.lbM) != eltype(this.defaultValueM)
        isValid = false;
    end
    if eltype(this.ubM) != eltype(this.defaultValueM)
        isValid = false;
    end
    return isValid;
end


## Make scalar inputs
