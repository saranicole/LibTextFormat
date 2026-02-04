LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core["split"] = function(str, delim)
    str = tostring(str or "")
    delim = delim or "%s"  -- default whitespace
    local t = {}
    for s in string.gmatch(str, "([^" .. delim .. "]+)") do
        table.insert(t, s)
    end
    return t
end

LTF.Core["join"] = function(tbl, sep)
    sep = sep or ""
    if type(tbl) ~= "table" then return tostring(tbl or "") end
    return table.concat(tbl, sep)
end

LTF.Core["substr"] = function(str, startIdx, length)
    str = tostring(str or "")
    startIdx = toNumberSafe(startIdx, 1)
    if length ~= nil then
        length = toNumberSafe(length)
        return string.sub(str, startIdx, startIdx + length - 1)
    else
        return string.sub(str, startIdx)
    end
end

LTF.Core["lower"] = function(str)
    return tostring(str or ""):lower()
end

LTF.Core["upper"] = function(str)
    return tostring(str or ""):upper()
end

LTF.Core["trim"] = function(str)
    return tostring(str or ""):match("^%s*(.-)%s*$")
end

LTF.Core["gsub"] = function(str, pattern, replacement)
    str = tostring(str or "")
    pattern = tostring(pattern or "")
    replacement = tostring(replacement or "")
    return string.gsub(str, pattern, replacement)
end

LTF.Core["startsWith"] = function(str, prefix)
    str = tostring(str or "")
    prefix = tostring(prefix or "")
    return str:sub(1, #prefix) == prefix
end

LTF.Core["endsWith"] = function(str, suffix)
    str = tostring(str or "")
    suffix = tostring(suffix or "")
    return str:sub(-#suffix) == suffix
end

LTF.Core["contains"] = function(str, substr)
    str = tostring(str or "")
    substr = tostring(substr or "")
    return str:find(substr, 1, true) ~= nil
end

LTF.Core["replaceFirst"] = function(str, pattern, replacement)
    str = tostring(str or "")
    pattern = tostring(pattern or "")
    replacement = tostring(replacement or "")
    -- Replace only the first match
    local s, n = str:gsub(pattern, replacement, 1)
    return s
end

LTF.Core["repeat"] = function(str, times)
    str = tostring(str or "")
    times = toNumberSafe(times, 1)
    return str:rep(times)
end
