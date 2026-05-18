local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local ServerDungeonBase = DungeonClass.Class()
ServerDungeonBase.__Component__ = {
  "BluePrints.DungeonObject.DungeonBase",
  "BluePrints.DungeonObject.Server.DungeonReplicatedProperty",
  "BluePrints.DungeonObject.Server.PlayerManager"
}

function ServerDungeonBase:BeginPlay()
  self.ActiveMonsterSpawnRewardIds = {}
end

function ServerDungeonBase:OnNotifyServerDungeonEvent_OnInit()
  print("ServerDungeonBase:OnNotifyServerDungeonEvent_OnInit")
  self:ServerInitAutoActiveStaticCreator()
  self:ServerInitAutoActiveRandomCreator()
end

function ServerDungeonBase:OnNotifyServerDungeonEvent_SetGameModeLevel(GameModeLevel)
  print("OnNotifyServerDungeonEvent_SetGameModeLevel", GameModeLevel)
end

function ServerDungeonBase:DungeonMonsterDead(MonsterInfo)
  print("ServerDungeonBase:DungeonMonsterDead", MonsterInfo)
end

function ServerDungeonBase:OnNotifyServerDungeonEvent_AddMonsterSpawnDropRule(MonsterSpawnId)
  self:AddMonsterSpawnDropRule(MonsterSpawnId)
end

function ServerDungeonBase:OnNotifyServerDungeonEvent_AddMonsterSpawnDropRuleByArray(MonsterSpawnIds)
  self:AddMonsterSpawnDropRuleByArray(MonsterSpawnIds)
end

function ServerDungeonBase:OnNotifyServerDungeonEvent_DeleteMonsterSpawnDropRule(MonsterSpawnId)
  self:DeleteMonsterSpawnDropRule(MonsterSpawnId)
end

function ServerDungeonBase:OnNotifyServerDungeonEvent_DeleteMonsterSpawnDropRuleByArray(MonsterSpawnIds)
  self:DeleteMonsterSpawnDropRuleByArray(MonsterSpawnIds)
end

function ServerDungeonBase:DungeonRewardEvent(Info)
  print("ServerDungeonBase:DungeonRewardEvent")
  if not Info or not Info.UnitId then
    print("ServerDungeonBase:DungeonRewardEvent Error: Invalid Info parameter in DungeonRewardEvent")
    return
  end
  if 2 ~= Info.DeathReason then
    print("ServerDungeonBase:DungeonRewardEvent Error: Monster", Info.UnitId, Info.UniqueId, "DeathReason is not Damage is", Info.DeathReason, "return.")
    return
  end
  if Info.IsFallTrigger == true then
    print("ServerDungeonBase:DungeonRewardEvent Error: Monster", Info.UnitId, Info.UniqueId, "IsFallTrigger=true return.")
    return
  end
  if true == Info.bCreateByUnitButNoSummon then
    print("ServerDungeonBase:DungeonRewardEvent Error: Monster", Info.UnitId, Info.UniqueId, "bCreateByUnitButNoSummon=true return.")
    return
  end
  Info.ExtraInfo = Info.ExtraInfo or {}
  self:FillMonsterSpawnRewardIds(Info.ExtraInfo, Info.UnitId)
  
  local function ServerDungeonCallback(FilterRewards, OtherParams)
    local Drops = FilterRewards.Drops
    local Exps = FilterRewards.Exps
    if Exps then
      self:NotifyGameModeDungeonEvent("ResolveExp", Exps, OtherParams)
    end
    print("ServerDungeonBase:DungeonRewardEvent:ServerDungeonCallback", Drops)
    if not Drops or CommonUtils.IsEmpty(Drops) then
      return
    end
    local DropRes = {
      Reason = Info.Reason,
      Transform = Info.Transform,
      ExtraInfo = Info.ExtraInfo,
      DropInfos = {}
    }
    for Id, DropCountTable in pairs(Drops) do
      local DropId = tonumber(Id)
      local DropInfo = {
        DropId = DropId,
        DropCountTable = DropCountTable,
        UniqueIds = {}
      }
      local ExtraCount = RewardBox:FindCountByTag(DropCountTable, "Extra") or 0
      local OtherCount = RewardBox:FindCountByTag(DropCountTable, "Normal") or 0
      local TotalCount = ExtraCount + OtherCount
      for i = 1, TotalCount do
        local _DropInfo = self:CreateDrop(DropId)
        table.insert(DropInfo.UniqueIds, _DropInfo.UniqueId)
      end
      table.insert(DropRes.DropInfos, DropInfo)
    end
    print("ServerDungeonBase:DungeonRewardEvent:ServerDungeonCallback", DropRes)
    self:NotifyGameModeCreatDrop(DropRes, OtherParams)
  end
  
  self:TriggerRewardEvent(Info.UnitId, Info.Reason, Info.ExtraInfo, ServerDungeonCallback)
end

function ServerDungeonBase:AddMonsterSpawnDropRule(MonsterSpawnId)
  local MonsterSpawnData = DataMgr.MonsterSpawn[MonsterSpawnId]
  if not MonsterSpawnData then
    print("ServerDungeonBase:AddMonsterSpawnDropRule MonsterSpawnId is not exist in Data", MonsterSpawnId)
    return
  end
  for _, SpawnInfo in pairs(MonsterSpawnData.MonsterSpawnInfos or {}) do
    local UnitId = SpawnInfo.UnitId
    if UnitId then
      local MonsterSpawnIds = self.ActiveMonsterSpawnRewardIds[UnitId]
      if not MonsterSpawnIds then
        MonsterSpawnIds = {}
        self.ActiveMonsterSpawnRewardIds[UnitId] = MonsterSpawnIds
      end
      if MonsterSpawnIds[MonsterSpawnId] then
        print("ServerDungeonBase:AddMonsterSpawnDropRule duplicated", UnitId, MonsterSpawnId)
      else
        MonsterSpawnIds[MonsterSpawnId] = true
      end
    end
  end
end

function ServerDungeonBase:AddMonsterSpawnDropRuleByArray(MonsterSpawnIds)
  for _, MonsterSpawnId in pairs(MonsterSpawnIds or {}) do
    self:AddMonsterSpawnDropRule(MonsterSpawnId)
  end
end

function ServerDungeonBase:DeleteMonsterSpawnDropRule(MonsterSpawnId)
  local MonsterSpawnData = DataMgr.MonsterSpawn[MonsterSpawnId]
  if not MonsterSpawnData then
    print("ServerDungeonBase:DeleteMonsterSpawnDropRule MonsterSpawnId is not exist in Data", MonsterSpawnId)
    return
  end
  for _, SpawnInfo in pairs(MonsterSpawnData.MonsterSpawnInfos or {}) do
    local UnitId = SpawnInfo.UnitId
    local MonsterSpawnIds = UnitId and self.ActiveMonsterSpawnRewardIds[UnitId]
    if not MonsterSpawnIds or not MonsterSpawnIds[MonsterSpawnId] then
      print("ServerDungeonBase:DeleteMonsterSpawnDropRule MonsterSpawnId is inactive", MonsterSpawnId)
    else
      MonsterSpawnIds[MonsterSpawnId] = nil
      if not next(MonsterSpawnIds) then
        self.ActiveMonsterSpawnRewardIds[UnitId] = nil
      end
    end
  end
end

function ServerDungeonBase:DeleteMonsterSpawnDropRuleByArray(MonsterSpawnIds)
  for _, MonsterSpawnId in pairs(MonsterSpawnIds or {}) do
    self:DeleteMonsterSpawnDropRule(MonsterSpawnId)
  end
end

function ServerDungeonBase:GetMonsterSpawnRewardId(UnitId, RewardIds)
  RewardIds = RewardIds or {}
  for i = #RewardIds, 1, -1 do
    RewardIds[i] = nil
  end
  local MonsterSpawnIds = self.ActiveMonsterSpawnRewardIds[UnitId]
  if not MonsterSpawnIds then
    return RewardIds
  end
  for MonsterSpawnId in pairs(MonsterSpawnIds) do
    local MonsterSpawnData = DataMgr.MonsterSpawn[MonsterSpawnId]
    if MonsterSpawnData and nil ~= MonsterSpawnData.RewardId then
      RewardIds[#RewardIds + 1] = MonsterSpawnData.RewardId
    end
  end
  return RewardIds
end

function ServerDungeonBase:FillMonsterSpawnRewardIds(ExtraInfo, MonsterId)
  local RewardIds = self:GetMonsterSpawnRewardId(MonsterId, rawget(ExtraInfo, "MonsterSpawnRewardIds"))
  if #RewardIds > 0 then
    ExtraInfo.MonsterSpawnRewardIds = RewardIds
  else
    ExtraInfo.MonsterSpawnRewardIds = nil
  end
end

DungeonClass.AssembleComponents(ServerDungeonBase)
return ServerDungeonBase
