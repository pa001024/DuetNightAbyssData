local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DropProbType", {
  DropTag_EventReward = {
    DropTypeKey = "DropTag_EventReward",
    DropTypeSequence = 99,
    DropTypeText = "MAIN_UI_GAMEEVENT"
  },
  DropTag_Prob = {
    DropTypeKey = "DropTag_Prob",
    DropTypeText = "DropTypeText_Prob"
  },
  DropTag_SynthesisChest = {
    DropTypeKey = "DropTag_SynthesisChest",
    DropTypeSequence = 1,
    DropTypeText = "DropTypeText_SynthesisChest"
  },
  DropTag_WeeklyReward = {
    DropTypeKey = "DropTag_WeeklyReward",
    DropTypeText = "DropTypeText_WeeklyReward"
  },
  DropType_Fixed = {
    DropTypeKey = "DropType_Fixed",
    DropTypeText = "DropTypeText_Fixed"
  },
  DropType_Rare = {
    DropTypeKey = "DropType_Rare",
    DropTypeText = "DropTypeText_Rare",
    IsRareItem = true
  }
})
