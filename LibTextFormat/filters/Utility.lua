LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or { ["v1"] = {} }

LTF.Core["v1"]["plural"] = function(ctx, value)
    text = text or ""
    local count = ctx.scope:Get("count")
    local singular = ctx.scope:Get("singular")
    local plural = ctx.scope:Get("plural") or (singular .. "s")
    if count == 1 then
      return singular
    end
    return plural
end
