local SwitchMechanismStateNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function SwitchMechanismStateNode:Init()
  self.StaticCreatorIdList = {}
  self.ManualItemIdList = {}
  self.StateId = 0
  self.QuestId = 0
  self.BeginStaticCreatorStateIds = {}
  self.BeginManualItemStateIds = {}
  self.WaitCount = 0
end

function SwitchMechanismStateNode:Execute(Callback)
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  local GameState = UE4.UGameplayStatics.GetGameState(GameMode)
  local CreateIds = {}
  if #self.StaticCreatorIdList > 0 then
    for i = 1, #self.StaticCreatorIdList do
      local StateId = GameState.MechanismStateIdMap:Find(self.StaticCreatorIdList[i])
      self.BeginStaticCreatorStateIds[self.StaticCreatorIdList[i]] = StateId
      GameMode:TriggerMechanism(self.StaticCreatorIdList[i], self.StateId)
      table.insert(CreateIds, self.StaticCreatorIdList[i])
    end
  elseif #self.ManualItemIdList > 0 then
    for i = 1, #self.ManualItemIdList do
      local StateId = GameState.ManualMechanismStateIdMap:Find(self.ManualItemIdList[i])
      self.BeginManualItemStateIds[self.ManualItemIdList[i]] = StateId
      table.insert(CreateIds, self.ManualItemIdList[i])
    end
    local Array = self:TableToTArray(self.ManualItemIdList)
    GameMode:TriggerMechanismManualItem(Array, self.StateId, 0, self.QuestId)
  else
    error("SwitchMechanismStateNode节点中静态点Id和ManualItemId均未配置")
    return
  end
  self.WaitCount = #CreateIds
  for _, CreateId in ipairs(CreateIds) do
    local CurrentStateId
    if #self.StaticCreatorIdList > 0 then
      CurrentStateId = GameState.MechanismStateIdMap:Find(CreateId)
    else
      CurrentStateId = GameState.ManualMechanismStateIdMap:Find(CreateId)
    end
    if CurrentStateId == self.StateId then
      self.WaitCount = self.WaitCount - 1
    end
  end
  if self.WaitCount <= 0 then
    Callback()
    return
  end
  
  local function OnStateChanged(_, CreateId, StateId)
    if StateId ~= self.StateId then
      return
    end
    local Found = false
    for _, Id in ipairs(CreateIds) do
      if Id == CreateId then
        Found = true
        break
      end
    end
    if not Found then
      return
    end
    self.WaitCount = self.WaitCount - 1
    if self.WaitCount <= 0 then
      EventManager:RemoveEvent(EventID.OnMechanismEnterState, self)
      Callback()
    end
  end
  
  EventManager:AddEvent(EventID.OnMechanismEnterState, self, OnStateChanged)
end

function SwitchMechanismStateNode:Clear()
  EventManager:RemoveEvent(EventID.OnMechanismEnterState, self)
end

function SwitchMechanismStateNode:OnQuestlineFail()
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if #self.StaticCreatorIdList > 0 then
    for i = 1, #self.StaticCreatorIdList do
      GameMode:TriggerMechanism(self.StaticCreatorIdList[i], self.BeginStaticCreatorStateIds[self.StaticCreatorIdList[i]])
    end
  elseif #self.ManualItemIdList > 0 then
    for i = 1, #self.ManualItemIdList do
      local Table = {}
      Table[1] = self.ManualItemIdList[i]
      local Array = self:TableToTArray(Table)
      GameMode:TriggerMechanismManualItem(Array, self.BeginManualItemStateIds[self.ManualItemIdList[i]], 0, self.QuestId)
    end
  end
end

function SwitchMechanismStateNode:TableToTArray(table)
  local ResTArray = TArray(0)
  if table then
    for _, Item in ipairs(table) do
      ResTArray:Add(Item)
    end
  end
  return ResTArray
end

return SwitchMechanismStateNode
