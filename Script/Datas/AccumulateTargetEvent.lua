local T = {}
T.RT_1 = {
  30,
  30,
  30,
  30,
  30,
  60,
  120,
  180
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AccumulateTargetEvent", {
  [112001] = {
    EventId = 112001,
    JumpUIId = 70,
    JumpUnlockCondition = 112001,
    JumpUnlockTips = "Event_JumpUnlock_112001",
    MaxProgressNum = {
      60,
      60,
      60,
      120,
      180
    },
    MaxProgressType = "Day",
    QuestPhaseId = 1201,
    TargetDes = "Event_TargetDes_112001"
  },
  [112002] = {
    EventId = 112002,
    JumpUIId = 70,
    JumpUnlockCondition = 112001,
    JumpUnlockTips = "Event_JumpUnlock_112001",
    MaxProgressNum = T.RT_1,
    MaxProgressType = "Day",
    QuestPhaseId = 1202,
    TargetDes = "Event_TargetDes_112001"
  },
  [112003] = {
    EventId = 112003,
    JumpUIId = 70,
    JumpUnlockCondition = 112001,
    JumpUnlockTips = "Event_JumpUnlock_112001",
    MaxProgressNum = T.RT_1,
    MaxProgressType = "Day",
    QuestPhaseId = 1203,
    TargetDes = "Event_TargetDes_112001"
  },
  [112004] = {
    EventId = 112004,
    JumpUIId = 70,
    JumpUnlockCondition = 112001,
    JumpUnlockTips = "Event_JumpUnlock_112001",
    MaxProgressNum = T.RT_1,
    MaxProgressType = "Day",
    QuestPhaseId = 1204,
    TargetDes = "Event_TargetDes_112001"
  }
})
