local LTF = LibTextFormat

LTF.CoreProtocols = LTF.CoreProtocols or { ["v1"] = {} }

LTF.ProtocolMeta = LTF.ProtocolMeta or {
    tocsv = { consumes = "table", produces = "string" },
    fromcsv = { consumes = "string", produces = "table" },
}

LTF.CoreProtocols["v1"]["tocsv"] = function(ctx, text)
  local sep = ctx.pathSep or ","
  return table.concat(text, sep)
end

LTF.CoreProtocols["v1"]["fromcsv"] = function(ctx, text)
  local result = {}
  local i = 1
  local sep = ctx.pathSep or ","

  while #text > 0 do
      if text:sub(1,1) == '"' then
          -- quoted field
          local val = ""
          text = text:sub(2)

          while true do
              local quotePos = text:find('"', 1, true)
              if not quotePos then
                  error("LTF: Malformed CSV, missing quote")
              end

              val = val .. text:sub(1, quotePos - 1)
              text = text:sub(quotePos + 1)

              if text:sub(1,1) == '"' then
                  val = val .. '"'
                  text = text:sub(2)
              else
                  break
              end
          end

          table.insert(result, val)
      else
          local commaPos = text:find(delimiter, 1, true)
          if commaPos then
              table.insert(result, text:sub(1, commaPos - 1))
              text = text:sub(commaPos + 1)
          else
              table.insert(result, text)
              text = ""
          end
      end

      if text:sub(1,1) == sep then
          text = text:sub(2)
      end
  end
  return result
end
