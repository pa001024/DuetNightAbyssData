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
    local tbl = DataMgr["Dialogue_" .. CommonConst.SystemLanguage]
    tbl = tbl or DataMgr["Dialogue_" .. CommonConst.SystemLanguages.Default]
    return tbl[key]
  end,
  __pairs = function(t)
    local realTbl = DataMgr["Dialogue_" .. CommonConst.SystemLanguage]
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
