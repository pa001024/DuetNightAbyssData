local ETalkNodeFinishType = require("StoryCreator.StoryLogic.StorylineUtils").ETalkNodeFinishType
local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local Timeutils = require("Utils.TimeUtils")
local EBubblePlayType = {
  Once = "Once",
  StayOnLast = "StayOnLast",
  DelayLoop = "DelayLoop"
}
local WaitItemUniqueTag = TalkUtils:GetPlayDialogueWaitItemTags()
local TalkLogType = UE.EStoryLogType.Talk
local M = Class("BluePrints.Story.Talk.Controller.LightTalkTask")

function M:InitUI()
end

function M:Start(TalkTaskData, NodeFinished_Callback)
  if TalkTaskData.TalkActors then
    TalkTaskData.TalkContext:CreateTalkActors(self, TalkTaskData.TalkActors, nil, nil, true)
  end
  self:PlaySnapShot()
  self:InitData(TalkTaskData, NodeFinished_Callback)
  self:InitUI()
  EventManager:AddEvent(EventID.InLoading, self, self.InLoading)
  self:StartPlayDialogue()
end

function M:Clear(bIsPaused)
  if self.TalkTaskData.TalkActors then
    self.TalkContext:DestoryTalkActors(self, self.TalkTaskData.TalkActors)
  end
  self:RemoveDialogueEffectSound()
  self:ClearWaitTag()
  self:ClearAudio()
  self:ClearAllTimers()
  if self.TalkContext then
    self.TalkContext.TalkActionManager:StopAllLookAt(self)
  end
  self:StopDSL()
  if not bIsPaused then
    self:ClearUI()
    self:ClearEvents()
  end
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
  self.DialogueIterationComponent:Start()
  self.TalkContext:RecordBubbleStart(self.TalkTaskData)
end

function M:PlayDialogue(bPauseResume)
  local NodeType = self.DialogueIterationComponent:GetCurrentNodeType()
  if NodeType == EDialogueNodeType.Dialogue then
    local Dialogue = self.DialogueIterationComponent:GetDialogue()
    if not Dialogue then
      DebugPrint("lhr@Dialogue Iteration Error: Dialogue为空")
      return
    end
    DebugPrint("M:PlayDialogue:", self.TalkTaskData.TalkNodeId, Dialogue.DialogueId)
    self:DisableBubbleUI()
    local DialogueData = self:GetDialogueDataWithCheck(Dialogue)
    if not self:CheckDialogueData(DialogueData, Dialogue.DialogueId) then
      self:OnTaskPlayDialogueFinished()
      return
    end
    self:OnPlayingDialogue(Dialogue)
    self:ConstructWaitTag(DialogueData, self, self.OnTaskPlayDialogueFinished)
    self:ProcessWaitTag_PlayScript(DialogueData, self.WaitQueue)
    self:ProcessWaitTag_UIPlayDialogue(DialogueData, self.WaitQueue)
    self:ProcessWaitTag_PlayAudio(DialogueData, bPauseResume, true, true, self.WaitQueue)
  else
    DebugPrint("lhr@Dialogue Iteration Error: NodeType", NodeType, "不合法")
    return
  end
end

function M:EndDialogue()
  DebugPrint("lhr@BubbleTalk end")
  if self.TalkTaskData.BubblePlayType == EBubblePlayType.Once then
    self:Finish(ETalkNodeFinishType.Out)
  elseif self.TalkTaskData.BubblePlayType == EBubblePlayType.StayOnLast then
  elseif self.TalkTaskData.BubblePlayType == EBubblePlayType.DelayLoop then
    self:DisableBubbleUI()
    self.DialogueIterationComponent:Initialize(DataMgr.Dialogue, self.TalkTaskData.FirstDialogueId)
    self.TalkTimerManager:AddTimer(self, self.TalkTaskData.BubbleDelayLoopSeconds, false, nil, self, function()
      self.DialogueIterationComponent:Start()
    end)
  end
end

function M:ConstructWaitTag(DialogueData, Obj, Func)
  self.WaitQueue = self.TalkContext.WaitQueueManager:CreateWaitQueue(self, {
    {
      Tag = WaitItemUniqueTag.UIPlayDialogue
    },
    {
      Tag = WaitItemUniqueTag.PlayAudio
    },
    {
      Tag = WaitItemUniqueTag.PlayScript,
      Condition = function()
        return DialogueData.Scripts
      end
    }
  }, Obj, Func)
end

function M:ProcessWaitTag_UIPlayDialogue(DialogueData, WaitQueuePointer)
  DebugPrint("NewBubbleTalkTask ProcessWaitTag_UIPlayDialogue", DialogueData)
  self:RecordDialogueData(DialogueData)
  self:EnableBubbleUI(DialogueData)
  self.TalkTimerManager:AddTimer(self, DialogueData.Duration, false, nil, nil, function()
    WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.UIPlayDialogue)
  end)
end

function M:EnableBubbleUI(DialogueData)
  local TalkActor = DialogueData.TalkActorData and DialogueData.TalkActorData.TalkActor
  if not IsValid(TalkActor) then
    local InteractiveActorId = self.TalkTaskData.InteractiveActorId
    if InteractiveActorId then
      local TalkActorData = self.TalkContext:GetTalkActorData(self, InteractiveActorId)
      TalkActor = TalkActorData and TalkActorData.TalkActor
    end
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

function M:RecordDialogueData(DialogueData)
  self.LastDialogueData = self.WorkingDialogueData
  self.WorkingDialogueData = DialogueData
end

function M:ClearUI()
  if IsValid(self.TalkActor) then
    self.TalkActor:EnableBubbleWidget(false)
  end
end

function M:ClearAudio()
  if self.TalkAudioComp then
    self.TalkAudioComp:Clear(self, self.TalkActor)
  end
end

function M:OnPaused()
  M.Super.OnPaused(self)
  self:DisableBubbleUI()
end

function M:PauseAudio()
  self:PauseSnapShot()
  if self.TalkAudioComp then
    self.TalkAudioComp:OnPaused(self, self.TalkActor)
  end
end

function M:ResumePauseAudio()
  if self.TalkAudioComp then
    self.TalkAudioComp:OnPauseResumed(self, self.TalkActor)
  end
end

function M:CheckDialogueData(DialogueData, DialogueId)
  local ErrorMessge = [[

DialogueId:]] .. tostring(DialogueId) .. [[

TalkNodeName: ]] .. tostring(self.TalkTaskData.TalkNodeName)
  if not DialogueData then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, TalkLogType, "冒泡对话数据错误: DialogueData无效", "台本内容为空" .. ErrorMessge)
    return false
  elseif not DialogueData.TalkActorData then
    local InteractiveActorId = self.TalkTaskData.InteractiveActorId
    if not InteractiveActorId or not DataMgr.TheaterNpc[InteractiveActorId] then
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
