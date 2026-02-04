local LTF = LibTextFormat

LTF.Core = LTF.Core or {}

LTF.Core["house"] = function(houseId, userId)
    if not houseId then return "" end
    local username = ZO_FormatUserFacingCharacterOrDisplayName(userId)
    return zo_strformat("|H1:housing:<<1>>:<<2>>|h|h", houseId, username)
end
