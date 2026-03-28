local ok, CommonConst = pcall(require, "CommonConst")
if not ok then
  CommonConst = {
    SystemLanguage = "TextMapContent",
    SystemLanguages = {
      Default = "TextMapContent"
    }
  }
end
local Dialogue = setmetatable({}, {
  __index = function(t, key)
    local ok, tbl = pcall(function()
      return DataMgr["Dialogue_" .. CommonConst.SystemLanguage]
    end)
    if not ok then
      tbl = nil
    end
    tbl = tbl or DataMgr["Dialogue_" .. CommonConst.SystemLanguages.Default]
    return tbl[key]
  end,
  __pairs = function(t)
    local ok, realTbl = pcall(function()
      return DataMgr["Dialogue_" .. CommonConst.SystemLanguage]
    end)
    if not ok then
      realTbl = nil
    end
    realTbl = realTbl or DataMgr["Dialogue_" .. CommonConst.SystemLanguages.Default]
    local mt = getmetatable(realTbl)
    if mt and mt.__pairs then
      return mt.__pairs(realTbl)
    else
      return next, realTbl, nil
    end
  end
})
return Dialogue
