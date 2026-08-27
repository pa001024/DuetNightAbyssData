local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AsyncCombatEventConstant", {
  AsyncCombat_AddBonusRate1 = {
    ConstantName = "AsyncCombat_AddBonusRate1",
    ConstantValue = 206
  },
  AsyncCombat_AddBonusRate2 = {
    ConstantName = "AsyncCombat_AddBonusRate2",
    ConstantValue = 207
  },
  AsyncCombat_AddBonusRate20 = {
    ConstantName = "AsyncCombat_AddBonusRate20",
    ConstantValue = 209
  },
  AsyncCombat_AddBonusRate8 = {
    ConstantName = "AsyncCombat_AddBonusRate8",
    ConstantValue = 208
  },
  AsyncCombat_BaseContributionRequire = {
    ConstantName = "AsyncCombat_BaseContributionRequire",
    ConstantValue = 300
  },
  AsyncCombat_BaseContributionReward = {
    ConstantName = "AsyncCombat_BaseContributionReward",
    ConstantValue = 500
  },
  AsyncCombat_ConcurrencyLimit = {
    ConstantName = "AsyncCombat_ConcurrencyLimit",
    ConstantValue = 5
  },
  AsyncCombat_DungeonCD = {
    ConstantName = "AsyncCombat_DungeonCD",
    ConstantValue = 600
  },
  AsyncCombat_EventId = {
    ConstantName = "AsyncCombat_EventId",
    ConstantValue = 121003
  },
  AsyncCombat_HomeownerLimit = {
    ConstantName = "AsyncCombat_HomeownerLimit",
    ConstantValue = 19
  },
  AsyncCombat_MVPContributionReward = {
    ConstantName = "AsyncCombat_MVPContributionReward",
    ConstantValue = 3000
  },
  AsyncCombat_MVPRewardPerHomeOwner = {
    ConstantName = "AsyncCombat_MVPRewardPerHomeOwner",
    ConstantValue = 300
  },
  AsyncCombat_MakePublicTime = {
    ConstantName = "AsyncCombat_MakePublicTime",
    ConstantValue = 720
  },
  AsyncCombat_RoomCapacityLimit = {
    ConstantName = "AsyncCombat_RoomCapacityLimit",
    ConstantValue = 20
  },
  AsyncCombat_RoomClearDuration = {
    ConstantName = "AsyncCombat_RoomClearDuration",
    ConstantValue = 3
  },
  AsyncCombat_RoomDuration = {
    ConstantName = "AsyncCombat_RoomDuration",
    ConstantValue = 1440
  },
  AsyncCombat_RoomListPageSize = {
    ConstantName = "AsyncCombat_RoomListPageSize",
    ConstantValue = 100
  },
  AsyncCombat_RoomRewardMailId = {
    ConstantName = "AsyncCombat_RoomRewardMailId",
    ConstantValue = 10085
  },
  AsyncCombat_SpawnInterval = {
    ConstantName = "AsyncCombat_SpawnInterval",
    ConstantValue = 2
  },
  AsyncCombat_StoppageTimeRoomDuration = {
    ConstantName = "AsyncCombat_StoppageTimeRoomDuration",
    ConstantValue = 720
  },
  AsyncCombat_StoppageTimeRoomShowHintTime = {
    ConstantName = "AsyncCombat_StoppageTimeRoomShowHintTime",
    ConstantValue = 30
  },
  AsyncCombat_WeeklyLimit = {
    ConstantName = "AsyncCombat_WeeklyLimit",
    ConstantValue = 3
  },
  AsyncRoomGenerateEnd = {
    ConstantName = "AsyncRoomGenerateEnd",
    ConstantValue = 22
  },
  AsyncRoomGenerateStart = {
    ConstantName = "AsyncRoomGenerateStart",
    ConstantValue = 7
  },
  AsyncRoomGenerate_MaxTotalCount = {
    ConstantName = "AsyncRoomGenerate_MaxTotalCount",
    ConstantValue = 150
  },
  AsyncRoom_CheckInterval = {
    ConstantName = "AsyncRoom_CheckInterval",
    ConstantValue = 600
  },
  AsyncRoom__CheckCount = {
    ConstantName = "AsyncRoom__CheckCount",
    ConstantValue = 2
  },
  Async_FreeGiveNum = {
    ConstantName = "Async_FreeGiveNum",
    ConstantValue = 3
  },
  Async_FreeGiveWeekDay = {
    ConstantName = "Async_FreeGiveWeekDay",
    ConstantValue = 5
  },
  Async_FreeRoomBonusRate = {
    ConstantName = "Async_FreeRoomBonusRate",
    ConstantValue = 10
  },
  Async_HighRiskScript = {
    ConstantName = "Async_HighRiskScript",
    ConstantValue = 1.5
  },
  Async_HighRiskScriptTime = {
    ConstantName = "Async_HighRiskScriptTime",
    ConstantValue = 24
  },
  Async_MediumRiskScript = {
    ConstantName = "Async_MediumRiskScript",
    ConstantValue = 1
  },
  Async_MediumRiskScriptTime = {
    ConstantName = "Async_MediumRiskScriptTime",
    ConstantValue = 24
  },
  Async_MvpScore = {
    ConstantName = "Async_MvpScore",
    ConstantValue = 3
  },
  Async_ParticipationScore = {
    ConstantName = "Async_ParticipationScore",
    ConstantValue = 1
  },
  Async_RiskScriptCopyID = {
    ConstantName = "Async_RiskScriptCopyID",
    ConstantValue = 40604
  }
})
