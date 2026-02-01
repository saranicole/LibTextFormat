LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

function LTF.RegisterFilter(name, fn)
    LTF.Filters[name] = fn
end
