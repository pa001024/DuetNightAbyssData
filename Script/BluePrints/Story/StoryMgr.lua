local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
local GuidePointLocData = require("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local StoryMgr = Class("StoryCreator.StoryLogic.StorylineNodes.NodeObject")
local STLogType = UE.EStoryLogType.STL

function StoryMgr:Init()
  self.Storylines = {}
  self.StaticCreatorActorEvents = {}
  self.NpcInteractiveTalkDetail = {}
  self.NpcInteractiveTalkId = 0
  self.WaitTalkTriggerCompleted = {}
  self.ClientQuestChains = nil
  self.bEnableStory = true
end

function StoryMgr:IsCanRunStoryMgr()
  if IsStandAlone(GWorld.GameInstance) or IsClient(GWorld.GameInstance) then
    return true
  end
  return false
end

function StoryMgr:EnableStory()
  self.bEnableStory = true
  EventManager:FireEvent(EventID.OnEnableStory)
  EventManager:AddEvent(EventID.InLoading, self, self.HandleInLoading)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    EventManager:AddEvent(EventID.InLoading, Avatar, Avatar.ClientQuestChainsHandleInLoading)
  end
end

function StoryMgr:DisableStory()
  self.bEnableStory = false
  EventManager:RemoveEvent(EventID.InLoading, self)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    EventManager:RemoveEvent(EventID.InLoading, Avatar)
  end
end

function StoryMgr:HandleInLoading()
  self:DisableStory()
  if self:IsCanRunStoryMgr() == false then
    return
  end
  if TaskUtils and TaskUtils.RemoveAllQuestExtraInfo then
    TaskUtils:RemoveAllQuestExtraInfo()
  end
  if self.ClientQuestChains then
    for _, ClientQuestChain in pairs(self.ClientQuestChains) do
      ClientQuestChain:StopStoryline()
    end
    self.ClientQuestChains = nil
  end
  self:Clear()
end

function StoryMgr:Clear()
  DebugPrint("StoryMgr:Clear")
  self:StopAllStoryline()
  self:ClearStaticCreatorActorEvent()
  self:UnbindAllNPCInteractiveTalk()
  self:ClearAllWaitCompleteTalkTrigger()
end

function StoryMgr:RunStory(StoryPath, QuestId, NodeId, EndCallback, StopCallback, Payload)
  if self.Storylines[StoryPath] then
    DebugPrint("StoryMgr:RunStory:Already Exit", StoryPath, QuestId, NodeId, EndCallback, StopCallback, Payload)
    return
  end
  
  local function EndCallbackWithClear()
    self:RemoveStoryline(StoryPath)
    if EndCallback then
      EndCallback()
    end
  end
  
  local function StopCallbackWithClear()
    self:RemoveStoryline(StoryPath)
    if StopCallback then
      StopCallback()
    end
  end
  
  local Storyline = StorylineUtils.BuildStoryline(StoryPath, EndCallbackWithClear, StopCallbackWithClear, Payload)
  if self.bEnableStory == false then
    local Title = "STL 已禁用"
    local Message = string.format("试图在禁用时运行新的 STL %s", StoryPath)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, Title, Message)
  end
  if not Storyline then
    local Message = "Story不存在" .. [[

FileName:]] .. StoryPath
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Story不存在", Message)
    return
  end
  DebugPrint("StoryMgr:RunStory", StoryPath, QuestId, NodeId, EndCallback, StopCallback, Payload)
  self.Storylines[StoryPath] = Storyline
  Storyline:StartStory(tonumber(QuestId), NodeId)
  return Storyline.FilePath
end

function StoryMgr:GetStory(StoryPath)
  local Storyline = self.Storylines[StoryPath]
  return Storyline
end

function StoryMgr:IsRunningStoryline(StoryPath)
  return self.Storylines[StoryPath] ~= nil
end

function StoryMgr:StopStoryline(StoryPath, IgnoreFinishClear)
  local Storyline = self.Storylines[StoryPath]
  if Storyline then
    Storyline:Stop(IgnoreFinishClear)
  end
end

function StoryMgr:FinishStoryline(StoryPath, IgnoreFinishClear)
  local Storyline = self.Storylines[StoryPath]
  if Storyline then
    Storyline:FinishStory(IgnoreFinishClear)
  end
end

function StoryMgr:RemoveStoryline(StoryPath)
  self.Storylines[StoryPath] = nil
end

function StoryMgr:StopAllStoryline()
  local Storylines = {}
  for _, Storyline in pairs(self.Storylines) do
    table.insert(Storylines, Storyline)
  end
  for _, Storyline in pairs(Storylines) do
    Storyline:Stop()
  end
  self.Storylines = {}
end

function StoryMgr:BindStaticCreatorActorEvent(StaticCreatorId, ActorEventType, Obj, Func)
  local ActorEvents = self.StaticCreatorActorEvents[StaticCreatorId]
  if nil == ActorEvents then
    ActorEvents = {}
    self.StaticCreatorActorEvents[StaticCreatorId] = ActorEvents
  end
  ActorEvents[ActorEventType] = {Obj, Func}
end

function StoryMgr:UnbindStaticCreatorActorEvent(StaticCreatorId)
  if self.StaticCreatorActorEvents[StaticCreatorId] then
    self.StaticCreatorActorEvents[StaticCreatorId] = nil
  end
end

function StoryMgr:UnbindStaticCreatorActorEventByType(StaticCreatorId, ActorEventType)
  if self.StaticCreatorActorEvents[StaticCreatorId] and self.StaticCreatorActorEvents[StaticCreatorId][ActorEventType] then
    self.StaticCreatorActorEvents[StaticCreatorId][ActorEventType] = nil
  end
end

function StoryMgr:TryExecStorylineActorEvent(StaticCreatorId, ActorEventType, Info)
  local ActorEvents = self.StaticCreatorActorEvents[StaticCreatorId]
  if ActorEvents then
    local ActorEvent = ActorEvents[ActorEventType]
    if ActorEvent and ActorEvent[1] and ActorEvent[2] then
      ActorEvent[2](ActorEvent[1], Info)
    end
  end
end

function StoryMgr:ClearStaticCreatorActorEvent()
  self.StaticCreatorActorEvents = {}
end

function StoryMgr:BindNPCInteractiveTalk(NPCId, Detail)
  self.NpcInteractiveTalkId = self.NpcInteractiveTalkId + 1
  local BindId = self.NpcInteractiveTalkId
  if not self.NpcInteractiveTalkDetail[NPCId] then
    self.NpcInteractiveTalkDetail[NPCId] = {}
  end
  self.NpcInteractiveTalkDetail[NPCId][BindId] = Detail
  return BindId
end

function StoryMgr:UnbindNPCInteractiveTalk(NPCId, BindId)
  if not BindId then
    return
  end
  local BindInfos = self.NpcInteractiveTalkDetail[NPCId]
  if not BindInfos then
    return
  end
  BindInfos[BindId] = nil
end

function StoryMgr:GetNPCInteractiveTalkDetails(NPCId)
  return self.NpcInteractiveTalkDetail[NPCId]
end

function StoryMgr:ExistedNPCInteractiveTalk(NPCId)
  local BindInfos = self.NpcInteractiveTalkDetail[NPCId]
  return BindInfos and next(BindInfos) ~= nil
end

function StoryMgr:TryGetWaitTalkCompletedQuest(TalkTriggerId)
  return self.WaitTalkTriggerCompleted[TalkTriggerId]
end

function StoryMgr:RegisterWaitTalkCompleted(TalkTriggerId, QuestChainId, SpecialQuestId, DynQuestId, ShowGuide)
  self.WaitTalkTriggerCompleted[TalkTriggerId] = {
    QuestChainId = QuestChainId,
    SpecialQuestId = SpecialQuestId,
    ShowGuide = ShowGuide,
    DynQuestId = DynQuestId
  }
end

function StoryMgr:UnRegisterWaitTalkCompleted(TalkTriggerId)
  self.WaitTalkTriggerCompleted[TalkTriggerId] = nil
end

function StoryMgr:ClearAllWaitCompleteTalkTrigger()
  self.WaitTalkTriggerCompleted = {}
end

function StoryMgr:TryExecNPCInteractiveTalk(NPCId, NPC, BindId, TalkEndCallback)
  local BindInfos = self.NpcInteractiveTalkDetail[NPCId]
  if not BindInfos then
    if TalkEndCallback and TalkEndCallback.Func then
      TalkEndCallback.Func(TalkEndCallback.Obj)
    end
    return
  end
  BindId = BindId or next(BindInfos)
  local Detail = BindInfos[BindId]
  if Detail and Detail.Func then
    Detail.Func(NPC, TalkEndCallback)
  elseif TalkEndCallback and TalkEndCallback.Func then
    TalkEndCallback.Func(TalkEndCallback.Obj)
  end
end

function StoryMgr:UnbindAllNPCInteractiveTalk()
  self.NpcInteractiveTalkDetail = {}
  self.NpcInteractiveTalkId = 0
end

function StoryMgr:PrintStorylineInfo()
  for _, Storyline in pairs(self.Storylines) do
    Storyline:PrintInfo()
  end
end

function StoryMgr:CreateQuestPickupId2Callback(QuestPickupId, Callback)
  if not self.QuestPickupId2Callback then
    self.QuestPickupId2Callback = {}
  end
  self.QuestPickupId2Callback[QuestPickupId] = Callback
end

function StoryMgr:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
  for _, Storyline in pairs(self.Storylines) do
    Storyline:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
  end
end

return StoryMgr
