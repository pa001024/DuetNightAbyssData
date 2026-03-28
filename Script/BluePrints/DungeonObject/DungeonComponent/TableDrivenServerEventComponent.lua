local TableDrivenServerEventComponent = DungeonClass.Class()
TableDrivenServerEventComponent.__Component__ = {}

function TableDrivenServerEventComponent:BeginPlay()
  print("ljl@ TableDrivenServerEventComponent BeginPlay")
  self.SingleEvents = {}
  self.ResetAbleEvents = {}
  self.MultiEvents = {}
end

function TableDrivenServerEventComponent:InitTableDrivenServerEventComponent(GameModeType)
  local TableName = GameModeType .. "ServerEvent"
  self.EventInfoTable = DataMgr[TableName]
  if not self.EventInfoTable then
    return
  end
  for EventId, Info in pairs(self.EventInfoTable) do
    local EventTable = self[Info.TriggerType .. "Events"]
    if EventTable then
      EventTable[EventId] = false
    end
  end
end

function TableDrivenServerEventComponent:OnNotifyServerDungeonEvent_TableDrivenServerEvent(EventId)
  print("ljl@ TableDrivenServerEvent EventId", EventId)
  if not self.EventInfoTable then
    return
  end
  if not self:IsEventTriggerAble(EventId) then
    return
  end
  local EventInfo = self.EventInfoTable[EventId]
  if not EventInfo then
    return
  end
  local EventList = EventInfo.EventName or {}
  for Index, EventName in pairs(EventList) do
    local FuncName = "TableEvent_" .. EventName
    if self[FuncName] then
      local Params = EventInfo.EventParams and EventInfo.EventParams[Index] or {}
      self[FuncName](self, EventId, Params)
    end
  end
end

function TableDrivenServerEventComponent:IsEventTriggerAble(EventId)
  local EventInfo = self.EventInfoTable[EventId]
  if not EventInfo then
    return false
  end
  local TriggerType = EventInfo.TriggerType
  if "Multi" == TriggerType then
    self.MultiEvents[EventId] = true
    return true
  end
  if "Single" == TriggerType then
    if self.SingleEvents[EventId] then
      return false
    else
      self.SingleEvents[EventId] = true
      return true
    end
  end
  if "ResetAble" == TriggerType then
    if self.ResetAbleEvents[EventId] then
      return false
    else
      self.ResetAbleEvents[EventId] = true
      return true
    end
  end
end

function TableDrivenServerEventComponent:ResetTableDrivenEvent(EventId)
  if self.ResetAbleEvents[EventId] == nil then
    return
  end
  self.ResetAbleEvents[EventId] = false
  print("ljl@ TableDrivenServerEventComponent ResetEvent! EventId", EventId)
end

function TableDrivenServerEventComponent:TableEvent_ActiveStaticCreator(EventId, Params)
  if not Params then
    return
  end
  local CreatorId = Params.CreatorId
  print("ljl@ TableDrivenServerEventComponent TableEvent_ActiveStaticCreator EventId", EventId, "CreatorId", CreatorId)
  self:ActiveStaticCreator({CreatorId})
end

function TableDrivenServerEventComponent:TableEvent_ActiveMonsterSpawn(EventId, Params)
  if not Params then
    return
  end
  local MonsterSpawnId = Params.MonsterSpawnId
  local OnlyRelation = Params.OnlyRelation == "true"
  print("ljl@ TableDrivenServerEventComponent TableEvent_ActiveMonsterSpawn EventId", EventId, "MonsterSpawnId", MonsterSpawnId, "OnlyRelation", OnlyRelation)
  self:ServerTriggerCreateMonsterSpawn({MonsterSpawnId}, OnlyRelation)
end

function TableDrivenServerEventComponent:TableEvent_MyCustomFunc(EventId, Params)
  if not Params then
    return
  end
  print("ljl@ TableDrivenServerEventComponent TableEvent_MyCustomFunc EventId", EventId, "Params", Params.MyParam1, Params.MyParam2)
end

DungeonClass.AssembleComponents(TableDrivenServerEventComponent)
return TableDrivenServerEventComponent
