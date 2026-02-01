LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

LTF.RegisterFilter("house", function(houseId, userId)
    if not houseId then return "" end
    local username = LTF:NormalizeAccountName(userId)
    return zo_strformat("|H1:housing:<<1>>:<<2>>|h|h", houseId, username)
end)
