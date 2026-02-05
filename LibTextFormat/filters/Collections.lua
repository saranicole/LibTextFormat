local LTF = LibTextFormat

LTF.Core = LTF.Core or {}

local function NormalizeAccountName(name)
    if not IsDecoratedDisplayName(name) then
        return DecorateDisplayName(name)
    end
    return name
end

LTF.Core["house"] = function(houseId, userId)
    if not houseId then return "" end
    local username = NormalizeAccountName(userId)
    return zo_strformat("|H1:housing:<<1>>:<<2>>|h|h", houseId, username)
end
