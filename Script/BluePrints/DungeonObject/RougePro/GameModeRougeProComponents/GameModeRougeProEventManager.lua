local GameModeRougeProEventManager = DungeonClass.Class()

function GameModeRougeProEventManager:GetGameModeRougeProEvents()
  if self.GameModeRougeProEvents == nil then
    self.GameModeRougeProEvents = {}
  end
  return self.GameModeRougeProEvents
end

function GameModeRougeProEventManager:BeginPlay()
  local function OnPlayerExitGame(AvatarArr)
    local PlayerEid = self.GameMode:GetPlayerEidByAvatarEidStr(AvatarArr)
    
    if not PlayerEid then
      return
    end
    local GameModeRougeProEvents = self:GetGameModeRougeProEvents()
    for _, Event in pairs(GameModeRougeProEvents) do
      Event:OnPlayerExitGame(PlayerEid)
    end
  end
  
  self.GameMode.EMGameState:RegisterGameModeEvent("OnExit", self.GameMode, OnPlayerExitGame)
  print("GameModeRougeProEventManager:BeginPlay")
end

function GameModeRougeProEventManager:OnRougeProEventCreate(EventId)
  print("GameModeRougeProEventManager:OnRougeProEventCreate " .. tostring(EventId))
  local GameModeRougeProEvents = self:GetGameModeRougeProEvents()
  local Event = GameModeRougeProEvents[EventId]
  local IsInitSucc = Event:Init()
  if not IsInitSucc then
    self:ShowDungeonObjError("GameModeRougeProEventManager:OnRougeProEventCreate GameMode侧无法获取到EventId(" .. tostring(EventId) .. ")对应的RougeProEvent实例！")
  end
end

function GameModeRougeProEventManager:OnRougeProEventComplete(EventId)
  print("GameModeRougeProEventManager:OnRougeProEventComplete" .. tostring(EventId))
  local GameModeRougeProEvents = self:GetGameModeRougeProEvents()
  local Event = GameModeRougeProEvents[EventId]
  if not Event then
    return
  end
  Event:OnComplete()
end

function GameModeRougeProEventManager:OnRougeProEventDestroy(EventId)
  print("GameModeRougeProEventManager:OnRougeProEventDestroy" .. tostring(EventId))
  local GameModeRougeProEvents = self:GetGameModeRougeProEvents()
  local Event = GameModeRougeProEvents[EventId]
  if not Event then
    return
  end
  Event:OnDestroy()
end

function GameModeRougeProEventManager:OnTriggerAOIBase(...)
  local TriggerEventId, TriggerBase, EMActorEid, TriggerType = ...
  print("GameModeRougeProEventManager: ljl1111111 OnTriggerAOIBase", TriggerEventId, TriggerBase, EMActorEid, TriggerType)
  local GameModeRougeProEvents = self:GetGameModeRougeProEvents()
  for _, Event in pairs(GameModeRougeProEvents) do
    Event:OnTriggerAOIBase(...)
  end
end

function GameModeRougeProEventManager:OnMiniGameSuccess(...)
  local GameModeRougeProEvents = self:GetGameModeRougeProEvents()
  for _, Event in pairs(GameModeRougeProEvents) do
    Event:OnMiniGameSuccess(...)
  end
end

function GameModeRougeProEventManager:OnSceneItemDestroyed(...)
  local GameModeRougeProEvents = self:GetGameModeRougeProEvents()
  for _, Event in pairs(GameModeRougeProEvents) do
    Event:OnSceneItemDestroyed(...)
  end
end

function GameModeRougeProEventManager:SetExtraFixSurvivalValue(Value)
  self.ExtraFixSurvivalValue = Value
end

function GameModeRougeProEventManager:TickFixSurvivalValue(EventObj)
  if not self.ExtraFixSurvivalValue then
    return
  end
  local PoisonMonster = EventObj
  if not PoisonMonster or not PoisonMonster.ServerUniqueId then
    return
  end
  self:NotifyServerDungeonEvent("AddServerSurvivalValue", PoisonMonster.ServerUniqueId, self.ExtraFixSurvivalValue)
end

function GameModeRougeProEventManager:OnRep_EventList()
  print("GameModeRougeProEventManager:OnRep_EventList self=" .. tostring(self))
  local GameModeRougeProEvents = self:GetGameModeRougeProEvents()
  for _, ReplicatedActor in pairs(self.EventList) do
    local RougeProEvent = self:GetReplicatedActorByNetGuid(ReplicatedActor._NetGuid)
    GameModeRougeProEvents[RougeProEvent.EventId] = RougeProEvent
    print("GameModeRougeProEventManager:OnRep_EventList Refresh EventId = " .. RougeProEvent.EventId)
  end
end

return GameModeRougeProEventManager
