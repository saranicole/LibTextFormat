LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core["plural"] = function(count, singular, plural)
    if count == 1 then
      return singular
    end
    return plural or (singular .. "s")
end

LTF.Core["number"] = function(value)
    return tonumber(value) or 0
end

LTF.Core["string"] = function(value)
    return tostring(value or "")
end
