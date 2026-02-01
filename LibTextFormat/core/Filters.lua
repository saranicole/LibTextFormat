LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Filters = {}
local filters = LTF.Filters

function LTF.RegisterFilter(name, fn)
    filters[name] = fn
end
