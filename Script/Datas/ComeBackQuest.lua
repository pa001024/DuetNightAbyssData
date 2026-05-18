local T = {}
T.RT_1 = {
  1401,
  1402,
  1403
}
T.RT_2 = {
  100,
  200,
  300,
  400,
  500
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ComeBackQuest", {
  [114001] = {
    EventQuestId = 114001,
    PhaseUnlockInterval = 24,
    QuestPhase = T.RT_1,
    QuestProgressResource = 2005,
    QuestReward = {
      1140011,
      1140012,
      1140013,
      1140014,
      1140015
    },
    QuestRewardProgress = T.RT_2
  },
  [114002] = {
    EventQuestId = 114002,
    PhaseUnlockInterval = 24,
    QuestPhase = T.RT_1,
    QuestProgressResource = 2005,
    QuestReward = {
      1140021,
      1140022,
      1140023,
      1140024,
      1140025
    },
    QuestRewardProgress = T.RT_2
  }
})
