local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local ServerDungeonBase = DungeonClass.Class()
ServerDungeonBase.__Component__ = {
  "BluePrints.DungeonObject.DungeonBase",
  "BluePrints.DungeonObject.Server.DungeonReplicatedProperty",
  "BluePrints.DungeonObject.Server.PlayerManager"
}

function ServerDungeonBase:OnNotifyServerDungeonEvent_OnInit()
  print("ServerDungeonBase:OnNotifyServerDungeonEvent_OnInit")
  self:ServerInitAutoActiveStaticCreator()
  self:ServerInitAutoActiveRandomCreator()
end

function ServerDungeonBase:DungeonMonsterDead(MonsterInfo)
  print("ServerDungeonBase:DungeonMonsterDead", MonsterInfo)
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
  
  local function ServerDungeonCallback(Drops, OtherParams)
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

DungeonClass.AssembleComponents(ServerDungeonBase)
return ServerDungeonBase
