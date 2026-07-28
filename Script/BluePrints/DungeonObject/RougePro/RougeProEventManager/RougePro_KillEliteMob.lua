local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougePro_KillEliteMob_Implement = DungeonClass.Class()

function RougePro_KillEliteMob_Implement:RougePro_KillEliteMob_Create(EventId)
  local tabRougePro_KillEliteMob = self:GetEventConfigData(EventId)
  local StaticCreatorList = self:GetEventAreaMechanismStaticPoint(EventId)
  if StaticCreatorList then
    for i = 1, #StaticCreatorList do
      local SceneObjAttr = RougeProSceneObjAttr()
      SceneObjAttr:SetEventId(EventId)
      self:SceneObjManagerStaticCreatorActive({
        StaticCreatorList[i]
      }, SceneObjAttr, tabRougePro_KillEliteMob and tabRougePro_KillEliteMob.EliteId[i])
    end
  end
  return self:RougeProEventAreaCreateTriggerBox(EventId)
end

function RougePro_KillEliteMob_Implement:RougePro_KillEliteMob_Active(EventId)
end

function RougePro_KillEliteMob_Implement:RougePro_KillEliteMob_Suspend(EventId)
end

function RougePro_KillEliteMob_Implement:RougePro_KillEliteMob_Complete(EventId)
  return self:OnRougeProEventComplete(EventId)
end

function RougePro_KillEliteMob_Implement:RougePro_KillEliteMob_Destroy(EventId)
  return self:DestroyRougeProEvent(EventId)
end

function RougePro_KillEliteMob_Implement:RougePro_DungeonMonsterDead(MonsterInfo)
  local Attr = self:GetMonsterSceneObjAttr(MonsterInfo.UniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsKillEliteMobEvent(EventId) == false then
    return
  end
  local IsExistMonsterAlive = self:IsExistMonster(function(SceneObjAttr)
    if SceneObjAttr:GetEventId() == EventId and SceneObjAttr:IsAlive() == true then
      return true
    end
  end)
  if IsExistMonsterAlive then
    return
  end
  self:FinishRougeProEvent(EventId, true)
end

return RougePro_KillEliteMob_Implement
