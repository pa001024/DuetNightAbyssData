local ok, CommonConst = pcall(require, "CommonConst")
if not ok then
  CommonConst = {
    SystemLanguage = "TextMapContent",
    SystemLanguages = {
      Default = "TextMapContent"
    }
  }
end
local TextMap = setmetatable({}, {
  __index = function(t, key)
    local tbl = DataMgr["TextMap_" .. CommonConst.SystemLanguage]
    tbl = tbl or DataMgr["TextMap_" .. CommonConst.SystemLanguages.Default]
    return tbl[key]
  end,
  __pairs = function(t)
    local realTbl = DataMgr["TextMap_" .. CommonConst.SystemLanguage]
    realTbl = realTbl or DataMgr["TextMap_" .. CommonConst.SystemLanguages.Default]
    local mt = getmetatable(realTbl)
    if mt and mt.__pairs then
      return mt.__pairs(realTbl)
    else
      return next, realTbl, nil
    end
  end
})
return TextMap
