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
    self:OnCreateMechanism(_MechanismInfo.UniqueId, ExtraParams)
  end
  return _MechanismInfo
end

function MechanismDungeonLogic:DestroyMechanism(UniqueId)
  self.MechanismMap[UniqueId] = nil
  if self.OnDestroyMechanism then
    self:OnDestroyMechanism(UniqueId)
  end
end

function MechanismDungeonLogic:GetMechanism(UniqueId)
  return self.MechanismMap[UniqueId]
end

function MechanismDungeonLogic:OnNotifyServerDungeonEvent_MechanismStateChange(EventInfo)
  print("LXZ DungeonLogic OnNotifyServerDungeonEvent_MechanismStateChange EventInfo = " .. CommonUtils.TableToString3(EventInfo))
  local _MechanismInfo = self:GetMechanism(EventInfo.UniqueId)
  if self.MechanismStateChange then
    self:MechanismStateChange(EventInfo)
    return
  end
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

function MechanismDungeonLogic:OnNotifyServerDungeonEvent_MechanismDead(EventInfo)
  print("zwk DungeonLogic OnNotifyServerDungeonEvent_MechanismDead")
  self:NotifyGameModeDungeonEvent("MechanismDead", EventInfo)
  if self.MechanismDead then
    self:MechanismDead(EventInfo)
  end
end

DungeonClass.AssembleComponents(MechanismDungeonLogic)
return MechanismDungeonLogic
