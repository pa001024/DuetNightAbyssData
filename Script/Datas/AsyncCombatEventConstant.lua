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
    ConstantValue = 121001
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
    ConstantValue = 60
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
  AsyncCombat_WeeklyLimit = {
    ConstantName = "AsyncCombat_WeeklyLimit",
    ConstantValue = 3
  }
})
