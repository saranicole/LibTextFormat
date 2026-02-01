-----------------------------------------------------------------------------------
-- Library Name: LibTextFormat (LTF)
-- Creator: Saranicole1980 (Sara Jarjoura)
-- Library Ideal: Advanced Text Formatting and Parsing
-- Library Creation Date: February, 2026
-- Publication Date: TBD
--
-- File Name: LibTextFormat.lua
-- File Description: Contains the main functions of LTF
-- Load Order Requirements: After all other library files
--
-----------------------------------------------------------------------------------

LibTextFormat = LibTextFormat or {}

local LTF = LibTextFormat

local function splitPipeline(block)
    local argsPart, pipePart = block:match("^(.-)|(.+)$")
    if not argsPart then
        return { block }
    end

    local parts = { argsPart }
    for p in pipePart:gmatch("[^|]+") do
        parts[#parts + 1] = zo_strtrim(p)
    end
    return parts
end

function LTF.Scope(initial)
  return LibTextFormatScope:New(initial)
end

local function evalArgs(argStr, scope)
    local args = {}
    for var in argStr:gmatch("[^,]+") do
        var = zo_strtrim(var)          -- remove whitespace
        local value = scope:Get(var)
        table.insert(args, value)
    end
    return args
end

function LTF:format(template, scope)
    return (template:gsub("{(.-)}", function(block)
        local parts = splitPipeline(block)
        local args = evalArgs(parts[1], scope)  -- fetch multiple arguments

        -- Apply filters, left-to-right
        for i = 2, #parts do
            local filter = LTF.Filters[parts[i]]
            if not filter then
                return "{UNKNOWN FILTER}"
            end
            args = { filter(unpack(args)) }  -- collapse to single value for next filter
        end

        return tostring(args[1])
    end))
end
