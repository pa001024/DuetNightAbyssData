local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ComeBackEvent", {
  [114001] = {
    EventLoginId = 114001,
    EventOneTimeReward = 114001,
    EventQuestId = 114001,
    EventSchemeId = 114001,
    InviteEventSchemeId = 114001
  },
  [114002] = {
    EventLoginId = 114001,
    EventOneTimeReward = 114001,
    EventQuestId = 114002,
    EventSchemeId = 114002,
    InviteEventSchemeId = 114001
  }
})
