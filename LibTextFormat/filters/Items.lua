LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.RegisterFilter("item", function(itemId, style)
    if not itemId then return "" end
    local realStyle = LINK_STYLE_DEFAULT
    if style == "bracket" then
      realStyle = LINK_STYLE_BRACKETS
    end
    local link = GetItemLink(itemId, realStyle)
    return link
end)
