local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestEnd", {
  [13010101] = {
    EndId = 13010101,
    EndType = 0,
    RedoQuestId = 13010103
  },
  [13010102] = {EndId = 13010102, EndType = 1}
})
