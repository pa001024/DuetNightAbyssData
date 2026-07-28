local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougePro_SurvivalPro_Implement = DungeonClass.Class()

function RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Create(EventId)
  local StaticCreatorList = self:GetEventAreaMechanismStaticPoint(EventId)
  if StaticCreatorList then
    local SceneObjAttr = RougeProSceneObjAttr()
    SceneObjAttr:SetEventId(EventId)
    self:SceneObjManagerStaticCreatorActive(StaticCreatorList, SceneObjAttr)
  end
  return self:RougeProEventAreaCreateTriggerBox(EventId)
end

function RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Active(EventId)
  print(string.format("RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Active(%d)", EventId))
  self:RougeProEventActiveMonsterSpawn(EventId)
end

function RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Suspend(EventId)
  print(string.format("RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Suspend(%d)", EventId))
  self:RougeProEventPauseMonsterSpawn(EventId)
end

function RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Complete(EventId)
  print(string.format("RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Complete(%d)", EventId))
  self:OnRougeProEventComplete(EventId)
end

function RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Destroy(EventId)
  print(string.format("RougePro_SurvivalPro_Implement:RougePro_SurvivalPro_Destroy(%d)", EventId))
  self:DestroyRougeProEvent(EventId)
end

function RougePro_SurvivalPro_Implement:OnNotifyServerDungeonEvent_AddServerSurvivalValue(MonsterUniqueId, AddValue)
  print("ljl@ AddServerSurvivalValue", MonsterUniqueId, AddValue)
  local Attr = self:GetMonsterSceneObjAttr(MonsterUniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsSurvivalProEvent(EventId) == false then
    return
  end
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    return
  end
  if RougeProEvent:AddSurvivalPro(AddValue) >= 100 then
    self:FinishRougeProEvent(EventId, true)
  end
end

return RougePro_SurvivalPro_Implement
