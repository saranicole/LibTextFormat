local LTF = LibTextFormat

LTF.Core = LTF.Core or { ["v1"] = {} }

local function NormalizeAccountName(name)
    if not IsDecoratedDisplayName(name) then
        return DecorateDisplayName(name)
    end
    return name
end

LTF.Core["v1"]["house"] = function(ctx, text)
    if not ctx.houseId then return "" end
    local username = NormalizeAccountName(ctx.userId)
    return text..zo_strformat("|H1:housing:<<1>>:<<2>>|h|h", ctx.houseId, ctx.username)
end
