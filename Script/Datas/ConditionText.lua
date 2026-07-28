local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ConditionText", {
  ActivePropEffectId = {
    ConditionLogic = "C",
    ConditionType = "ActivePropEffectId"
  },
  AvatarStatus = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "AvatarStatus"
  },
  BuyGoods = {ConditionLogic = "S", ConditionType = "BuyGoods"},
  CharEquipRarityLevelModCount = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "CharEquipRarityLevelModCount"
  },
  ComeBackEventScore = {
    ConditionLogic = "S",
    ConditionType = "ComeBackEventScore"
  },
  ConditionalRewardEventEnd = {
    ConditionLogic = "S",
    ConditionType = "ConditionalRewardEventEnd"
  },
  ConstantBool = {
    ConditionLogic = "S",
    ConditionType = "ConstantBool"
  },
  CurrentCharId = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "CurrentCharId"
  },
  DailyFreeTicketAmount = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "DailyFreeTicketAmount"
  },
  DailyLoginEnd = {
    ConditionLogic = "S",
    ConditionType = "DailyLoginEnd"
  },
  DialogueHasRead = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "DialogueHasRead"
  },
  DualTerminalLogin = {
    ConditionLogic = "S",
    ConditionType = "DualTerminalLogin"
  },
  DungeonComplete = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "DungeonComplete"
  },
  DungeonType = {
    AutoTrigger = true,
    ConditionLogic = "S&DS",
    ConditionType = "DungeonType"
  },
  DynamicEventCompleteTimes = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "DynamicEventCompleteTimes"
  },
  EquipPetId = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "EquipPetId"
  },
  ExploreGroup = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "ExploreGroup"
  },
  FinishAbyss = {
    ConditionLogic = "S",
    ConditionType = "FinishAbyss"
  },
  FollowCommunityComplete = {
    ConditionLogic = "S",
    ConditionType = "FollowCommunityComplete"
  },
  ForgeLevel = {ConditionLogic = "S", ConditionType = "ForgeLevel"},
  GachaCount = {ConditionLogic = "S", ConditionType = "GachaCount"},
  GuildBossTrialFinishedCount = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionName = "UI_QUEST_CONDITION_SoloTreasure",
    ConditionType = "GuildBossTrialFinishedCount"
  },
  GuildLevelMin = {
    ConditionLogic = "S",
    ConditionType = "GuildLevelMin"
  },
  HardBossComplete = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "HardBossComplete"
  },
  HasModLevel = {
    ConditionLogic = "S",
    ConditionType = "HasModLevel"
  },
  HaveGotSoloTreasureScore = {
    ConditionLogic = "S",
    ConditionName = "UI_QUEST_CONDITION_SoloTreasure",
    ConditionType = "HaveGotSoloTreasureScore"
  },
  HaveItem = {ConditionLogic = "S", ConditionType = "HaveItem"},
  HaveResource = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "HaveResource"
  },
  HaveResourceSType = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "HaveResourceSType"
  },
  HyperCardLevel = {
    ConditionLogic = "S",
    ConditionType = "HyperCardLevel"
  },
  ImprShopUnlock = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "ImprShopUnlock"
  },
  Impression = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "Impression"
  },
  InDungeon = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "InDungeon"
  },
  InGuild = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "InGuild"
  },
  InHardBossDifficulty = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "InHardBossDifficulty"
  },
  InStoryMode = {
    AutoTrigger = true,
    ConditionLogic = "C",
    ConditionType = "InStoryMode"
  },
  InteractTriggerFinished = {
    ConditionLogic = "S",
    ConditionType = "InteractTriggerFinished"
  },
  IsCurrentCharEquipMod = {
    ConditionLogic = "C",
    ConditionType = "IsCurrentCharEquipMod"
  },
  IsSpecialQuest = {
    ConditionType = "IsSpecialQuest"
  },
  LoginDay = {ConditionLogic = "S", ConditionType = "LoginDay"},
  LoginEventFinish = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "LoginEventFinish"
  },
  MechanismState = {
    AutoTrigger = true,
    ConditionLogic = "DS",
    ConditionType = "MechanismState"
  },
  OwnCharIdAndLevel = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "OwnCharIdAndLevel"
  },
  PermRewardCollectionFinish = {
    ConditionLogic = "S",
    ConditionType = "PermRewardCollectionFinish"
  },
  PhaseQuestEnd = {
    ConditionLogic = "S",
    ConditionType = "PhaseQuestEnd"
  },
  PlayerInBattlePass = {
    ConditionLogic = "C",
    ConditionType = "PlayerInBattlePass"
  },
  PlayerLevelMax = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "PlayerLevelMax"
  },
  PlayerLevelMin = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionName = "UI_QUEST_CONDITION_PLAYERLEVEL",
    ConditionType = "PlayerLevelMin"
  },
  PlayerLvEventEnd = {
    ConditionLogic = "S",
    ConditionType = "PlayerLvEventEnd"
  },
  Quest = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "Quest"
  },
  QuestChain = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionName = "UI_QUEST_CONDITION_FINISHQUEST",
    ConditionType = "QuestChain"
  },
  QuestChainTrueEnd = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "QuestChainTrueEnd"
  },
  RegionCapturePet = {
    ConditionLogic = "S",
    ConditionType = "RegionCapturePet"
  },
  RougeLikeComplete = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "RougeLikeComplete"
  },
  RougeLikeDifficulty = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "RougeLikeDifficulty"
  },
  RougeLikeGroupMax = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "RougeLikeGroupMax"
  },
  RougeLikeGroupMin = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "RougeLikeGroupMin"
  },
  RougeLikeManual = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "RougeLikeManual"
  },
  RougeLikePassRoom = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "RougeLikePassRoom"
  },
  RougeLikePreAward = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "RougeLikePreAward"
  },
  RougeLikePreRoom = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "RougeLikePreRoom"
  },
  StarterQuestFinish = {
    ConditionLogic = "S",
    ConditionType = "StarterQuestFinish"
  },
  SubRegionType = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "SubRegionType"
  },
  TeleportIsUnlock = {
    ConditionLogic = "C",
    ConditionType = "TeleportIsUnlock"
  },
  TestClientCon = {
    ConditionLogic = "C",
    ConditionType = "TestClientCon"
  },
  TimeArrived = {
    ConditionLogic = "S",
    ConditionType = "TimeArrived"
  },
  TrialEventFinish = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "TrialEventFinish"
  },
  TrueQuest = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "TrueQuest"
  },
  TrueQuestChain = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionName = "UI_QUEST_CONDITION_FINISHQUEST",
    ConditionType = "TrueQuestChain"
  },
  UnlockMountId = {
    AutoTrigger = true,
    ConditionLogic = "S",
    ConditionType = "UnlockMountId"
  },
  VarEqual = {ConditionLogic = "S", ConditionType = "VarEqual"}
})
