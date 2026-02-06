local LTF = LibTextFormat

LTF.CoreProtocols = LTF.CoreProtocols or { ["v1"] = {} }

LTF.ProtocolMeta = LTF.ProtocolMeta or {
    tocsv = { consumes = "table", produces = "string" },
    fromcsv = { consumes = "string", produces = "table" },
}

LTF.CoreProtocols["v1"]["tocsv"] = function(ctx, value)
  local sep = ctx.pathSep or ","
  local recordSep = ctx.recordSep or "\n"

  local out = ""
  for i = 1, ipairs(value) do
    local record = table.concat(value[i], sep)
    out..recordSep..record
  end
  return out
end

LTF.CoreProtocols["v1"]["fromcsv"] = function(ctx, text)
    local sep = ctx.pathSep or ","
    local recordSep = ctx.recordSep or "\n"

    -- split text into records
    local records = {}
    local pos = 1
    while pos <= #text do
        local rsep_pos = text:find(recordSep, pos, true)
        if rsep_pos then
            table.insert(records, text:sub(pos, rsep_pos - 1))
            pos = rsep_pos + #recordSep
        else
            table.insert(records, text:sub(pos))
            break
        end
    end

    -- parse each record into fields
    local result = {}
    for _, record in ipairs(records) do
        table.insert(result, parseFields(record, sep))
    end

    return result
end

