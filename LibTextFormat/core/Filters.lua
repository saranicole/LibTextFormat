local LTF = LibTextFormat

function LTF:ListFilters()
  return self:GetVar("filters")
end

function LTF:RegisterFilter(name, fn)
    local filters = self:ListFilters() or {}
    filters[name] = fn
    self:SaveToVars("filters", filters)
end

function LTF:RegisterFiltersBulk(object)
  for key, filter in pairs(object) do
    self:RegisterFilter(key, filter)
  end
end

function LTF:GetFilter(filterName)
  return self:GetVarByValue("filters", filterName)
end