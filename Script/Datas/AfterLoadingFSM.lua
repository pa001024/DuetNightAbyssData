local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AfterLoadingFSM", {
  Advertisement = {
    FSMState = "Advertisement",
    NextState = "MonthCard"
  },
  BackToTrial = {
    FSMState = "BackToTrial",
    NextState = "MainLineQuest"
  },
  BeginState = {
    FSMState = "BeginState",
    NextState = "JumpToRogueMain"
  },
  CutSceneReview = {
    FSMState = "CutSceneReview",
    NextState = "ReturnActivity"
  },
  DungeonUI = {
    FSMState = "DungeonUI",
    NextState = "BackToTrial"
  },
  DynamicQuest = {
    FSMState = "DynamicQuest",
    NextState = "ShowLevel"
  },
  EndState = {FSMState = "EndState"},
  Entertainment = {
    FSMState = "Entertainment",
    NextState = "CutSceneReview"
  },
  GameplayReward = {
    FSMState = "GameplayReward",
    NextState = "SystemUnlock"
  },
  GuildSceneUI = {
    FSMState = "GuildSceneUI",
    NextState = "EndState"
  },
  JumpToRogueMain = {
    FSMState = "JumpToRogueMain",
    NextState = "GameplayReward"
  },
  LayoutPlan = {
    FSMState = "LayoutPlan",
    NextState = "DynamicQuest"
  },
  MainLineQuest = {
    FSMState = "MainLineQuest",
    NextState = "LayoutPlan"
  },
  MonthCard = {
    FSMState = "MonthCard",
    NextState = "TriggerGuide"
  },
  ReturnActivity = {
    FSMState = "ReturnActivity",
    NextState = "Advertisement"
  },
  ShowLevel = {
    FSMState = "ShowLevel",
    NextState = "GuildSceneUI"
  },
  SystemUnlock = {
    FSMState = "SystemUnlock",
    NextState = "Entertainment"
  },
  TriggerGuide = {
    FSMState = "TriggerGuide",
    NextState = "DungeonUI"
  }
})
