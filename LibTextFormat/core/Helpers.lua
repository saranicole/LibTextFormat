LibTextFormat = LibTextFormat or {}
local LTF = LibTextFormat

function LTF:NormalizeAccountName(account)
    if not account then return nil end
    account = tostring(account)
    if account:sub(1,1) ~= "@" then
        account = "@" .. account
    end
    return account
end
