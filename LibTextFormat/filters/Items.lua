LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.Core = LTF.Core or { ["v1"] = {} }

LTF.Core["v1"]["item"] = function(itemId)
    if not itemId then return "" end
    local realStyle = LINK_STYLE_DEFAULT
    if style == "bracket" then
      realStyle = LINK_STYLE_BRACKETS
    end
    local link = GetItemLink(itemId, realStyle)
    return link
end
