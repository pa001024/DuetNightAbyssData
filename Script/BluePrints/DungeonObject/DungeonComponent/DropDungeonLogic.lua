local DropInfo = require("BluePrints.DungeonObject.DungeonComponent.DropInfo")
local DropDungeonLogic = DungeonClass.Class()
DropDungeonLogic.__Component__ = {}

function DropDungeonLogic:BeginPlay()
  self.DropMap = {}
end

function DropDungeonLogic:EndPlay()
  self.DropMap = {}
end

function DropDungeonLogic:CreateDrop(UnitId)
  local _DropInfo = DropInfo()
  _DropInfo.UnitId = UnitId
  _DropInfo.UniqueId = self:GenUniqueId()
  self.DropMap[_DropInfo.UniqueId] = _DropInfo
  return _DropInfo
end

function DropDungeonLogic:DestroyDrop(UniqueId)
  self.DropMap[UniqueId] = nil
end

function DropDungeonLogic:GetDrop(UniqueId)
  return self.DropMap[UniqueId]
end

function DropDungeonLogic:NotifyGameModeCreatDrop(DropRes)
  self:NotifyGameModeDungeonEvent("CreatDrop", DropRes)
end

function DropDungeonLogic:OnNotifyServerDungeonEvent_TriggerPickupRewardEvent(UnitId, RewardReason, ExtraInfo)
  if ExtraInfo.UniqueId and self.DropMap[ExtraInfo.UniqueId] and self.DropMap[ExtraInfo.UniqueId].UnitId == UnitId then
    self:TriggerRewardEvent(UnitId, RewardReason, ExtraInfo, function()
    end)
    self.DropMap[ExtraInfo.UniqueId] = nil
  else
    print("TriggerPickupRewardEvent Failure", UnitId, RewardReason, ExtraInfo.UniqueId)
  end
end

function DropDungeonLogic:OnNotifyServerDungeonEvent_TriggerPickupAddSurvivalValueEvent(UnitId, UniqueId)
  print("OnNotifyServerDungeonEvent_TriggerPickupAddSurvivalValueEvent", UnitId, UniqueId, self.DropMap[UniqueId])
  if self.DropMap[UniqueId] then
    print(self.DropMap[UniqueId].UnitId)
  end
  if self.DropMap[UniqueId] and self.DropMap[UniqueId].UnitId == UnitId then
    if DataMgr.Drop[UnitId] then
      self:ServerUpdateSurvivalMiniValue(DataMgr.Drop[UnitId].UseParam)
    end
    self.DropMap[UniqueId] = nil
  else
    print("TriggerPickupAddSurvivalValueEvent Failure", UnitId, UniqueId)
  end
end

DungeonClass.AssembleComponents(DropDungeonLogic)
return DropDungeonLogic
