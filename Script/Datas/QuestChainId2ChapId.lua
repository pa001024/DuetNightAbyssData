local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestChainId2ChapId", {
  [100207] = 1002,
  [100208] = 1002,
  [100301] = 1003,
  [100302] = 1003,
  [100303] = 1003,
  [100304] = 1003,
  [100305] = 1003,
  [100306] = 1003,
  [100307] = 1003
})
