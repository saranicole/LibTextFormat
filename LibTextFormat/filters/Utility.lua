LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or { ["v1"] = {} }

LTF.Core["v1"]["plural"] = function(ctx, value)
    if ctx.count == 1 then
      return ctx.singular
    end
    return ctx.plural or (ctx.singular .. "s")
end
