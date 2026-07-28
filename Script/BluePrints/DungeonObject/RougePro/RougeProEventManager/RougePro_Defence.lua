local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougePro_Defence_Implement = DungeonClass.Class()

function RougePro_Defence_Implement:RougePro_Defence_Create(EventId)
  local StaticCreatorList = self:GetEventAreaMechanismStaticPoint(EventId)
  print("RougePro_Defence_Create StaticCreatorList = " .. CommonUtils.TableToString3(StaticCreatorList))
  if StaticCreatorList then
    local SceneObjAttr = RougeProSceneObjAttr()
    SceneObjAttr:SetEventId(EventId)
    self:SceneObjManagerStaticCreatorActive(StaticCreatorList, SceneObjAttr)
  end
  return self:RougeProEventAreaCreateTriggerBox(EventId)
end

function RougePro_Defence_Implement:RougePro_Defence_Active(EventId)
  print(string.format("RougePro_Defence_Implement:RougePro_Defence_Active(%d)", EventId))
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    return
  end
  if RougeProEvent.HadActive == false then
    local MechanismList = {}
    for uid, SceneObjAttr in pairs(self.MechanismSceneObjAttrList or {}) do
      if SceneObjAttr:GetEventId() == EventId and SceneObjAttr:IsAlive() == true then
        local EventInfo = {}
        EventInfo.UniqueId = uid
        EventInfo.Type = "Manual"
        EventInfo.PlayerId = EventInfo.PlayerId
        EventInfo.StateId = 390011
        self:NotifyGameModeMechanismState(EventInfo)
      end
    end
    RougeProEvent:InitDefence()
    self:RougePro_Defence_Implement_ResetRound(EventId, 1)
  else
    local tabRougePro_Defence = self:GetEventConfigData(EventId)
    if tabRougePro_Defence then
      local MonsterObjAttr = RougeProSceneObjAttr()
      MonsterObjAttr:SetEventId(EventId)
      MonsterObjAttr:SetDefenceRound(RougeProEvent.DefenceRound)
      self:SceneObjManagerSpawnMonsterTrigger(tabRougePro_Defence.SpawnMonsterId, MonsterObjAttr, true)
    end
  end
end

function RougePro_Defence_Implement:RougePro_Defence_Suspend(EventId)
  print(string.format("RougePro_Defence_Implement:RougePro_Defence_Suspend(%d)", EventId))
  return self:RougeProEventPauseMonsterSpawn(EventId)
end

function RougePro_Defence_Implement:RougePro_Defence_Complete(EventId)
  print(string.format("RougePro_Defence_Implement:RougePro_Defence_Complete(%d)", EventId))
  return self:OnRougeProEventComplete(EventId)
end

function RougePro_Defence_Implement:RougePro_Defence_Destroy(EventId)
  print(string.format("RougePro_Defence_Implement:RougePro_Defence_Destroy(%d)", EventId))
  return self:DestroyRougeProEvent(EventId)
end

function RougePro_Defence_Implement:RougePro_Defence_Implement_ResetRound(EventId, NewRound)
  print(string.format("RougePro_Defence_Implement:RougePro_Defence_Implement_ResetRound(%d) NewRound(%d)", EventId, NewRound))
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    return
  end
  RougeProEvent.DefenceRound = NewRound
  self:NotifyGameModeDungeonEvent("RougePro_Defence_Implement_ResetRound", EventId, RougeProEvent.DefenceRound)
  local tabRougePro_Defence = self:GetEventConfigData(EventId)
  if tabRougePro_Defence then
    local MonsterObjAttr = RougeProSceneObjAttr()
    MonsterObjAttr:SetEventId(EventId)
    MonsterObjAttr:SetDefenceRound(RougeProEvent.DefenceRound)
    self:SceneObjManagerSpawnMonsterTrigger(tabRougePro_Defence.SpawnMonsterId, MonsterObjAttr, false)
  end
end

function RougePro_Defence_Implement:RougePro_DungeonMonsterDead(MonsterInfo)
  local Attr = self:GetMonsterSceneObjAttr(MonsterInfo.UniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsDefenceEvent(EventId) == false then
    return
  end
  print(string.format("RougePro_Defence_Implement:RougePro_DungeonMonsterDead(%d) MonsterUniqueId(%s)", EventId, tostring(MonsterInfo.UniqueId)))
  local IsExistMonster = self:IsExistMonster(function(SceneObjAttr, Uid)
    if SceneObjAttr:GetEventId() == EventId and SceneObjAttr:IsAlive() == true then
      print(string.format("RougePro_Defence_Implement:RougePro_DungeonMonsterDead SceneObjAttr(%s) Alive=true", tostring(Uid)))
      return true
    end
  end)
  if IsExistMonster then
    return
  end
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    print(string.format("RougePro_Defence_Implement:RougePro_DungeonMonsterDead RougeProEvent == nil"))
    return
  end
  local tabRougePro_Defence = self:GetEventConfigData(EventId)
  if nil == tabRougePro_Defence or nil == tabRougePro_Defence.SpawnMonsterId or nil == tabRougePro_Defence.SpawnMonsterId[1] then
    print(string.format("RougePro_Defence_Implement:RougePro_DungeonMonsterDead tabRougePro_Defence == nil or tabRougePro_Defence.DefenceRound == nil "))
    return
  end
  local UnitSpawnTotalNum = DataMgr.MonsterSpawn[tabRougePro_Defence.SpawnMonsterId[1]] and DataMgr.MonsterSpawn[tabRougePro_Defence.SpawnMonsterId[1]].UnitSpawnTotalNum
  if nil == UnitSpawnTotalNum then
    print(string.format("RougePro_Defence_Implement:RougePro_DungeonMonsterDead UnitSpawnTotalNum == nil SpawnMonsterId=%s", tostring(tabRougePro_Defence.SpawnMonsterId[1])))
    return
  end
  local nTotalKillNum = RougeProEvent.KillMonsterNum
  if UnitSpawnTotalNum > nTotalKillNum then
    print(string.format("RougePro_Defence_Implement:RougePro_DungeonMonsterDead nTotalKillNum(%s) < UnitSpawnTotalNum(%s)", tostring(nTotalKillNum), tostring(UnitSpawnTotalNum)))
    return
  end
  self:NotifyGameModeDungeonEvent("RougePro_Defence_RoundFinish", EventId, RougeProEvent.DefenceRound)
  if RougeProEvent.DefenceRound < tabRougePro_Defence.DefenceRound then
    RougeProEvent:RegisterTimer("Defence_" .. EventId, 5, function()
      self:RougePro_Defence_Implement_ResetRound(EventId, RougeProEvent.DefenceRound + 1)
    end)
  else
    self:FinishRougeProEvent(EventId, true)
  end
end

function RougePro_Defence_Implement:RougePro_MechanismDead(MechanismUniqueId)
  print(string.format("RougePro_Defence_Implement:RougePro_MechanismDead MechanismUniqueId(%s)", tostring(MechanismUniqueId)))
  local Attr = self:GetMechanismSceneObjAttr(MechanismUniqueId)
  local EventId = Attr and Attr:GetEventId()
  if nil == EventId or self:IsDefenceEvent(EventId) == false then
    return
  end
  print(string.format("RougePro_Defence_Implement:RougePro_MechanismDead EventId(%d) MechanismUniqueId(%s)", tostring(EventId), tostring(MechanismUniqueId)))
  self:FinishRougeProEvent(EventId, false)
end

return RougePro_Defence_Implement
