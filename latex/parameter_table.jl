export ParameterTable
export add_row!

"""
Parameter table

Columns are symbol, description, value

Flow:
1. Constructor
2. Add rows, either as string (e.g. `\\midrule`) or as triple of values
3. Write table
"""
mutable struct ParameterTable
    tb :: Table
end

function ParameterTable()
    pt = ParameterTable(Table("lll"));
    add_row!(pt, "Parameter", "Description", "Value");
    add_row!(pt, "\\midrule");
    return pt
end

# Add row from string
# Mainly for headers, lines
function add_row!(p :: ParameterTable, rowStr :: T1) where T1 <: AbstractString
    add_row!(p.tb, rowStr)
    return nothing
end

# Add row from parameter values
function add_row!(p :: ParameterTable, symStr :: T1, descrStr :: T1, valueStr :: T1) where
    T1 <: AbstractString

    add_row!(p.tb, symStr * " & " * descrStr * " & " * valueStr);
    return nothing
end

function write_table(p :: ParameterTable, filePath :: T1) where T1 <: AbstractString
    @assert nrows(p.tb) > 0  "Table is empty"
    write_table(p.tb, filePath);
    return nothing
end


# ------------
