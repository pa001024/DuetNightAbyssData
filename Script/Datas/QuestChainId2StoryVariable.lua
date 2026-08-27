local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestChainId2StoryVariable", {
  [100101] = {
    [1] = "TestVar3",
    [2] = "TestVar4"
  },
  [100102] = {
    [1] = "TestVar5"
  },
  [120001] = {
    [1] = "FirstGotoIceCity12000103"
  },
  [200317] = {
    [1] = "Fish200317"
  }
})
