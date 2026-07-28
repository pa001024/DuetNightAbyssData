local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomStick", {
  [101] = {StickId = 101},
  [102] = {StickId = 102},
  [103] = {StickId = 103}
})
