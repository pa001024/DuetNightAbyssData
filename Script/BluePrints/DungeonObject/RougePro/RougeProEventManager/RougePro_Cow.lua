local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougePro_Cow_Implement = DungeonClass.Class()

function RougePro_Cow_Implement:RougePro_Cow_Create(EventId)
  local RougeProEvent = self:GetRougeProEvent(EventId)
  assert(RougeProEvent)
  assert(RougeProEvent.CowEventInfo)
  assert(RougeProEvent.CowEventInfo.EffectId)
  local tabRougeProEventArea = self:GetEventAreaConfig(EventId)
  assert(tabRougeProEventArea)
  assert(tabRougeProEventArea.CowStaticPoint)
  local FinalStaticPoint = self:EffectGlobalCacheCallFunc(RougeProEvent.CowEventInfo.EffectId, function(EffectCache)
    EffectCache.UsedStaticPointList = EffectCache.UsedStaticPointList or {}
    local RandomList = {}
    for i = 1, #tabRougeProEventArea.CowStaticPoint do
      if CommonUtils.HasValue(EffectCache.UsedStaticPointList, tabRougeProEventArea.CowStaticPoint[i]) == false then
        table.insert(RandomList, tabRougeProEventArea.CowStaticPoint[i])
      end
    end
    local RandomIndex = math.random(1, #RandomList)
    local staticpoint = RandomList[RandomIndex]
    table.insert(EffectCache.UsedStaticPointList, staticpoint)
    return staticpoint
  end)
  local SceneObjAttr = RougeProSceneObjAttr()
  SceneObjAttr:SetEventId(EventId)
  SceneObjAttr:SetIsCowMechanism(true)
  self:SceneObjManagerStaticCreatorActive({FinalStaticPoint}, SceneObjAttr)
end

function RougePro_Cow_Implement:RougePro_Cow_Destroy(EventId)
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    return
  end
  local EffectId = RougeProEvent.CowEventInfo.EffectId
  local tabRougePro_EffectId = DataMgr.RougeProEffect[EffectId]
  if tabRougePro_EffectId and tabRougePro_EffectId.Param and tabRougePro_EffectId.Param.MonsterSpId then
    self:StopRougeMonsterSp_RoundSpawn(tabRougePro_EffectId.Param.MonsterSpId)
  end
  return self:DestroyRougeProEvent(EventId)
end

function RougePro_Cow_Implement:RougePro_EventMechanismStateChange(EventInfo)
  local AvatarEid = EventInfo.PlayerEid
  local MechanismUniqudId = EventInfo.UniqueId
  print(string.format("RougePro_ActiveCowMechanismEvent EventInfo=%s", tostring(EventInfo)))
  local SceneObjAttr = self:GetMechanismSceneObjAttr(MechanismUniqudId)
  if nil == SceneObjAttr then
    return
  end
  local Player = self:GetPlayer(AvatarEid)
  if nil == Player then
    print("OnNotifyServerDungeonEvent_ActiveCowMechanism Error. Player == nil")
    return
  end
  if Player.ActiviteCowMechanismFlag then
    print("OnNotifyServerDungeonEvent_ActiveCowMechanism Error. Player.ActiviteCowMechanismFlag == true")
    return
  end
  local EventId = SceneObjAttr:GetEventId()
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    print(string.format("RougePro_Cow_Implement:RougePro_Cow_Create(%s) error RougeProEvent == nil", tostring(EventId)))
    return
  end
  if nil == RougeProEvent.CowEventInfo then
    print(string.format("RougePro_Cow_Implement:RougePro_Cow_Create(%s) error RougeProEvent.CowEventInfo == nil", tostring(EventId)))
    return
  end
  Player.ActiviteCowMechanismFlag = true
  local EffectId = RougeProEvent.CowEventInfo.EffectId
  local tabRougeProEffect = DataMgr.RougeProEffect[EffectId]
  assert(tabRougeProEffect)
  if tabRougeProEffect.Param and tabRougeProEffect.Param.MonsterSpId then
    self:TriggerRougeProMonsterSpecialSpawn(tabRougeProEffect.Param.MonsterSpId)
  end
  local SeasonInfo = DataMgr.RougeProSeason[self.SeasonId]
  RougeProEvent:RegisterTimer("RougeProEventTimerOver", SeasonInfo.CowEventTime, function()
    if tabRougeProEffect.Param and tabRougeProEffect.Param.MonsterSpId then
      self:StopRougeProMonsterSpecialSpawn(tabRougeProEffect.Param.MonsterSpId)
    end
    self:FinishRougeProEvent(EventId, false)
  end)
  self:NotifyGameModeMechanismState(EventInfo)
end

return RougePro_Cow_Implement
