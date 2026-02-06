LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or { ["v1"] = {} }

LTF.Core["v1"]["split"] = function(str, delim)
    str = tostring(str or "")
    delim = delim or "%s"  -- default whitespace
    local t = {}
    for s in string.gmatch(str, "([^" .. delim .. "]+)") do
        table.insert(t, s)
    end
    return t
end

LTF.Core["v1"]["join"] = function(tbl, sep)
    sep = sep or ""
    if type(tbl) ~= "table" then return tostring(tbl or "") end
    return table.concat(tbl, sep)
end

LTF.Core["v1"]["substr"] = function(str, startIdx, length)
    str = tostring(str or "")
    startIdx = LTF:toNumberSafe(startIdx, 1)
    if length ~= nil then
        length = LTF:toNumberSafe(length)
        return string.sub(str, startIdx, startIdx + length - 1)
    else
        return string.sub(str, startIdx)
    end
end

LTF.Core["v1"]["lower"] = function(str)
    return tostring(str or ""):lower()
end

LTF.Core["v1"]["upper"] = function(str)
    return tostring(str or ""):upper()
end

LTF.Core["v1"]["trim"] = function(str)
    return tostring(str or ""):match("^%s*(.-)%s*$")
end

LTF.Core["v1"]["gsub"] = function(str, pattern, replacement)
    str = tostring(str or "")
    pattern = tostring(pattern or "")
    replacement = tostring(replacement or "")
    return string.gsub(str, pattern, replacement)
end

LTF.Core["v1"]["startsWith"] = function(str, prefix)
    str = tostring(str or "")
    prefix = tostring(prefix or "")
    return str:sub(1, #prefix) == prefix
end

LTF.Core["v1"]["endsWith"] = function(str, suffix)
    str = tostring(str or "")
    suffix = tostring(suffix or "")
    return str:sub(-#suffix) == suffix
end

LTF.Core["v1"]["contains"] = function(str, substr)
    str = tostring(str or "")
    substr = tostring(substr or "")
    return str:find(substr, 1, true) ~= nil
end

LTF.Core["v1"]["replaceFirst"] = function(str, pattern, replacement)
    str = tostring(str or "")
    pattern = tostring(pattern or "")
    replacement = tostring(replacement or "")
    -- Replace only the first match
    local s, n = str:gsub(pattern, replacement, 1)
    return s
end

LTF.Core["v1"]["repeat"] = function(str, times)
    str = tostring(str or "")
    times = LTF:toNumberSafe(times, 1)
    return str:rep(times)
end
