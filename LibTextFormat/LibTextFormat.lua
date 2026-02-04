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

function LTF:RegisterCore()
  self:RegisterFiltersBulk(self.Core)
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

local function BuildFormatContext(scope, ltf)
    return {
        scope = scope,
        ltf   = ltf,
        now = GetTimeStamp(),
    }
end

function LTF:format(template, scope)
    return (template:gsub("{(.-)}", function(block)
        local parts = splitPipeline(block)

        local ctx = BuildFormatContext(scope, self)

        -- 1️⃣ Evaluate arguments
        local args = evalArgs(parts[1], scope)

        -- 2️⃣ Apply pipeline operators
        for i = 1, #parts do
            local name = parts[i]
            local protocol = self:GetProtocol(name)
            if protocol then
                if protocol.encode then
                    args = { protocol:encode(ctx) }
                else
                    return "{INVALID PROTOCOL}"
                end

            -- filter?
            else
                local filter = self:GetFilter(name)
                if not filter then
                    break
                end
                args = { filter(unpack(args)) }
            end
        end

        return tostring(args[1])
    end))
end
