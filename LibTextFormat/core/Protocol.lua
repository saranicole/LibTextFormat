LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Protocols = {}
LTF.BaseProtocol = {}
local baseProtocol = LTF.BaseProtocol

-- protocol = {
--     encode = function(value, opts) end,
--     decode = function(text, opts) end,
--     delimiters = {
--         group = "\n",
--         record = "|",
--         item = ",",
--     }
-- }

function LTF.CreateProtocol(base, def)
    local proto = def or {}

    setmetatable(proto, {
        __index = base
    })

    -- deep-copy delimiters so children can override safely
    if base and base.delimiters then
        proto.delimiters = proto.delimiters or {}
        for k, v in pairs(base.delimiters) do
            if proto.delimiters[k] == nil then
                proto.delimiters[k] = v
            end
        end
    end

    return proto
end

function LTF.RegisterProtocol(name, proto)
    LTF.Protocols[name] = proto
end

function baseProtocol:encode(value, opts)
    error("encode() not implemented")
end

function baseProtocol:decode(text, opts)
    error("decode() not implemented")
end

baseProtocol.delimiters = {
    group  = "\n",
    record = "|",
    item   = ",",
}

local delimitedProtocol = LTF.CreateProtocol(baseProtocol, {})

function delimitedProtocol:encode(records, opts)
    local d = opts or {}
    local delims = self.delimiters

    local group  = d.group  or delims.group
    local record = d.record or delims.record
    local item   = d.item   or delims.item

    local out = {}

    for _, rec in ipairs(records) do
        local fields = {}
        for _, field in ipairs(rec) do
            if type(field) == "table" then
                fields[#fields + 1] = table.concat(field, item)
            else
                fields[#fields + 1] = tostring(field)
            end
        end
        out[#out + 1] = table.concat(fields, record)
    end

    return table.concat(out, group)
end

function delimitedProtocol:decode(text, opts)
    local d = opts or {}
    local delims = self.delimiters

    local group  = d.group  or delims.group
    local record = d.record or delims.record
    local item   = d.item   or delims.item

    local records = {}

    for recStr in text:gmatch("[^" .. group .. "]+") do
        local rec = {}
        for field in recStr:gmatch("[^" .. record .. "]+") do
            if field:find(item, 1, true) then
                local items = {}
                for i in field:gmatch("[^" .. item .. "]+") do
                    items[#items + 1] = i
                end
                rec[#rec + 1] = items
            else
                rec[#rec + 1] = field
            end
        end
        records[#records + 1] = rec
    end

    return records
end

LTF.DelimitedProtocol = delimitedProtocol
