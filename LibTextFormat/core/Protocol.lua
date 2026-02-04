LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or {}

-- protocol = {
--     encode = function(value, opts) end,
--     decode = function(text, opts) end,
--     delimiters = {
--         group = "\n",
--         record = "|",
--         item = ",",
--     }
-- }

local TEMPLATE_SCHEMA =
{
    encode   = {
      "function",
      optional = true,
      default = function(self, ctx)
        if ctx and next(ctx) then
          local records = ctx.scope:Get("records")
          local delims = self.delimiters

          local group  = delims.group
          local record = delims.record
          local item   = delims.item

          local out = {}

          for _, rec in ipairs(records) do
              local fields = {}
              for _, field in ipairs(rec) do
                  if type(field) == "table" then
                      fields[#fields + 1] = table.concat(field, item)
                  else
                      fields[#fields + 1] = tostring(field)
                  end
              end
              out[#out + 1] = table.concat(fields, record)
          end

          return table.concat(out, group)
        end
        return false
      end
    },
    decode      = {
      "function",
      optional = true,
      default = function(self, ctx)
        if ctx and next(ctx) then
          local text = ctx.scope:Get("text")
          local delims = self.delimiters

          local group  = delims.group
          local record = delims.record
          local item   = delims.item

          local records = {}

          for recStr in text:gmatch("[^" .. group .. "]+") do
              local rec = {}
              for field in recStr:gmatch("[^" .. record .. "]+") do
                  if field:find(item, 1, true) then
                      local items = {}
                      for i in field:gmatch("[^" .. item .. "]+") do
                          items[#items + 1] = i
                      end
                      rec[#rec + 1] = items
                  else
                      rec[#rec + 1] = field
                  end
              end
              records[#records + 1] = rec
          end

          return records
        end
        return false
      end
    },

    delimiters = {
      "table",
      default = {
        group = "\n",
        record = ";",
        item = ","
      },
      schema = {
        group = "string",
        record = "string",
        item = "string"
      },
      optional = true
    }
}

local function NormalizeAndValidate(input, schema, context, ctx)
    context = context or "object"
    ctx = ctx or {}
    input = input or {}

    if type(input) ~= "table" then
        return nil, context .. " must be a table"
    end

    local output = {}

    -- 1️⃣ First pass: copy provided values
    for k, v in pairs(input) do
        output[k] = v
    end

    -- 2️⃣ Second pass: apply schema + defaults
    for field, rule in pairs(schema) do
        local expectedTypes
        local optional
        local default

        if type(rule) == "table" then
            expectedTypes = rule.types or rule
            optional = rule.optional
            default = rule.default
        else
            expectedTypes = { rule }
        end

        local value = output[field]

        if value == nil then
            if default ~= nil then
                value = type(default) == "function"
                    and default(output, ctx)
                    or default
            elseif not optional then
                return nil, string.format(
                    "%s missing required field '%s'",
                    context, field
                )
            end
        end

        if value ~= nil then
            local ok = false
            local t = type(value)
            for _, expected in ipairs(expectedTypes) do
                if t == expected then
                    ok = true
                    break
                end
            end

            if not ok then
                return nil, string.format(
                    "%s field '%s' must be %s (got %s)",
                    context, field,
                    table.concat(expectedTypes, " or "),
                    t
                )
            end
        end

        output[field] = value
    end

    return output
end

function LTF:ListProtocols()
  return self:GetVar("protocols")
end

function LTF:GetProtocol(protocolName)
  return self:GetVarByValue("protocols", protocolName)
end

function LTF:RegisterProtocol(name, protocol)
    local proto, err = NormalizeAndValidate(
        protocol,
        TEMPLATE_SCHEMA,
        string.format("LibTextFormat protocol '%s'", name or "?")
    )
  if not proto then
      d("|cFF0000[LTF]|r " .. err)
      return false
  end
  local protocols = self:ListProtocols() or {}
  protocols[name] = proto
  self:SaveToVars("protocols", protocols)
end
