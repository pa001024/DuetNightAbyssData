local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougePro_Exterminate_Implement = DungeonClass.Class()

function RougePro_Exterminate_Implement:RougePro_Exterminate_Create(EventId)
  local StaticCreatorList = self:GetEventAreaMechanismStaticPoint(EventId)
  if StaticCreatorList then
    local SceneObjAttr = RougeProSceneObjAttr()
    SceneObjAttr:SetEventId(EventId)
    self:SceneObjManagerStaticCreatorActive(StaticCreatorList, SceneObjAttr)
  end
  return self:RougeProEventAreaCreateTriggerBox(EventId)
end

function RougePro_Exterminate_Implement:RougePro_Exterminate_Active(EventId)
  self:RougeProEventActiveMonsterSpawn(EventId)
end

function RougePro_Exterminate_Implement:RougePro_Exterminate_Suspend(EventId)
  print(string.format("RougePro_Exterminate_Implement:RougePro_Exterminate_Suspend(%d)", EventId))
  self:RougeProEventPauseMonsterSpawn(EventId)
end

function RougePro_Exterminate_Implement:RougePro_Exterminate_Complete(EventId)
  print(string.format("RougePro_Exterminate_Implement:RougePro_Exterminate_Complete(%d)", EventId))
  self:OnRougeProEventComplete(EventId)
end

function RougePro_Exterminate_Implement:RougePro_Exterminate_Destroy(EventId)
  print(string.format("RougePro_Exterminate_Implement:RougePro_Exterminate_Destroy(%d)", EventId))
  self:DestroyRougeProEvent(EventId)
end

function RougePro_Exterminate_Implement:RougePro_DungeonMonsterDead(MonsterInfo)
  local Attr = self:GetMonsterSceneObjAttr(MonsterInfo.UniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsExterminateEvent(EventId) == false then
    return
  end
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    return
  end
  local tabSubEventConfig = self:GetEventConfigData(EventId)
  if nil == tabSubEventConfig then
    return
  end
  if RougeProEvent:AddExterminate(1) >= tabSubEventConfig.CompleteNeedKillNum then
    self:FinishRougeProEvent(EventId, true)
  end
end

return RougePro_Exterminate_Implement
