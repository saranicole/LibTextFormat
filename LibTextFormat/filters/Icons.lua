LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or {}

LTF.Core["icon"] = function(link, width, height)
  if not width then
    width = 16
  end
  if not height then
    height = width
  end
  return zo_iconFormat(link, width, height)
end
