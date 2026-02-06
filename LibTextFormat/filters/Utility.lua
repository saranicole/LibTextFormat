LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or { ["v1"] = {} }

LTF.Core["v1"]["plural"] = function(count, singular, plural)
    if count == 1 then
      return singular
    end
    return plural or (singular .. "s")
end

LTF.Core["v1"]["number"] = function(value)
    return tonumber(value) or 0
end

LTF.Core["v1"]["string"] = function(value)
    return tostring(value or "")
end
