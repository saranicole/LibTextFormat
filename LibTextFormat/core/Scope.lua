LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

local Scope = {}
Scope.__index = Scope

local SAFE_GLOBALS = {
    math = math,
    string = string,
    zo_strformat = zo_strformat,
}

function Scope:New(initial)
    local vars = initial or {}

    return setmetatable({
        _vars = vars
    }, self)
end

function Scope:Add(key, value)
    self._vars[key] = value
end

function Scope:Get(key)
    return self._vars[key]
end

function Scope:Update(key, value)
    self._vars[key] = value
end

function Scope:Delete(key)
    self._vars[key] = nil
end

function Scope:Env()
    return setmetatable({}, {
        __index = function(_, k)
            return self._vars[k] or SAFE_GLOBALS[k]
        end
    })
end

LTF.Scope = Scope
