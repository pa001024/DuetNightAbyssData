local T = {}
T.RT_1 = {QuestChainId = 110232}
T.RT_2 = {
  QuestChainFinish = T.RT_1
}
T.RT_3 = {QuestChainId = 100306}
T.RT_4 = {
  QuestChainFinish = T.RT_3
}
T.RT_5 = {
  QuestChainUnFinish = T.RT_3
}
T.RT_6 = {}
T.RT_7 = {TalkTriggerId = 500080}
T.RT_8 = {
  ImprComp = T.RT_7
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DialogueCondition", {
  [51007572] = T.RT_8,
  [51007574] = T.RT_8,
  [51155701] = {
    QuestChainFinish = {QuestChainId = 200315}
  },
  [90290300] = T.RT_2,
  [90290400] = T.RT_2,
  [90290500] = T.RT_2,
  [90290801] = T.RT_2,
  [800305081] = {
    IsBoy = T.RT_6
  },
  [800305082] = {
    IsGirl = T.RT_6
  },
  [901900015] = {
    QuestChainFinish = {QuestChainId = 110109}
  },
  [902000011] = T.RT_4,
  [902000012] = T.RT_4,
  [902100011] = T.RT_5,
  [902100012] = T.RT_5,
  [902100013] = T.RT_5,
  [902100015] = T.RT_4,
  [902100016] = T.RT_4,
  [902100017] = T.RT_4
})
