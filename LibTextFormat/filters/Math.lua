LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or { ["v1"] = {} }

-- Variadic addition
LTF.Core["v1"]["add"] = function(...)
    local args = {...}
    local sum = 0
    for _, v in ipairs(args) do
        sum = sum + (LTF:toNumberSafe(v) or 0)
    end
    return sum
end

-- Variadic subtraction (left-to-right)
LTF.Core["v1"]["sub"] = function(...)
    local args = {...}
    local result = LTF:toNumberSafe(args[1]) or 0
    for i = 2, #args do
        result = result - (LTF:toNumberSafe(args[i]) or 0)
    end
    return result
end

-- Variadic multiplication
LTF.Core["v1"]["mul"] = function(...)
    local args = {...}
    local product = 1
    for _, v in ipairs(args) do
        product = product * (LTF:toNumberSafe(v) or 1)
    end
    return product
end

-- Variadic division (left-to-right, protect divide by zero)
LTF.Core["v1"]["div"] = function(...)
    local args = {...}
    local result = LTF:toNumberSafe(args[1]) or 0
    for i = 2, #args do
        local v = LTF:toNumberSafe(args[i]) or 0
        if v == 0 then return 0 end
        result = result / v
    end
    return result
end

-- Variadic modulus (left-to-right)
LTF.Core["v1"]["mod"] = function(...)
    local args = {...}
    local result = LTF:toNumberSafe(args[1]) or 0
    for i = 2, #args do
        local v = LTF:toNumberSafe(args[i]) or 1
        if v == 0 then return 0 end
        result = result % v
    end
    return result
end

-- Variadic exponentiation (left-to-right)
LTF.Core["v1"]["pow"] = function(...)
    local args = {...}
    local result = LTF:toNumberSafe(args[1]) or 0
    for i = 2, #args do
        result = result ^ (LTF:toNumberSafe(args[i]) or 1)
    end
    return result
end

-- Min of all arguments
LTF.Core["v1"]["min"] = function(...)
    local args = {...}
    local result = LTF:toNumberSafe(args[1]) or 0
    for i = 2, #args do
        local v = LTF:toNumberSafe(args[i])
        if v and v < result then
            result = v
        end
    end
    return result
end

-- Max of all arguments
LTF.Core["v1"]["max"] = function(...)
    local args = {...}
    local result = LTF:toNumberSafe(args[1]) or 0
    for i = 2, #args do
        local v = LTF:toNumberSafe(args[i])
        if v and v > result then
            result = v
        end
    end
    return result
end

-- Floor
LTF.Core["v1"]["floor"] = function(x)
    return math.floor(LTF:toNumberSafe(x) or 0)
end

-- Ceil
LTF.Core["v1"]["ceil"] = function(x)
    return math.ceil(LTF:toNumberSafe(x) or 0)
end
