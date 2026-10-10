local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4Resource", {
  [1] = {
    AutoUse = false,
    MaxStack = 9999,
    ResourceId = 1
  }
})
