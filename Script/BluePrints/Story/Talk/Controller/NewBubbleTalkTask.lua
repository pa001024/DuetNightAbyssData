local ETalkNodeFinishType = require("StoryCreator.StoryLogic.StorylineUtils").ETalkNodeFinishType
local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local Timeutils = require("Utils.TimeUtils")
local EBubblePlayType = {
  Once = "Once",
  StayOnLast = "StayOnLast",
  DelayLoop = "DelayLoop"
}
local TalkLogType = UE.EStoryLogType.Talk
local M = Class("BluePrints.Story.Talk.Controller.TalkTaskBase")

function M:Start(TalkTaskData, NodeFinished_Callback)
  M.Super.Start(self, TalkTaskData, NodeFinished_Callback)
  if TalkTaskData.TalkActors then
    TalkTaskData.TalkContext:CreateTalkActors(self, TalkTaskData.TalkActors, nil, nil, true)
  end
  self:InitData(TalkTaskData, NodeFinished_Callback)
  self.bCleared = false
  self.bHasInterrupted = false
  EventManager:AddEvent(EventID.InLoading, self, self.InLoading)
  self:StartPlayDialogue()
end

function M:Clear()
  if self.bCleared then
    return
  end
  self.bCleared = true
  if self.TalkTaskData.TalkActors then
    self.TalkContext:DestoryTalkActors(self, self.TalkTaskData.TalkActors)
  end
  self:ClearUI()
  self:ClearWaitTag()
  self:ClearAudio()
  self:ClearAllTimers()
  self.TalkActionManager:StopAllLookAt(self)
  EventManager:RemoveEvent(EventID.InLoading, self)
end

function M:InLoading()
  DebugPrint("BubbleTalkTask:InLoading", self)
  TalkSubsystem():ForceInterruptTalkTaskData(function(Data)
    return Data.FirstDialogueId == self.TalkTaskData.FirstDialogueId
  end)
end

function M:InitData(TalkTaskData, NodeFinished_Callback)
  self.NodeFinished_Callback = NodeFinished_Callback
  self.TalkActionManager = self.TalkContext.TalkActionManager
  self.TalkTimerManager = self.TalkContext.TalkTimerManager
end

function M:CheckBubbleInCd()
  local TalkTaskData = self.TalkTaskData
  if not TalkTaskData.bBubblePlayCDEnable then
    return false
  end
  local LastPlayTime = self.TalkContext:GetBubbleLastPlayTime(TalkTaskData)
  local BubblePlayCD = TalkTaskData.BubblePlayCD
  local NowTime = Timeutils.NowTime()
  if BubblePlayCD <= NowTime - LastPlayTime then
    return false
  end
  return true, BubblePlayCD - (NowTime - LastPlayTime)
end

function M:StartPlayDialogue()
  local bBubbleInCd, CdLastTime = self:CheckBubbleInCd()
  if bBubbleInCd then
    self.TalkTimerManager:AddTimer(self, CdLastTime, false, nil, self, self.StartPlayDialogue)
    return
  end
  self:StartTalkFlow()
  self.TalkContext:RecordBubbleStart(self.TalkTaskData)
end

function M:CreateBubbleUINode(SubFlow, Params)
  local DialogueData = Params and Params.DialogueData
  local DialogueId = Params and Params.DialogueId
  if not DialogueData and DialogueId then
    DialogueData = self:GetDialogueDataWithCheck({DialogueId = DialogueId})
  end
  if not self:CheckDialogueData(DialogueData, DialogueId) then
    return
  end
  if not DialogueData.Content then
    return
  end
  local UINode = SubFlow:CreateNode(UEFNode_Delegate)
  UINode.DebugLog = string.format("NewBubbleTalkTask PrepareDialogueNode: %s", tostring(DialogueData and DialogueData.DialogueId))
  UINode.OnStart:Add(UINode, function(Node)
    if self.bCleared then
      Node:Finish({
        Node.FinishPin
      })
      return
    end
    self:DisableBubbleUI()
    self:UpdateTalkSnapShot(DialogueData)
    self:EnableBubbleUI(DialogueData)
    Node:Finish({
      Node.FinishPin
    })
  end)
  UINode.OnPause:Add(UINode, function()
    self:DisableBubbleUI()
  end)
  UINode.OnResume:Add(UINode, function()
    if self.bCleared then
      return
    end
    self:EnableBubbleUI(DialogueData)
  end)
  return UINode
end

function M:GetAudioConfig(DialogueData)
  if not DialogueData or not DialogueData.VoiceName then
    return
  end
  local TalkActorData = DialogueData.TalkActorData
  return {
    VoiceName = DialogueData.VoiceName,
    SrcActor = TalkActorData and TalkActorData.TalkActor,
    ExtraInfo = DataMgr.Dialogue[DialogueData.DialogueId],
    SoundHandle = self.TalkTaskData and self.TalkTaskData.BasicTalkType,
    bIsAttachActor = true
  }
end

function M:EndDialogue()
  DebugPrint("BubbleTalkTask: End")
  if self.TalkTaskData.BubblePlayType == EBubblePlayType.Once then
    self:Finish(ETalkNodeFinishType.Out)
  elseif self.TalkTaskData.BubblePlayType == EBubblePlayType.StayOnLast then
  elseif self.TalkTaskData.BubblePlayType == EBubblePlayType.DelayLoop then
    self:DisableBubbleUI()
    self.TalkTimerManager:AddTimer(self, self.TalkTaskData.BubbleDelayLoopSeconds, false, nil, self, function()
      self:StartTalkFlow()
    end)
  end
end

function M:Finish(TalkNodeFinishType)
  DebugPrint("BubbleTalkTask:Finish:", self.TalkTaskData.TalkNodeId, self.TalkTaskData.TalkNodeName, self.NodeFinished_Callback)
  self:TryEndFlowGraph()
  self:Clear()
  if self.NodeFinished_Callback and self.NodeFinished_Callback[2] then
    local NodeFinished_Obj = self.NodeFinished_Callback[1]
    local NodeFinished_Func = self.NodeFinished_Callback[2]
    NodeFinished_Func(NodeFinished_Obj, self, TalkNodeFinishType)
  end
end

function M:EnableBubbleUI(DialogueData)
  local TalkActor = DialogueData.TalkActorData and DialogueData.TalkActorData.TalkActor
  if not IsValid(TalkActor) then
    TalkActor = self.TalkTaskData.InteractiveActor
  end
  if IsValid(TalkActor) then
    local Content = DialogueData.Content
    local Style
    if DialogueData.DialoguePanelType then
      local DialoguePanelType = string.lower(DialogueData.DialoguePanelType)
      Style = TalkUtils:FindTargetString(DialoguePanelType, "style")
    end
    TalkActor:EnableBubbleWidget(true, Content, Style)
    self.TalkActor = TalkActor
  end
end

function M:DisableBubbleUI()
  if IsValid(self.TalkActor) then
    self.TalkActor:EnableBubbleWidget(false)
  end
  self.TalkActor = nil
end

function M:ClearUI()
  if IsValid(self.TalkActor) then
    self.TalkActor:EnableBubbleWidget(false)
  end
end

function M:ClearAudio()
  if self.TalkAudioComp then
    self.TalkAudioComp:Clear()
  end
end

function M:OnExceptionInterruptedBySTL()
  DebugPrint("NewBubbleTalkTask:OnExceptionInterruptedBySTL")
  TalkUtils:RemovePlayerInvincible()
  self.NodeFinished_Callback = nil
end

function M:OnInterrupted()
  DebugPrint("NewBubbleTalkTask:OnInterrupted")
  self.bHasInterrupted = true
  self:StopTalkFlow()
  self:Clear()
end

function M:OnPaused()
  DebugPrint("NewBubbleTalkTask:对话被暂停", self)
  self:PauseAllTimers(true)
  self:PauseTalkFlow()
end

function M:OnPauseResumed()
  if self.bHasInterrupted then
    return
  end
  DebugPrint("NewBubbleTalkTask:对话暂停恢复", self)
  self:PauseAllTimers(false)
  self:ResumeTalkFlow()
end

function M:CreateComponents()
  M.Super.CreateComponents(self)
  if not self.TaskData then
    return
  end
  self.TalkTaskData = self.TaskData
  self.TalkContext = self.TaskData.TalkContext
  self:CreateTalkAudioComponent()
  self:CreateExpressionComponent()
end

function M:CheckDialogueData(DialogueData, DialogueId)
  local ErrorMessge = [[

DialogueId:]] .. tostring(DialogueId) .. [[

TalkNodeName: ]] .. tostring(self.TalkTaskData.TalkNodeName)
  if not DialogueData then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, TalkLogType, "冒泡对话数据错误: DialogueData无效", "台本内容为空" .. ErrorMessge)
    return false
  elseif not DialogueData.TalkActorData then
    local InteractiveActor = self.TalkTaskData.InteractiveActor
    if not InteractiveActor or not DataMgr.TheaterNpc[InteractiveActor.UnitId] then
      local Dialogue = DataMgr.Dialogue[DialogueId]
      local SpeakNpcId = Dialogue and Dialogue.SpeakNpcId or 0
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, TalkLogType, "冒泡对话数据错误: TalkActorData无效", "台本SpeakNpcId字段为空\n 或者TalkNode没有配置当前台本SpeakNpcId的演员 SpeakNpcId: " .. tostring(SpeakNpcId) .. ErrorMessge)
      return false
    end
  elseif not DialogueData.TalkActorData.TalkActor then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, TalkLogType, "冒泡对话数据错误: TalkActor无效", "Npc不存在\nNpcId:" .. tostring(DialogueData.TalkActorData.TalkActorId) .. ErrorMessge)
    return false
  end
  return true
end

return M
