LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or { ["v1"] = {} }

LTF.Core["v1"]["icon"] = function(ctx, text)
  if not ctx.width then
    ctx.width = 16
  end
  if not ctx.height then
    ctx.height = ctx.width
  end
  return text..zo_iconFormat(ctx.link, ctx.width, ctx.height)
end
