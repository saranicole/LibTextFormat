LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.RegisterFilter("plural", function(count, singular, plural)
    if count == 1 then
        return singular
    end
    return plural or (singular .. "s")
end)

LTF.RegisterFilter("upper", function(v)
    return tostring(v):upper()
end)
