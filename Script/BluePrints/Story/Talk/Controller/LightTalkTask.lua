local ETalkNodeFinishType = require("StoryCreator.StoryLogic.StorylineUtils").ETalkNodeFinishType
local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local LightTalkTask = Class({
  "BluePrints.Story.Talk.Controller.TalkTaskBase"
})

function LightTalkTask:InitData(TalkTaskData, NodeFinished_Callback)
  self.ExecutedComps = {}
  self.NodeFinished_Callback = NodeFinished_Callback
  self.TalkTaskData = TalkTaskData
  self.TalkContext = TalkTaskData.TalkContext
  self.TalkActionManager = self.TalkContext.TalkActionManager
  self.TalkTimerManager = self.TalkContext.TalkTimerManager
  self.WaitQueueManager = self.TalkContext.WaitQueueManager
  self.bTaskPlayDialogueFinished = false
  self.bFinished = false
  self.Player = TalkTaskData.Player
end

function LightTalkTask:InitUI()
  if not self.TalkTaskData or not self.TalkTaskData.UIName then
    return
  end
  self.UI = UIManager(GWorld.GameInstance):LoadUINew(self.TalkTaskData.UIName)
  if self.TalkType == "ForgingGuide" then
    self.UI:SetForgeVisibility(true)
  else
    self.UI:SetForgeVisibility(false)
  end
end

function LightTalkTask:GetTalkFlowType()
  return self.BasicTalkType
end

function LightTalkTask:CreatePrepareDialogueNode(Flow, Params)
  local DialogueData = Params and Params.DialogueData
  if not DialogueData then
    return
  end
  local PrepareNode = Flow:CreateNode(UEFNode_Delegate)
  PrepareNode.DebugLog = string.format("LightTalkTask PrepareDialogueNode: %s", tostring(DialogueData.DialogueId))
  PrepareNode.OnStart:Add(PrepareNode, function(Node)
    self.CurrentDialogueData = DialogueData
    self:UpdateTalkSnapShot(DialogueData)
    self:ProcessDialogueData(DialogueData, false)
    Node:Finish({
      Node.FinishPin
    })
  end)
  return PrepareNode
end

function LightTalkTask:Start(TalkTaskData, NodeFinished_Callback)
  LightTalkTask.Super.Start(self, TalkTaskData, NodeFinished_Callback)
  DebugPrint("LightTalkTask:Start:", TalkTaskData.TalkNodeId)
  AudioManager(GWorld.GameInstance):AddAuANotifyForbidTag(self.UnitKey)
  self:InitData(TalkTaskData, NodeFinished_Callback)
  self:InitUI()
  EventManager:AddEvent(EventID.InLoading, self, self.InLoading)
  self:StartTalkFlow()
end

function LightTalkTask:OnFlowEnd()
  self.CurrentDialogueData = nil
end

function LightTalkTask:Finish(TalkNodeFinishType)
  if self.bFinished then
    return
  end
  self.bFinished = true
  DebugPrint("LightTalkTask:Finish:", self.TalkTaskData.TalkNodeId)
  if IsValid(self.UI) and self.UI.OnFinished then
    self.UI:OnFinished(function()
      self:RealFinish(TalkNodeFinishType)
    end)
  else
    self:RealFinish(TalkNodeFinishType)
  end
end

function LightTalkTask:Clear()
  DebugPrint("LightTalkTask:Clear")
  AudioManager(GWorld.GameInstance):RemoveAuANotifyForbidTag(self.UnitKey)
  self:RemoveDialogueEffectSound()
  self:ClearWaitTag()
  self:ClearAudio()
  self:ClearAllTimers()
  if self.TalkContext then
    self.TalkContext.TalkActionManager:StopAllLookAt(self)
  end
  self:StopDSL()
  self:ClearUI()
  self:ClearEvents()
end

function LightTalkTask:PlayDialogue(bPauseResume)
  local NodeType = self.TalkFlowController:GetCurrentNodeType()
  if NodeType ~= EDialogueNodeType.Dialogue then
    DebugPrint("lhr@Dialogue Iteration Error: NodeType", NodeType, "不合法")
    return
  end
  local Dialogue = self.TalkFlowController:GetDialogue()
  DebugPrint("LightTalkTask PlayDialogue:", Dialogue and Dialogue.DialogueId)
  if not Dialogue then
    DebugPrint("lhr@Dialogue Iteration Error: Dialogue为空")
    return
  end
  self:UpdateTalkSnapShot(Dialogue)
  local DialogueData = self:GetDialogueDataWithCheck(Dialogue)
  DialogueData = self:ProcessDialogueData(DialogueData, bPauseResume)
  self.CurrentDialogueData = DialogueData
  self:ConstructWaitTag(self, self.OnTaskPlayDialogueFinished)
  self:ProcessWaitTag_UIPlayDialogue(DialogueData, self.WaitQueue)
  self:ProcessWaitTag_PlayAudio(DialogueData, bPauseResume, nil, self.WaitQueue)
  self:ProcessWaitTag_PlayScript(DialogueData, self.WaitQueue)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:CompletedDialogue(DialogueData.DialogueId)
  end
end

function LightTalkTask:EndDialogue()
  self.CurrentDialogueData = nil
  self:Finish(ETalkNodeFinishType.Out)
end

function LightTalkTask:TryFireEndingCallback(TalkNodeFinishType, OptionIndex)
  if self.NodeFinished_Callback and self.NodeFinished_Callback[2] then
    local NodeFinished_Obj = self.NodeFinished_Callback[1]
    local NodeFinished_Func = self.NodeFinished_Callback[2]
    NodeFinished_Func(NodeFinished_Obj, self, TalkNodeFinishType, OptionIndex)
  end
end

function LightTalkTask:RealFinish(TalkNodeFinishType)
  DebugPrint("LightTalkTask:RealFinish:", self.TalkTaskData.TalkNodeId, self.TalkTaskData.TalkNodeName, self.NodeFinished_Callback)
  if self.TalkFlowController:IsUseFlowAsset() then
    self:TryEndFlowGraph()
  end
  self:Clear()
  self:TryFireEndingCallback(TalkNodeFinishType)
  TalkSubsystem():ClearRefs(self)
end

local WaitItemUniqueTag = TalkUtils:GetPlayDialogueWaitItemTags()

function LightTalkTask:ConstructWaitTag(Obj, Func)
  self.WaitQueue = self.TalkContext.WaitQueueManager:CreateWaitQueue(self, {
    {
      Tag = WaitItemUniqueTag.UIPlayDialogue
    },
    {
      Tag = WaitItemUniqueTag.PlayAudio
    },
    {
      Tag = WaitItemUniqueTag.PlayScript
    }
  }, Obj, Func)
end

function LightTalkTask:ProcessWaitTag_UIPlayDialogue(DialogueData, WaitQueuePointer)
  if IsValid(self.UI) then
    self.UI:PlayDialogue(self, DialogueData, self.TalkTaskData, function()
      WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.UIPlayDialogue)
    end)
  else
    WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.UIPlayDialogue)
  end
end

function LightTalkTask:ProcessWaitTag_PlayAudio(DialogueData, bPauseResume, bIsAttachActor, WaitQueuePointer, bNoWait)
  if not self.TalkAudioComp then
    WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
    return
  end
  if bPauseResume and self.bAudioFinished then
    WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
    return
  end
  DebugPrint("LightTalkTask:ProcessWaitTag_PlayAudio", DialogueData, bPauseResume, self.bAudioFinishe, bNoWait)
  self.bAudioFinished = false
  self:PlayAudio(DialogueData, function(bUnFinished)
    if not bUnFinished then
      self.bAudioFinished = true
    end
    WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
  end, bIsAttachActor, bPauseResume, bNoWait)
end

function LightTalkTask:ProcessWaitTag_PlayScript(DialogueData, WaitQueuePointer)
  self:RunDSL(DialogueData, function()
    WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayScript)
  end)
end

function LightTalkTask:OnTaskPlayDialogueFinished()
  DebugPrint("LightTalkTask OnTaskPlayDialogueFinished", self)
  self.TalkFlowController:Iterate()
end

function LightTalkTask:OnExceptionInterruptedBySTL()
  DebugPrint("LightTalkTask:OnExceptionInterruptedBySTL")
  TalkUtils:RemovePlayerInvincible()
  self.bHasInterrupted = true
  if self.TalkFlowController:IsUseFlowAsset() then
    self.TalkTaskData.FlowAsset:FinishFlow(UE4.EFlowFinishPolicy.Keep)
  else
    self:StopTalkFlow()
  end
  self:Clear()
end

function LightTalkTask:OnInterrupted()
  DebugPrint("LightTalkTask:OnInterrupted")
  self.bHasInterrupted = true
  if self.TalkFlowController:IsUseFlowAsset() then
    self.TalkTaskData.FlowAsset:FinishFlow(UE4.EFlowFinishPolicy.Keep)
  else
    self:StopTalkFlow()
  end
  self:Clear()
end

function LightTalkTask:OnPaused()
  DebugPrint("LightTalkTask:对话被暂停", self, self:GetTalkType())
  self.PauseTime = UE4.UGameplayStatics.GetTimeSeconds(GWorld.GameInstance)
  if not self.TalkFlowController:IsUseFlowAsset() then
    self:PauseTalkFlow()
    return
  end
  self:ClearWaitTag()
  self:PauseAllTimers(true)
  if not self.bAudioFinished then
    self:PauseAudio()
  end
  self:StopDSL()
  if IsValid(self.UI) and self.UI.OnPaused then
    self.UI:OnPaused()
  end
end

function LightTalkTask:OnPauseResumed()
  if self.bHasInterrupted then
    return
  end
  DebugPrint("LightTalkTask:对话暂停恢复", self, self:GetTalkType())
  if not self.TalkFlowController:IsUseFlowAsset() then
    self:ResumeTalkFlow()
    return
  end
  if IsValid(self.UI) and self.UI.OnPauseResumed then
    self.UI:OnPauseResumed()
  end
  self.TalkFlowController:Resume()
  self:PauseAllTimers(false)
  if not self.bAudioFinished then
    self:ResumePauseAudio()
  end
end

function LightTalkTask:ProcessDialogueData(DialogueData, bPauseResume)
  if bPauseResume then
    local PlayedDuration = self.PauseTime - self.StartTime
    local PlaybackData = {}
    for Key, Value in pairs(DialogueData) do
      PlaybackData[Key] = Value
    end
    PlaybackData.Duration = math.max(DialogueData.Duration - PlayedDuration, 0)
    return PlaybackData
  else
    self.StartTime = UE4.UGameplayStatics.GetTimeSeconds(GWorld.GameInstance)
    return DialogueData
  end
end

function LightTalkTask:InLoading()
  DebugPrint("LightTalkTask:InLoading", self)
  TalkSubsystem():ForceInterruptTalkTaskData(function(Data)
    return Data.FirstDialogueId == self.TalkTaskData.FirstDialogueId
  end)
end

function LightTalkTask:ClearEvents()
  EventManager:RemoveEvent(EventID.InLoading, self)
end

function LightTalkTask:ClearUI()
  if not IsValid(self.UI) then
    return
  end
  UIManager(GWorld.GameInstance):UnLoadUINew("TalkGuideUI")
  self.UI = nil
end

function LightTalkTask:ClearAudio()
  if self.TalkAudioComp then
    self.TalkAudioComp:Clear()
  end
end

function LightTalkTask:CreateComponents()
  LightTalkTask.Super.CreateComponents(self)
  if not self.TaskData then
    return
  end
  self.TalkTaskData = self.TaskData
  self.TalkContext = self.TaskData.TalkContext
  self:CreateTalkAudioComponent()
  self:CreateExpressionComponent()
end

return LightTalkTask
