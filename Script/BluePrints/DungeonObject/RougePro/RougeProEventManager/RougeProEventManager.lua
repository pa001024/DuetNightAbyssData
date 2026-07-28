local RougeProEvent = require("BluePrints.DungeonObject.RougePro.RougeProEventManager.RougeProEvent")
local RougeProGlobalConst = require("BluePrints.DungeonObject.RougePro.RougeProGlobalConst")
local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougeProEventManager = DungeonClass.Class()
RougeProEventManager.__Component__ = {
  "BluePrints.DungeonObject.RougePro.RougeProEventManager.RougePro_SurvivalPro",
  "BluePrints.DungeonObject.RougePro.RougeProEventManager.RougePro_Exterminate",
  "BluePrints.DungeonObject.RougePro.RougeProEventManager.RougePro_Defence",
  "BluePrints.DungeonObject.RougePro.RougeProEventManager.RougePro_Occupation",
  "BluePrints.DungeonObject.RougePro.RougeProEventManager.RougePro_SabotagePro",
  "BluePrints.DungeonObject.RougePro.RougeProEventManager.RougePro_KillEliteMob",
  "BluePrints.DungeonObject.RougePro.RougeProEventManager.RougePro_Cow"
}

function RougeProEventManager:BeginPlay()
  self:InitReplicatedProperties(self, "EventList", {}, "OnRep_EventList")
  self.EventAreaUnlockTimerList = {}
end

function RougeProEventManager:OnRoundFinish()
  local AllEventList = {}
  for EventId, _ in pairs(self.EventList) do
    table.insert(AllEventList, EventId)
  end
  for i = 1, #AllEventList do
    self:ChangeEventState(AllEventList[i], RougeProGlobalConst.RougeProEventState.Destroy)
  end
  for _, Timer in pairs(self.EventAreaUnlockTimerList or {}) do
    self:RemoveTimer(Timer)
  end
  self.EventAreaUnlockTimerList = {}
end

function RougeProEventManager:OnChangeRound()
  self:TrySpawnEvent(self.CommonInfo.MaxEventNum)
end

function RougeProEventManager:FinishRougeProEvent(EventId, Result)
  if Result then
    self:ChangeEventState(EventId, RougeProGlobalConst.RougeProEventState.Complete)
  else
    self:ChangeEventState(EventId, RougeProGlobalConst.RougeProEventState.Destroy)
  end
end

function RougeProEventManager:GetRougeProEvent(EventId)
  return self.EventList[EventId]
end

function RougeProEventManager:TrySpawnEvent(EventNum)
  for i = 1, EventNum do
    if CommonUtils.Size(self.EventList) >= self.CommonInfo.MaxEventNum then
      break
    end
    local NewEventId = self:GenerateRandomRougeProEvent()
    print(string.format("RougeProSceneGamePlay TrySpawnEvent NewEventId = %s", tostring(NewEventId)))
    if -1 ~= NewEventId then
      self.EventList[NewEventId] = RougeProEvent(self, NewEventId)
      self:ChangeEventState(NewEventId, RougeProGlobalConst.RougeProEventState.Init)
    end
  end
end

function RougeProEventManager:TrySpawnCowEvent(CowEventInfo)
  local IgnoreRegionLock = true
  local NewEventId = self:GenerateRandomCowEvent(CowEventInfo)
  print(string.format("RougeProSceneGamePlay TrySpawnCowEvent NewEventId=%s CowEventInfo=%s", tostring(NewEventId), CommonUtils.TableToString3(CowEventInfo)))
  if -1 == NewEventId then
    return NewEventId
  end
  local tabRougeProEventArea = self:GetEventAreaConfig(NewEventId)
  assert(tabRougeProEventArea)
  self.EventList[NewEventId] = RougeProEvent(self, NewEventId)
  self.EventList[NewEventId].IsCowEvent = true
  self.EventList[NewEventId].CowEventInfo = CowEventInfo
  self:ChangeEventState(NewEventId, RougeProGlobalConst.RougeProEventState.Init)
  return NewEventId
end

function RougeProEventManager:ChangeEventState(EventId, State)
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if not RougeProEvent or RougeProEvent:IsEventState(State) == true then
    return
  end
  RougeProEvent:SetEventState(State)
  local EventSubType = self:GetEventSubType(EventId)
  if RougeProEvent.CowEventInfo then
    EventSubType = "RougePro_Cow"
  end
  local FuncName = RougeProGlobalConst.BuildRougeProEventFuncName(EventSubType, State)
  if self[FuncName] then
    self[FuncName](self, EventId)
  end
  self.EventList = self.EventList
  self:NotifyGameModeDungeonEvent("OnRougeProEventStateChange", EventId, State)
end

function RougeProEventManager:RougeProEventAreaCreateTriggerBox(EventId)
  print(string.format("RougeProEventAreaCreateTriggerBox EventId = %s", tostring(EventId)))
  local tabRougePro_EventArea = self:GetEventAreaConfig(EventId)
  if tabRougePro_EventArea and tabRougePro_EventArea.EnterTriggerBox then
    self:SceneObjManagerStaticCreatorActive({
      tabRougePro_EventArea.EnterTriggerBox
    }, nil)
  end
  if tabRougePro_EventArea and tabRougePro_EventArea.ExitTriggerBox then
    self:SceneObjManagerStaticCreatorActive({
      tabRougePro_EventArea.ExitTriggerBox
    }, nil)
  end
end

function RougeProEventManager:RougeProEventActiveMonsterSpawn(EventId)
  print(string.format("RougeProEventActiveMonsterSpawn EventId = %s", tostring(EventId)))
  local tabRougeProEventSubData = self:GetEventConfigData(EventId)
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if RougeProEvent and RougeProEvent.HadActive == false and tabRougeProEventSubData and tabRougeProEventSubData.SpawnMonsterId then
    local SceneObjAttr = RougeProSceneObjAttr()
    SceneObjAttr:SetEventId(EventId)
    self:SceneObjManagerSpawnMonsterTrigger(tabRougeProEventSubData.SpawnMonsterId, SceneObjAttr, false)
    print(string.format("OnRougeProEventActive_Default EventId=%d ServerTriggerCreateMonsterSpawn=%s", EventId, CommonUtils.TableToString3(tabRougeProEventSubData.StaticPointId)))
    RougeProEvent.HadActive = true
  elseif RougeProEvent and RougeProEvent.HadActive == true and tabRougeProEventSubData and tabRougeProEventSubData.SpawnMonsterId then
    local SceneObjAttr = RougeProSceneObjAttr()
    SceneObjAttr:SetEventId(EventId)
    self:SceneObjManagerSpawnMonsterTrigger(tabRougeProEventSubData.SpawnMonsterId, SceneObjAttr, true)
    print(string.format("OnRougeProEventActive_Default EventId=%d ServerTriggerResumeMonsterSpawn=%s", EventId, CommonUtils.TableToString3(tabRougeProEventSubData.StaticPointId)))
  end
end

function RougeProEventManager:RougeProEventPauseMonsterSpawn(EventId)
  local tabRougeProEventSubData = self:GetEventConfigData(EventId)
  if nil == tabRougeProEventSubData then
    return
  end
  if nil == tabRougeProEventSubData.SpawnMonsterId then
    return
  end
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if nil == RougeProEvent then
    return
  end
  self:SceneObjManagerSpawnMonsterPause(tabRougeProEventSubData.SpawnMonsterId, false)
  print(string.format("RougeProEventPauseMonsterSpawn EventId=%d ServerTriggerPauseMonsterSpawn=%s", EventId, CommonUtils.TableToString3(tabRougeProEventSubData.StaticPointId)))
end

function RougeProEventManager:OnRougeProEventComplete(EventId)
  print(string.format("OnRougeProEventComplete EventId = %s", tostring(EventId)))
  local tabRougePro_EventArea = self:GetEventAreaConfig(EventId)
  if nil == tabRougePro_EventArea then
    return
  end
  self:EventAreaLock(tabRougePro_EventArea.ID)
  local tabRougeProEventSubData = self:GetEventConfigData(EventId)
  if tabRougeProEventSubData and tabRougeProEventSubData.EventScore then
    self:AddTotalScore(tabRougeProEventSubData.EventScore)
  end
  if tabRougeProEventSubData and tabRougeProEventSubData.RewardDropBoxId and self:GetEventAreaRewardBoxStaticPoint(EventId) then
    for AvatarEid, Player in self:PlayerIterator() do
      local RewardInfo = {
        RewardDropBoxId = tabRougeProEventSubData.RewardDropBoxId,
        OwnerAvatarEids = {AvatarEid},
        EventId = EventId,
        DropIndex = -1,
        MechanismUnitId = -1
      }
      self:CreateRewardDropBox_StaticPoint(tabRougeProEventSubData.RewardDropBoxId, RewardInfo, self:GetEventAreaRewardBoxStaticPoint(EventId))
    end
  end
  self:DestroyRougeProEvent(EventId)
  self:TrySpawnEvent(1)
end

function RougeProEventManager:DestroyRougeProEvent(EventId)
  print(string.format("RougeProSceneGamePlay:DestroyRougeProEvent EventId = %s", tostring(EventId)))
  local tabRougeProEventArea = self:GetEventAreaConfig(EventId)
  if tabRougeProEventArea and tabRougeProEventArea.EnterTriggerBox then
    self:SceneObjManagerStaticCreatorDestroy({
      tabRougeProEventArea.EnterTriggerBox
    })
  end
  if tabRougeProEventArea and tabRougeProEventArea.ExitTriggerBox then
    self:SceneObjManagerStaticCreatorDestroy({
      tabRougeProEventArea.ExitTriggerBox
    })
  end
  local StaticCreatorList = self:GetEventAreaMechanismStaticPoint(EventId)
  if StaticCreatorList then
    self:SceneObjManagerStaticCreatorDestroy(StaticCreatorList)
  end
  local tabRougeProEventSubData = self:GetEventConfigData(EventId)
  if tabRougeProEventSubData and tabRougeProEventSubData.SpawnMonsterId and self:IsCowEvent(EventId) == false then
    self:SceneObjManagerSpawnMonsterPause(tabRougeProEventSubData.SpawnMonsterId, true)
  end
  self:SceneManagerDestroyObj(function(SceneObjAttr)
    return SceneObjAttr:GetEventId() == EventId
  end)
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if RougeProEvent then
    RougeProEvent:RougeProEventClose()
    self.EventList[EventId] = nil
  end
end

function RougeProEventManager:EventAreaLock(RegionId)
  print(string.format("RougeProEventManager LockRougeProEventArea AreaId=%s", tostring(RegionId)))
  self:EventAreaUnlock(RegionId)
  self.EventAreaUnlockTimerList[RegionId] = self:AddTimer(self.CommonInfo.RegionUnlockTime, function()
    self:EventAreaUnlock(RegionId)
    self:TrySpawnEvent(1)
  end)
end

function RougeProEventManager:EventAreaUnlock(RegionId)
  if self.EventAreaUnlockTimerList[RegionId] then
    self:RemoveTimer(self.EventAreaUnlockTimerList[RegionId])
    self.EventAreaUnlockTimerList[RegionId] = nil
  end
end

function RougeProEventManager:RougePro_DungeonMonsterDead(MonsterInfo)
  local SceneObjAttr = self:GetMonsterSceneObjAttr(MonsterInfo.UniqueId)
  if nil == SceneObjAttr then
    return
  end
  local EventId = SceneObjAttr:GetEventId()
  if nil == EventId then
    return
  end
  local RougeProEvent = self:GetRougeProEvent(EventId)
  if RougeProEvent then
    RougeProEvent.KillMonsterNum = RougeProEvent.KillMonsterNum + 1
  end
end

function RougeProEventManager:GetEventConfigData(EventId)
  local tabRougePro_Event = DataMgr.RougePro_Event[EventId]
  if nil == tabRougePro_Event then
    return
  end
  if nil == tabRougePro_Event.EventType or nil == tabRougePro_Event.EventSubId then
    return
  end
  return DataMgr[tabRougePro_Event.EventType][tabRougePro_Event.EventSubId]
end

function RougeProEventManager:GetEventSubType(EventId)
  return DataMgr.RougePro_Event[EventId] and DataMgr.RougePro_Event[EventId].EventType
end

function RougeProEventManager:IsSurvivalProEvent(EventId)
  return self:GetEventSubType(EventId) == "RougePro_SurvivalPro" and self:IsCowEvent(EventId) == false
end

function RougeProEventManager:IsExterminateEvent(EventId)
  return self:GetEventSubType(EventId) == "RougePro_Exterminate" and self:IsCowEvent(EventId) == false
end

function RougeProEventManager:IsDefenceEvent(EventId)
  return self:GetEventSubType(EventId) == "RougePro_Defence" and self:IsCowEvent(EventId) == false
end

function RougeProEventManager:IsOccupationEvent(EventId)
  return self:GetEventSubType(EventId) == "RougePro_Occupation" and self:IsCowEvent(EventId) == false
end

function RougeProEventManager:IsSabotageProEvent(EventId)
  return self:GetEventSubType(EventId) == "RougePro_SabotagePro" and self:IsCowEvent(EventId) == false
end

function RougeProEventManager:IsKillEliteMobEvent(EventId)
  return self:GetEventSubType(EventId) == "RougePro_KillEliteMob" and self:IsCowEvent(EventId) == false
end

function RougeProEventManager:IsCowEvent(EventId)
  local RougeProEvent = self:GetRougeProEvent(EventId)
  return RougeProEvent and RougeProEvent.IsCowEvent
end

function RougeProEventManager:GetEventAreaMechanismStaticPoint(EventId)
  local tabRougePro_EventArea = self:GetEventAreaConfig(EventId)
  if nil == tabRougePro_EventArea then
    print(string.format("RougeProEventManager GetEventAreaMechanismStaticPoint(EventId=%d) tabRougePro_EventArea==nil", EventId))
    return
  end
  if self:IsSurvivalProEvent(EventId) then
    return tabRougePro_EventArea.SurvivalProStaticPointId
  elseif self:IsExterminateEvent(EventId) then
    return tabRougePro_EventArea.ExterminateStaticPointId
  elseif self:IsDefenceEvent(EventId) then
    return tabRougePro_EventArea.DefenceStaticPointId
  elseif self:IsOccupationEvent(EventId) then
    return tabRougePro_EventArea.OccupationStaticPointId
  elseif self:IsSabotageProEvent(EventId) then
    return tabRougePro_EventArea.SabotageProStaticPointId
  elseif self:IsKillEliteMobEvent(EventId) then
    return tabRougePro_EventArea.KillEliteMobStaticPointId
  end
end

function RougeProEventManager:GetEventAreaRewardBoxStaticPoint(EventId)
  local tabRougePro_EventArea = self:GetEventAreaConfig(EventId)
  if nil == tabRougePro_EventArea then
    return
  end
  if self:IsSurvivalProEvent(EventId) then
    return tabRougePro_EventArea.SurvivalProRewardBoxStaticPoint
  elseif self:IsExterminateEvent(EventId) then
    return tabRougePro_EventArea.ExterminateRewardBoxStaticPoint
  elseif self:IsDefenceEvent(EventId) then
    return tabRougePro_EventArea.DefenceRewardBoxStaticPoint
  elseif self:IsOccupationEvent(EventId) then
    return tabRougePro_EventArea.OccupationRewardBoxStaticPoint
  elseif self:IsSabotageProEvent(EventId) then
    return tabRougePro_EventArea.SabotageProRewardBoxStaticPoint
  elseif self:IsKillEliteMobEvent(EventId) then
    return tabRougePro_EventArea.KillEliteMobRewardBoxStaticPoint
  end
end

function RougeProEventManager:GetEventAreaConfig(EventId)
  local tabRougeProEvent = DataMgr.RougePro_Event[EventId]
  if nil == tabRougeProEvent then
    return nil
  end
  local AreaId = tabRougeProEvent.Area
  if nil == AreaId then
    return nil
  end
  return DataMgr.RougePro_EventArea[AreaId]
end

function RougeProEventManager:GenerateRandomRougeProEvent()
  local NewEventId = -1
  
  local function CanSpawnOneEvent(tabRougePro_Event, RoomAreaList)
    local EventId = tabRougePro_Event.ID
    if CommonUtils.HasValue(RoomAreaList, tabRougePro_Event.Area) == false then
      return false
    end
    for _EventId, _ in pairs(self.EventList) do
      if DataMgr.RougePro_Event[_EventId] and DataMgr.RougePro_Event[_EventId].Area == tabRougePro_Event.Area then
        return false
      end
    end
    if self.EventAreaUnlockTimerList[tabRougePro_Event.Area] then
      return false
    end
    for _EventId, _ in pairs(self.EventList) do
      if DataMgr.RougePro_Event[_EventId] and DataMgr.RougePro_Event[_EventId].EventSubId == tabRougePro_Event.EventSubId then
        return false
      end
    end
    return true
  end
  
  local RoomId = self:GetRougeProRoomId()
  local RoomAreaList = DataMgr.RougePro_Room[RoomId] and DataMgr.RougePro_Room[RoomId].EventAreaList
  if nil == RoomAreaList or nil == next(RoomAreaList) then
    return NewEventId
  end
  local list = {}
  local TotalWeight = 0
  for EventId, tabRougePro_Event in pairs(DataMgr.RougePro_Event) do
    if CanSpawnOneEvent(tabRougePro_Event, RoomAreaList) then
      TotalWeight = TotalWeight + tabRougePro_Event.Weight
      list[EventId] = tabRougePro_Event.Weight
    end
  end
  if nil == next(list) or TotalWeight <= 0 then
    return NewEventId
  end
  local RandomWeight = math.random(TotalWeight)
  for EventId, Weight in pairs(list) do
    RandomWeight = RandomWeight - Weight
    if RandomWeight <= 0 then
      NewEventId = EventId
      break
    end
  end
  return NewEventId
end

function RougeProEventManager:GenerateRandomCowEvent(CowEventInfo)
  local NewEventId = -1
  
  local function CanSpawnOneEvent(tabRougePro_Event, RoomAreaList)
    local EventId = tabRougePro_Event.ID
    if CommonUtils.HasValue(RoomAreaList, tabRougePro_Event.Area) == false then
      return false
    end
    for _EventId, _ in pairs(self.EventList) do
      if DataMgr.RougePro_Event[_EventId] and DataMgr.RougePro_Event[_EventId].Area == tabRougePro_Event.Area then
        return false
      end
    end
    local tabEventArea = self:GetEventAreaConfig(EventId)
    if nil == tabEventArea or nil == tabEventArea.CowStaticPoint then
      return false
    end
    local HaveFreeStaticPoint = self:EffectGlobalCacheCallFunc(CowEventInfo.EffectId, function(EffectCache)
      EffectCache.UsedStaticPointList = EffectCache.UsedStaticPointList or {}
      for i = 1, #tabEventArea.CowStaticPoint do
        if CommonUtils.HasValue(EffectCache.UsedStaticPointList, tabEventArea.CowStaticPoint[i]) == false then
          return true
        end
      end
      return false
    end)
    return HaveFreeStaticPoint
  end
  
  local RoomId = self:GetRougeProRoomId()
  local RoomAreaList = DataMgr.RougePro_Room[RoomId] and DataMgr.RougePro_Room[RoomId].EventAreaList
  if nil == RoomAreaList or nil == next(RoomAreaList) then
    return NewEventId
  end
  local list = {}
  local TotalWeight = 0
  for EventId, tabRougePro_Event in pairs(DataMgr.RougePro_Event) do
    if CanSpawnOneEvent(tabRougePro_Event, RoomAreaList) then
      TotalWeight = TotalWeight + tabRougePro_Event.Weight
      list[EventId] = tabRougePro_Event.Weight
    end
  end
  if nil == next(list) or TotalWeight <= 0 then
    return NewEventId
  end
  local RandomWeight = math.random(TotalWeight)
  for EventId, Weight in pairs(list) do
    RandomWeight = RandomWeight - Weight
    if RandomWeight <= 0 then
      NewEventId = EventId
      break
    end
  end
  return NewEventId
end

function RougeProEventManager:OnNotifyServerDungeonEvent_EnterTriggerBox(TriggerBoxId)
  print("RougeProEventManager OnNotifyServerDungeonEvent_EnterTriggerBox TriggerBoxId = " .. tostring(TriggerBoxId))
  for EventId, _ in pairs(self.EventList) do
    local tabArea = self:GetEventAreaConfig(EventId)
    if tabArea and tabArea.EnterTriggerBox == TriggerBoxId then
      local RougeProEvent = self:GetRougeProEvent(EventId)
      if RougeProEvent and RougeProEvent:IsEventState(RougeProGlobalConst.RougeProEventState.Active) == false then
        self:ChangeEventState(EventId, RougeProGlobalConst.RougeProEventState.Active)
        return
      end
    end
  end
end

function RougeProEventManager:OnNotifyServerDungeonEvent_ExitTriggerBox(TriggerBoxId)
  print("RougeProEventManager OnNotifyServerDungeonEvent_ExitTriggerBox TriggerBoxId = " .. tostring(TriggerBoxId))
  for EventId, _ in pairs(self.EventList) do
    local tabArea = self:GetEventAreaConfig(EventId)
    if tabArea and tabArea.ExitTriggerBox == TriggerBoxId then
      local RougeProEvent = self:GetRougeProEvent(EventId)
      if RougeProEvent and RougeProEvent:IsEventState(RougeProGlobalConst.RougeProEventState.Active) == true then
        self:ChangeEventState(EventId, RougeProGlobalConst.RougeProEventState.Suspend)
        return
      end
    end
  end
end

DungeonClass.AssembleComponents(RougeProEventManager)
return RougeProEventManager
