LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

-- For the special case of math operations we always convert from strings
local function toNumberSafe(value, default)
    default = default or 0
    if value == nil then return default end
    local n = tonumber(value)
    if n == nil then return default end
    return n
end

-- Variadic addition
LTF.Core["add"] = function(...)
    local args = {...}
    local sum = 0
    for _, v in ipairs(args) do
        sum = sum + (toNumberSafe(v) or 0)
    end
    return sum
end

-- Variadic subtraction (left-to-right)
LTF.Core["sub"] = function(...)
    local args = {...}
    local result = toNumberSafe(args[1]) or 0
    for i = 2, #args do
        result = result - (toNumberSafe(args[i]) or 0)
    end
    return result
end

-- Variadic multiplication
LTF.Core["mul"] = function(...)
    local args = {...}
    local product = 1
    for _, v in ipairs(args) do
        product = product * (toNumberSafe(v) or 1)
    end
    return product
end

-- Variadic division (left-to-right, protect divide by zero)
LTF.Core["div"] = function(...)
    local args = {...}
    local result = toNumberSafe(args[1]) or 0
    for i = 2, #args do
        local v = toNumberSafe(args[i]) or 0
        if v == 0 then return 0 end
        result = result / v
    end
    return result
end

-- Variadic modulus (left-to-right)
LTF.Core["mod"] = function(...)
    local args = {...}
    local result = toNumberSafe(args[1]) or 0
    for i = 2, #args do
        local v = toNumberSafe(args[i]) or 1
        if v == 0 then return 0 end
        result = result % v
    end
    return result
end

-- Variadic exponentiation (left-to-right)
LTF.Core["pow"] = function(...)
    local args = {...}
    local result = toNumberSafe(args[1]) or 0
    for i = 2, #args do
        result = result ^ (toNumberSafe(args[i]) or 1)
    end
    return result
end

-- Min of all arguments
LTF.Core["min"] = function(...)
    local args = {...}
    local result = toNumberSafe(args[1]) or 0
    for i = 2, #args do
        local v = toNumberSafe(args[i])
        if v and v < result then
            result = v
        end
    end
    return result
end

-- Max of all arguments
LTF.Core["max"] = function(...)
    local args = {...}
    local result = toNumberSafe(args[1]) or 0
    for i = 2, #args do
        local v = toNumberSafe(args[i])
        if v and v > result then
            result = v
        end
    end
    return result
end

-- Floor
LTF.Core["floor"] = function(x)
    return math.floor(toNumberSafe(x) or 0)
end

-- Ceil
LTF.Core["ceil"] = function(x)
    return math.ceil(toNumberSafe(x) or 0)
end
