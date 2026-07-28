local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougePro_Occupation_Implement = DungeonClass.Class()

function RougePro_Occupation_Implement:RougePro_Occupation_Create(EventId)
  local StaticCreatorList = self:GetEventAreaMechanismStaticPoint(EventId)
  print("RougePro_Occupation_Create StaticCreatorList = " .. CommonUtils.TableToString3(StaticCreatorList))
  if StaticCreatorList then
    local SceneObjAttr = RougeProSceneObjAttr()
    SceneObjAttr:SetEventId(EventId)
    self:SceneObjManagerStaticCreatorActive(StaticCreatorList, SceneObjAttr)
  end
  return self:RougeProEventAreaCreateTriggerBox(EventId)
end

function RougePro_Occupation_Implement:RougePro_Occupation_Active(EventId)
  self:RougeProEventActiveMonsterSpawn(EventId)
end

function RougePro_Occupation_Implement:RougePro_Occupation_Suspend(EventId)
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    return
  end
  print(string.format("RougePro_Occupation_Implement:RougePro_Occupation_Suspend(%d)", EventId))
  RougeProEvent:UnRegisterTimer("OccupationProccessTimer_" .. EventId)
  self:RougeProEventPauseMonsterSpawn(EventId)
end

function RougePro_Occupation_Implement:RougePro_Occupation_Complete(EventId)
  print(string.format("RougePro_Occupation_Implement:RougePro_Occupation_Complete(%d)", EventId))
  self:OnRougeProEventComplete(EventId)
end

function RougePro_Occupation_Implement:RougePro_Occupation_Destroy(EventId)
  print(string.format("RougePro_Occupation_Implement:RougePro_Occupation_Destroy(%d)", EventId))
  self:DestroyRougeProEvent(EventId)
end

function RougePro_Occupation_Implement:OnNotifyServerDungeonEvent_AddOccupationValue(UniqueId, AddValue)
  local Attr = self:GetMechanismSceneObjAttr(UniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsOccupationEvent(EventId) == false then
    return
  end
  print(string.format("RougePro_Occupation_Implement:OnNotifyServerDungeonEvent_AddOccupationValue(EventId=%d, AddValue=%d)", EventId, AddValue))
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    return
  end
  local tabRougePro_Occupation = self:GetEventConfigData(EventId)
  if nil == tabRougePro_Occupation then
    return
  end
  if RougeProEvent:AddOccupation(AddValue) >= 100 then
    self:FinishRougeProEvent(EventId, true)
  end
end

return RougePro_Occupation_Implement
