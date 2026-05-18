local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestMutualExclusion", {
  [1002] = {
    ChapId = 1002,
    MEChapId = {1003},
    QuestChainId = {100207, 100208}
  },
  [1003] = {
    ChapId = 1003,
    MEChapId = {1002},
    QuestChainId = {
      100301,
      100302,
      100303,
      100304,
      100305,
      100306,
      100307
    }
  }
})
