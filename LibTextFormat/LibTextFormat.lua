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

LibTextFormat or {}

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

function LTF.format(template, scope)
    return (template:gsub("{(.-)}", function(block)
        local parts = splitPipeline(block)
        local env = scope:Env()

        -- 1️⃣ evaluate argument list
        local args = evalArgs(parts[1], scope)

        -- 2️⃣ apply filters
        local value
        for i = 2, #parts do
            local filter = Text.Filters[parts[i]]
            if not filter then
                return "{UNKNOWN FILTER}"
            end

            value = filter(unpack(args))

            -- after first filter, collapse to single value
            args = { value }
        end

        return tostring(args[1])
    end))
end
