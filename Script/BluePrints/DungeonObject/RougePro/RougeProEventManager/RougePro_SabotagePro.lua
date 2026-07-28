local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougePro_SabotagePro_Implement = DungeonClass.Class()

function RougePro_SabotagePro_Implement:RougePro_SabotagePro_Create(EventId)
  local StaticCreatorList = self:GetEventAreaMechanismStaticPoint(EventId)
  if StaticCreatorList then
    local SceneObjAttr = RougeProSceneObjAttr()
    SceneObjAttr:SetEventId(EventId)
    self:SceneObjManagerStaticCreatorActive(StaticCreatorList, SceneObjAttr)
  end
  return self:RougeProEventAreaCreateTriggerBox(EventId)
end

function RougePro_SabotagePro_Implement:RougePro_SabotagePro_Active(EventId)
end

function RougePro_SabotagePro_Implement:RougePro_SabotagePro_Suspend(EventId)
  return self:RougeProEventPauseMonsterSpawn(EventId)
end

function RougePro_SabotagePro_Implement:RougePro_SabotagePro_Complete(EventId)
  return self:OnRougeProEventComplete(EventId)
end

function RougePro_SabotagePro_Implement:RougePro_SabotagePro_Destroy(EventId)
  return self:DestroyRougeProEvent(EventId)
end

function RougePro_SabotagePro_Implement:SabotagePro_MechanismStateChange_MiniGame(EventInfo)
  print("SabotagePro_MechanismStateChange_MiniGame")
  local MechanismUniqueId = EventInfo.UniqueId
  local Attr = self:GetMechanismSceneObjAttr(MechanismUniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsSabotageProEvent(EventId) == false then
    return
  end
  local Mechanism = self:GetMechanism(MechanismUniqueId)
  if nil == Mechanism then
    return
  end
  local tabMechanismData = DataMgr.Mechanism[Mechanism.UnitId]
  if nil == tabMechanismData then
    return
  end
  if tabMechanismData.UnitRealType ~= "MiniGame" then
    return
  end
  if EventInfo.Type ~= "InteractDone" then
    return
  end
  self:NotifyGameModeMechanismState(EventInfo)
  print(string.format("RougePro_SabotagePro_Implement:MechanismStateChange() EventId=%s MechanismEventInfo=%s", tostring(EventId), CommonUtils.TableToString3(EventInfo)))
  print(string.format("RougePro_SabotagePro_Implement self.MechanismSceneObjAttrList = %s", CommonUtils.TableToString3(self.MechanismSceneObjAttrList)))
  for uid, SceneObjAttr in pairs(self.MechanismSceneObjAttrList or {}) do
    if SceneObjAttr:GetEventId() == EventId then
      local EventMechanism = self:GetMechanism(uid)
      if EventMechanism then
        local EventMechanismData = DataMgr.Mechanism[EventMechanism.UnitId]
        if EventMechanismData and EventMechanismData.UnitRealType ~= "MiniGame" then
          local NotifyInfo = {}
          NotifyInfo.UniqueId = uid
          NotifyInfo.Type = "Manual"
          NotifyInfo.PlayerId = EventInfo.PlayerId
          NotifyInfo.StateId = 493012
          self:NotifyGameModeMechanismState(NotifyInfo)
        end
      end
    end
  end
  local tabRougeProEventSubData = self:GetEventConfigData(EventId)
  if tabRougeProEventSubData then
    local MonsterObjAttr = RougeProSceneObjAttr()
    MonsterObjAttr:SetEventId(EventId)
    self:SceneObjManagerSpawnMonsterTrigger(tabRougeProEventSubData.SpawnMonsterId, MonsterObjAttr, false)
  end
end

function RougePro_SabotagePro_Implement:RougePro_MechanismDead(MechanismUniqueId)
  local Attr = self:GetMechanismSceneObjAttr(MechanismUniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsSabotageProEvent(EventId) == false then
    return
  end
  print(string.format("RougePro_SabotagePro_Implement:RougePro_MechanismDead(%s) MechanismUniqueId(%s)", tostring(EventId), tostring(MechanismUniqueId)))
  local IsExistMechanism = self:IsExistMechanism(function(SceneObjAttr, UniqueId)
    if SceneObjAttr:GetEventId() == EventId and SceneObjAttr:IsAlive() == true then
      local mechanism = self:GetMechanism(UniqueId)
      if mechanism and DataMgr.Mechanism[mechanism.UnitId] and DataMgr.Mechanism[mechanism.UnitId].UnitRealType ~= "MiniGame" then
        return true
      end
    end
  end)
  if IsExistMechanism then
    print(string.format("SabotagePro_MechanismStateChange_SabotagePro return. SomeMechanism IsAlive=true"))
    return
  end
  print(string.format("RougePro_SabotagePro_Implement:RougePro_MechanismDead All Mechanism Dead. Complete RougeProEvent (%s)", tostring(EventId)))
  self:FinishRougeProEvent(EventId, true)
end

function RougePro_SabotagePro_Implement:RougePro_EventMechanismStateChange(EventInfo)
  print("RougePro_EventMechanismStateChange")
  local Attr = self:GetMechanismSceneObjAttr(EventInfo.UniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsSabotageProEvent(EventId) == false then
    return
  end
  self:SabotagePro_MechanismStateChange_MiniGame(EventInfo)
end

return RougePro_SabotagePro_Implement
