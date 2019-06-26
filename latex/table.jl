# Latex tables
# Add: write text table +++

export CellColor, Cell
export add_row!, color_string, cell_string, nrows, write_table

"""
## Cell colors
"""
mutable struct CellColor
    name :: AbstractString
    intensity :: Integer
end

function color_string(c :: CellColor)
    iStr = c.intensity;
    if iStr <= 0
        return ""
    else
        return "\\cellcolor{" * c.name * "!" * "$iStr" * "}"
    end
end


"""
## Cell

Single of multicolumn
"""
mutable struct Cell{T1 <: AbstractString, T2 <: Integer}
    text :: T1
    width :: T2
    align :: Char
    color :: CellColor
end

function Cell(txt :: T1) where T1 <: AbstractString
    return Cell(txt, 1, 'l', CellColor("blue", 0))
end

function Cell(txt :: T1, align :: Char) where T1 <: AbstractString
    return Cell(txt, 1, align, CellColor("blue", 0))
end

function Cell(txt :: T1, width :: T2) where
    {T1 <: AbstractString, T2 <: Integer}

    return Cell(txt, width, 'c', CellColor("blue", 0))
end

function Cell(txt :: T1, w :: T2, align :: Char) where
    {T1 <: AbstractString, T2 <: Integer}

    return Cell(txt, w, align, CellColor("blue", 0))
end


function cell_string(c :: Cell)
    contentStr = color_string(c.color) * c.text;
    if c.width > 1
        return "\\multicolumn{$(c.width)}{$(c.align)}{$contentStr}"
    else
        return contentStr
    end
end


"""
## Table

Flow
1. Constructor
2. Make and add rows (some are just provided by user as strings)
3. Write table
"""
mutable struct Table{T1 <: AbstractString, T2 <: Integer}
    # nRows :: T2
    nCols :: T2
    alignV :: T1
    # headerV :: Vector{T1}
    # Body is a vector of strings (rows)
    bodyV  :: Vector{T1}
end

function Table(alignV :: T1) where T1 <: AbstractString
    return Table(length(alignV),  alignV)
end

function Table(nc :: T1, alignV :: T2) where
    {T1 <: Integer, T2 <: AbstractString}

    return Table(nc, alignV, Vector{String}(undef, 0))
end


"""
## Table rows
"""
function nrows(tb :: Table)
    return length(tb.bodyV)
end


function add_row!(tb :: Table, rowStr :: T1) where T1 <: AbstractString
    push!(tb.bodyV, rowStr)
    return nothing
end


## Make a row from a vector of cells
function make_row(tb :: Table, cellV :: Vector{T1}) where T1
    nCols = 0;
    rowStr = "";
    for i1 in 1 : length(cellV)
        nCols += cellV[i1].width;
        rowStr = rowStr * cell_string(cellV[i1]);
        if i1 < length(cellV)
            rowStr = rowStr * " & ";
        end
    end
    @assert nCols == tb.nCols  "Number of columns does not match table"
    return rowStr
end


function header(tb :: Table)
    return ["\\begin{tabular}{$(tb.alignV)}",
        "\\toprule"]
end

function footer(tb :: Table)
    return ["\\bottomrule",  "\\end{tabular}"]
end

"""
Write table
"""
function write_table(tb :: Table, filePath :: T1) where T1 <: AbstractString
    io = open(filePath, "w");
    for lineStr in header(tb)
        write_line(io, lineStr)
    end
    for lineStr in tb.bodyV
        write_line(io, lineStr)
    end
    for lineStr in footer(tb)
        write_line(io, lineStr)
    end
    close(io);

    pathV = splitpath(filePath);
    println("Saved table  $(pathV[end])  to dir  $(pathV[end-1])")
    return nothing
end

function write_line(io :: IO, lineStr)
    write(io, lineStr);
    if lineStr[1] == '\\'
        write(io, " \n")
    else
        # Not a command; neeed newline at end
        write(io, " \\\\ \n")
    end
end

# ===========
