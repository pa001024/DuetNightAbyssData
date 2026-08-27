local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CumulativeTopUpEvent", {
  [113001] = {
    EventDes = "UI_EventDes_113001",
    EventId = 113001,
    EventRule = "UI_EventRule_113001",
    JumpId = 85,
    LastRewardIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Fashion/T_Fashion_Fx46.T_Fashion_Fx46",
    LastRewardId = 60005,
    LastRewardTypeId = "CharAccessory",
    ScoreRankReward = {
      [300] = 11300101,
      [1000] = 11300102,
      [2000] = 11300103,
      [4000] = 11300104,
      [8000] = 11300105,
      [12000] = 11300106,
      [18000] = 11300107,
      [25000] = 11300108
    }
  }
})
