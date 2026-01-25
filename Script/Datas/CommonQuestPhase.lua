local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CommonQuestPhase", {
  [1001] = {
    EventId = 102001,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Activity_East_Season01_01.T_Tab_Activity_East_Season01_01",
    Index = 1,
    QuestPhaseId = 1001,
    QuestPhaseName = "Event_102001_QuestName1",
    RewardPreview = 1020011,
    SplineBP = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/East/Season01/Spine/WBP_Activity_East_Season01_Spine_01.WBP_Activity_East_Season01_Spine_01'"
  },
  [1002] = {
    EventId = 102001,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Activity_East_Season01_02.T_Tab_Activity_East_Season01_02",
    Index = 2,
    QuestPhaseId = 1002,
    QuestPhaseName = "Event_102001_QuestName2",
    RewardPreview = 1020011,
    SplineBP = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/East/Season01/Spine/WBP_Activity_East_Season01_Spine_02.WBP_Activity_East_Season01_Spine_02'"
  },
  [1003] = {
    EventId = 102001,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Activity_East_Season01_03.T_Tab_Activity_East_Season01_03",
    Index = 3,
    QuestPhaseId = 1003,
    QuestPhaseName = "Event_102001_QuestName3",
    RewardPreview = 1020011,
    SplineBP = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/East/Season01/Spine/WBP_Activity_East_Season01_Spine_03.WBP_Activity_East_Season01_Spine_03'"
  },
  [1004] = {
    EventId = 102001,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Activity_East_Season01_04.T_Tab_Activity_East_Season01_04",
    Index = 4,
    QuestPhaseId = 1004,
    QuestPhaseName = "Event_102001_QuestName4",
    RewardPreview = 1020011,
    SplineBP = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/East/Season01/Spine/WBP_Activity_East_Season01_Spine_04.WBP_Activity_East_Season01_Spine_04'"
  },
  [2001] = {
    EventId = 111001,
    Index = 1,
    QuestPhaseId = 2001,
    QuestPhaseName = "RaidDungeon_Raid_Rank"
  },
  [2002] = {
    EventId = 111001,
    Index = 2,
    QuestPhaseId = 2002,
    QuestPhaseName = "RaidDungeon_PreRaid_Rank"
  }
})
