local MechanismInfo = require("BluePrints.DungeonObject.DungeonComponent.MechanismInfo")
local MechanismDungeonLogic = DungeonClass.Class()
MechanismDungeonLogic.__Component__ = {}

function MechanismDungeonLogic:BeginPlay()
  self.MechanismMap = {}
end

function MechanismDungeonLogic:EndPlay()
  self.MechanismMap = {}
end

function MechanismDungeonLogic:CreateMechanism(UnitId, ExtraParams)
  local _MechanismInfo = MechanismInfo()
  _MechanismInfo.UnitId = UnitId
  _MechanismInfo.UniqueId = self:GenUniqueId()
  if ExtraParams and ExtraParams.bDropMechanism then
    _MechanismInfo.bDropMechanism = true
  end
  self.MechanismMap[_MechanismInfo.UniqueId] = _MechanismInfo
  if self.OnCreateMechanism then
    self:OnCreateMechanism(_MechanismInfo.UniqueId)
  end
  return _MechanismInfo
end

function MechanismDungeonLogic:DestroyMechanism(UniqueId)
  self.MechanismMap[UniqueId] = nil
end

function MechanismDungeonLogic:GetMechanism(UniqueId)
  return self.MechanismMap[UniqueId]
end

function MechanismDungeonLogic:OnNotifyServerDungeonEvent_MechanismStateChange(EventInfo)
  print("LXZ DungeonLogic OnNotifyServerDungeonEvent_MechanismStateChange")
  local _MechanismInfo = self:GetMechanism(EventInfo.UniqueId)
  self:NotifyGameModeDungeonEvent("MechanismStateChange", EventInfo)
end

function MechanismDungeonLogic:NotifyGameModeMechanismState(EventInfo)
  print("LXZ DungeonLogic NotifyGameModeMechanismState")
  self:NotifyGameModeDungeonEvent("MechanismStateChange", EventInfo)
end

function MechanismDungeonLogic:OnNotifyServerDungeonEvent_MechanismGiveReward(EventInfo)
  self:DungeonRewardEvent(EventInfo)
  self:NotifyGameModeDungeonEvent("MechanismGiveReward", EventInfo)
end

DungeonClass.AssembleComponents(MechanismDungeonLogic)
return MechanismDungeonLogic
