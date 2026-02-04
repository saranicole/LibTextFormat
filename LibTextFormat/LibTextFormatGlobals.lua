LibTextFormat = ZO_DeferredInitializingObject:Subclass()

local LTF = LibTextFormat

function LTF:ListVars()
  return self.savedVars
end

function LTF:GetVar(key)
  local vars = self:ListVars()
  return vars[key]
end

function LTF:SaveToVars(key, value)
  self.savedVars[key] = value
end

function LTF:GetVarByValue(key, value)
  local var = self:GetVar(key)
  if var ~= nil then
    for k, v in pairs(self:GetVar(key)) do
      if value == k then
        return v
      end
    end
  end
  return nil
end

function LTF:Initialize(vars)
  self.savedVars = vars
end

function LTF:New(...)
  local object = ZO_Object.New(self)
  object:Initialize(...)
  return object
end
