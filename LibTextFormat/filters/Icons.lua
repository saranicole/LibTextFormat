LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.RegisterFilter("icon", function(link)
    return zo_iconFormat("EsoUI/Art/Icons/icon.dds", 16, 16) .. link
end)
