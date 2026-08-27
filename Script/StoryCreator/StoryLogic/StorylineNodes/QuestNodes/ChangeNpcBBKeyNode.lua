local ChangeNpcBBKeyNode = Class("StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode")

function ChangeNpcBBKeyNode:Init()
  self.NpcUnitId = 0
  self.QuestEventName = ""
  self.MoveToPosEventName = ""
  self.TurnToEventName = ""
  self.x = 0
  self.y = 0
  self.z = 0
  self.NewTargetPointName = ""
  self.SplineName = ""
  self.WaitTime = 0
  self.IsWait = false
  self.PostBehaviorEvent = ""
  self.Animations = nil
  self.CreatorId = 0
  self.DialogueId = 0
end

function ChangeNpcBBKeyNode:Start(Context)
  self.Context = Context
  if self.IsWait then
    EventManager:AddEvent(EventID.OnSTLIsWaitPostBTEvent, self, self.OnReceivePostEvent)
  end
  self:SendMessageContent()
end

function ChangeNpcBBKeyNode:SendMessageContent()
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not IsValid(GameState) then
    DebugPrint("ERROR: ChangeNpcBBKeyNode GameState is nil")
    self:FinishAction()
    return
  end
  local NpcCharacterMap = GameState.NpcCharacterMap
  local Npc = NpcCharacterMap:FindRef(self.NpcUnitId)
  if not IsValid(Npc) then
    DebugPrint("ERROR: ChangeNpcBBKeyNode Npc is nil, NpcUnitId:" .. tostring(self.NpcUnitId))
    self:FinishAction()
    return
  end
  if self.QuestEventName == "MoveToPosition" then
    self:ChangeNpcMoveToPosition(Npc)
  end
  if self.QuestEventName == "PlayAnimation" then
    self:PlayAnimation(Npc)
  end
  if self.QuestEventName == "WaitSTL" then
    self:WaitSTL(Npc)
  end
  if self.QuestEventName == "TurnTo" then
    self:TurnTo(Npc)
  end
  if self.QuestEventName == "LookAt" then
    self:LookAt(Npc)
  end
  if self.QuestEventName == "PlayTalk" then
    self:PlayTalk(Npc)
  end
  if not self.IsWait then
    self:FinishAction()
  end
end

function ChangeNpcBBKeyNode:ChangeNpcMoveToPosition(Npc)
  local BB = Npc:GetOwnBlackBoardComponent()
  if not BB then
    DebugPrint("ERROR:AI.UnitId:" .. tostring(Npc.UnitId) .. ", AI:GetName " .. Npc:GetName() .. " BehaviorTree Is nil")
    return false
  end
  if self.MoveToPosEventName == "Location" then
    BB:SetValueAsVector("STLLocation", FVector(tonumber(self.x) or 0, tonumber(self.y) or 0, tonumber(self.z) or 0))
    BB:SetValueAsString("STLParamName", "")
    return true
  elseif self.MoveToPosEventName == "TargetPointName" then
    BB:SetValueAsString("STLParamName", self.NewTargetPointName)
    BB:SetValueAsVector("STLLocation", FVector(0, 0, 0))
    return true
  elseif self.MoveToPosEventName == "SplineName" then
    BB:SetValueAsString("STLParamName", self.SplineName)
    BB:SetValueAsVector("STLLocation", FVector(0, 0, 0))
    return true
  end
  DebugPrint("ERROR: ChangeNpcBBKeyNode invalid MoveToPosEventName:" .. tostring(self.MoveToPosEventName))
  return false
end

function ChangeNpcBBKeyNode:WaitSTL(Npc)
  local BB = Npc:GetOwnBlackBoardComponent()
  if not BB then
    DebugPrint("ERROR:AI.UnitId:" .. tostring(Npc.UnitId) .. ", AI:GetName " .. Npc:GetName() .. " BehaviorTree Is nil")
    return false
  end
  BB:SetValueAsFloat("STLTimeParam", tonumber(self.WaitTime) or 0)
  return true
end

function ChangeNpcBBKeyNode:PlayAnimation(Npc)
  local BB = Npc:GetOwnBlackBoardComponent()
  if not BB then
    DebugPrint("ERROR:AI.UnitId:" .. tostring(Npc.UnitId) .. ", AI:GetName " .. Npc:GetName() .. " BehaviorTree Is nil")
    return false
  end
  if not self.Animations then
    return false
  end
  for _, AnimationName in pairs(self.Animations) do
    BB:SetValueAsString("STLAnimationName", AnimationName)
  end
  return true
end

function ChangeNpcBBKeyNode:TurnTo(Npc)
  local BB = Npc:GetOwnBlackBoardComponent()
  if not BB then
    DebugPrint("ERROR:AI.UnitId:" .. tostring(Npc.UnitId) .. ", AI:GetName " .. Npc:GetName() .. " BehaviorTree Is nil")
    return false
  end
  if self.TurnToEventName == "TargetPointName" then
    BB:SetValueAsString("STLParamName", self.NewTargetPointName)
    BB:SetValueAsVector("STLLocation", FVector(0, 0, 0))
    BB:SetValueAsInt("STLCreatorId", 0)
    return true
  elseif self.TurnToEventName == "Player" then
    BB:SetValueAsString("STLParamName", "Player")
    BB:SetValueAsVector("STLLocation", FVector(0, 0, 0))
    BB:SetValueAsInt("STLCreatorId", 0)
    return true
  elseif self.TurnToEventName == "StaticCreateActor" then
    BB:SetValueAsString("STLParamName", "")
    BB:SetValueAsVector("STLLocation", FVector(0, 0, 0))
    BB:SetValueAsInt("STLCreatorId", self.CreatorId)
    return true
  end
  DebugPrint("ERROR: ChangeNpcBBKeyNode invalid TurnToEventName:" .. tostring(self.TurnToEventName))
  return false
end

function ChangeNpcBBKeyNode:LookAt(Npc)
  local BB = Npc:GetOwnBlackBoardComponent()
  if not BB then
    DebugPrint("ERROR:AI.UnitId:" .. tostring(Npc.UnitId) .. ", AI:GetName " .. Npc:GetName() .. " BehaviorTree Is nil")
    return false
  end
  if self.LookAtEventName == "TargetPointName" then
    BB:SetValueAsString("STLParamName", self.NewTargetPointName)
    BB:SetValueAsVector("STLLocation", FVector(0, 0, 0))
    BB:SetValueAsInt("STLCreatorId", 0)
    return true
  elseif self.LookAtEventName == "Player" then
    BB:SetValueAsString("STLParamName", "Player")
    BB:SetValueAsVector("STLLocation", FVector(0, 0, 0))
    BB:SetValueAsInt("STLCreatorId", 0)
    return true
  elseif self.LookAtEventName == "StaticCreateActor" then
    BB:SetValueAsString("STLParamName", "")
    BB:SetValueAsVector("STLLocation", FVector(0, 0, 0))
    BB:SetValueAsInt("STLCreatorId", self.CreatorId)
    return true
  end
  DebugPrint("ERROR: ChangeNpcBBKeyNode invalid TurnToEventName:" .. tostring(self.TurnToEventName))
  return false
end

function ChangeNpcBBKeyNode:PlayTalk(Npc)
  local BB = Npc:GetOwnBlackBoardComponent()
  if not BB then
    DebugPrint("ERROR:AI.UnitId:" .. tostring(Npc.UnitId) .. ", AI:GetName " .. Npc:GetName() .. " BehaviorTree Is nil")
    return false
  end
  BB:SetValueAsInt("STLDialogueId", self.DialogueId)
  return true
end

function ChangeNpcBBKeyNode:OnReceivePostEvent(InSTLEventName)
  if InSTLEventName == self.PostBehaviorEvent then
    self:FinishAction()
  end
end

function ChangeNpcBBKeyNode:FinishAction()
  self:Finish()
end

function ChangeNpcBBKeyNode:Clear()
  EventManager:RemoveEvent(EventID.OnSTLIsWaitPostBTEvent, self)
end

function ChangeNpcBBKeyNode:OnQuestlineFail()
  EventManager:RemoveEvent(EventID.OnSTLIsWaitPostBTEvent, self)
end

function ChangeNpcBBKeyNode:ClearWhenQuestSuccess()
end

return ChangeNpcBBKeyNode
