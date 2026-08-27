local TalkFlow_C = require("BluePrints.Story.Talk.TalkFlow.TalkFlow")
local TalkFlowController_C = require("BluePrints.Story.Talk.TalkFlow.TalkFlowController")
local TalkOptionData_C = require("BluePrints.Story.Talk.Model.TalkOptionData").TalkOptionData_C
local ETalkOptionType = require("BluePrints.Story.Talk.Model.TalkOptionData").ETalkOptionType
local M = Class("BluePrints.Story.Talk.Controller.TalkTaskBase")

local function Trace(Step, ...)
  DebugPrint("[talkflow-ftest-timeout]", Step, ...)
end

function M:New(TaskData, TalkType)
  Trace("TestTalkTask:New", TalkType)
  local Obj = setmetatable({}, {__index = self})
  Obj.UnitKey = string.format("%s_%s", TalkType or "TestTalkFlow", tostring(Obj):gsub("table: ", ""))
  Obj.TaskData = TaskData
  Obj.TalkComps = {}
  Obj.ExecutedComps = {}
  Obj.TalkType = TalkType or "TestTalkFlow"
  Obj.BasicTalkType = "TestTalkFlow"
  Obj.OnTalkEndEvents = {}
  Obj:CreateDialogueRecordComponent()
  Obj:CreateDialogueFlowGraphComponent()
  Obj.TalkFlowController = TalkFlowController_C:New(Obj)
  return Obj
end

function M:Start(TalkTaskData, NodeFinished_Callback)
  Trace("TestTalkTask:Start", TalkTaskData and TalkTaskData.FirstDialogueId, TalkTaskData and TalkTaskData.FlowType)
  M.Super.Start(self)
  self.TalkTaskData = TalkTaskData
  self.NodeFinished_Callback = NodeFinished_Callback
  self.TalkContext = TalkTaskData.TalkContext
  self.TalkTimerManager = self.TalkContext.TalkTimerManager
  self.WaitQueueManager = self.TalkContext.WaitQueueManager
  self.TalkActionManager = self.TalkContext.TalkActionManager
  self.bResponseUIClick = false
  self.bForceAutoPlay = TalkTaskData.bForceAutoPlay == true
  self:SetUIName("ImpressionMainUI")
  Trace("TestTalkTask:LoadUI", "before")
  self.UI = UIManager(GWorld.GameInstance):LoadUINew("ImpressionMainUI")
  Trace("TestTalkTask:LoadUI", "after", self.UI, self.UI and self.UI.GetVisibility and self.UI:GetVisibility())
  self.UI:SetUpTalkTask(self)
  if self.UI.PreEnterTalkTask then
    Trace("TestTalkTask:PreEnterTalkTask", "before")
    self.UI:PreEnterTalkTask(self, TalkTaskData)
    Trace("TestTalkTask:PreEnterTalkTask", "after")
  end
  self.TalkTaskData.UI = self.UI
  self:BindDelegate()
  if self.UI.PostEnterTalkTask then
    Trace("TestTalkTask:PostEnterTalkTask", "before")
    self.UI:PostEnterTalkTask(self, TalkTaskData)
    Trace("TestTalkTask:PostEnterTalkTask", "after")
  end
  Trace("TestTalkTask:StartTalkFlow", "before")
  self:StartTalkFlow()
  Trace("TestTalkTask:StartTalkFlow", "after", self.TalkFlowController and self.TalkFlowController:GetDialogue())
end

function M:GetTalkFlowComps()
  return {
    RecordComp = self.DialogueRecordComponent,
    WikiComp = {}
  }
end

function M:CreateTalkFlow()
  Trace("TestTalkTask:CreateTalkFlow", self.TalkTaskData and self.TalkTaskData.FirstDialogueId, self.TalkTaskData and self.TalkTaskData.FlowType)
  local TalkFlow = TalkFlow_C:New(self.TalkTaskData.FirstDialogueId, self.TalkTaskData.FlowType, self, self:GetTalkFlowComps())
  TalkFlow:BindOnCheckAutoIterateEvent(self, self.IsAutoIterateDialogue)
  TalkFlow:BindOnDialogueEndEvent(self, self.EndDialogue)
  TalkFlow:BindOnFlowEndEvent(self, self.OnFlowEnd)
  TalkFlow:BuildFlow()
  Trace("TestTalkTask:CreateTalkFlow", "built", TalkFlow)
  return TalkFlow
end

function M:EndDialogue(...)
  Trace("TestTalkTask:EndDialogue", ...)
  self:Finish(...)
end

function M:OnFlowEnd()
  Trace("TestTalkTask:OnFlowEnd")
  self:Finish()
end

function M:Finish(TalkNodeFinishType, OptionIndex)
  Trace("TestTalkTask:Finish", TalkNodeFinishType, OptionIndex, self.bFinished)
  if self.bFinished then
    return
  end
  self.bFinished = true
  self:Clear()
  self:TryFireEndingCallback(TalkNodeFinishType, OptionIndex)
end

function M:Clear()
  Trace("TestTalkTask:Clear", self.UI)
  self:StopDSL()
  if self.UnbindDelegate then
    self:UnbindDelegate()
  end
  if self.UI then
    if self.UI.PreExitTalkTask then
      Trace("TestTalkTask:PreExitTalkTask", "before")
      self.UI:PreExitTalkTask(self, self.TalkTaskData)
      Trace("TestTalkTask:PreExitTalkTask", "after")
    end
    if self.UI.PostExitTalkTask then
      Trace("TestTalkTask:PostExitTalkTask", "before")
      self.UI:PostExitTalkTask(self, self.TalkTaskData)
      Trace("TestTalkTask:PostExitTalkTask", "after")
    end
    UIManager(GWorld.GameInstance):UnLoadUINew(self:GetUIName())
    self.UI = nil
  end
  if self.TalkContext then
    self.TalkContext.TalkTimerManager:ClearTimer(self)
    self.TalkContext.WaitQueueManager:ClearGroup(self)
    self.TalkContext.TalkDelegateManager:ClearGroup(self)
  end
end

function M:End(...)
  self:Finish(...)
end

function M:IsAutoIterateDialogue()
  return self:IsAutoPlay()
end

function M:IsAutoPlay()
  if self.UI then
    return self.UI:IsAutoPlay() or self.bForceAutoPlay
  end
  return self.bForceAutoPlay
end

function M:CreatePrepareDialogueNode(SubFlow, Params)
  local DialogueData = Params and Params.DialogueData
  Trace("TestTalkTask:CreatePrepareDialogueNode", DialogueData and DialogueData.DialogueId)
  local PrepareNode = SubFlow:CreateNode(UEFNode_Delegate)
  PrepareNode.DebugLog = string.format("TestTalkTask PrepareDialogueNode: %s", tostring(DialogueData and DialogueData.DialogueId))
  PrepareNode.OnStart:Add(PrepareNode, function(Node)
    Trace("TestTalkTask:PrepareNodeStart", DialogueData and DialogueData.DialogueId)
    self:PrepareDialogue(DialogueData)
    Node:Finish({
      Node.FinishPin
    })
  end)
  return PrepareNode
end

function M:PrepareDialogue(DialogueData)
  Trace("TestTalkTask:PrepareDialogue", DialogueData and DialogueData.DialogueId, self.UI, self.UI and self.UI.GetVisibility and self.UI:GetVisibility())
  if not DialogueData then
    return
  end
  self:SetDialogueTypingFinished(false)
  self:SetPlayDialogueTaskFinished(false)
  self.bAutoToNext = DialogueData.bAutoToNext
  self.TalkTaskState = "PlayingDialogue"
  self:SetCanResponseUIClick(false)
  self.EnableClickTimer = self.TalkTimerManager:AddTimer(self, DialogueData.AllowClickTime or 0.1, nil, nil, nil, function()
    Trace("TestTalkTask:EnableClickTimer", DialogueData and DialogueData.DialogueId)
    self:SetCanResponseUIClick(true)
    self.EnableClickTimer = nil
  end)
  Trace("TestTalkTask:UIPlayDialogue", DialogueData and DialogueData.DialogueId)
  self.UI:PlayDialogue(self, DialogueData, self.TalkTaskData)
end

function M:OnTaskPlayDialogueFinished()
  Trace("TestTalkTask:OnTaskPlayDialogueFinished", self:IsAutoPlay(), self.bAutoToNext, self.IsPanelBeingClicked)
  self:SetPlayDialogueTaskFinished(true)
  if self.bAutoToNext or self:IsAutoPlay() then
    self.bAutoToNext = nil
    self.bForceAutoPlay = false
    if not self.IsPanelBeingClicked then
      self.TalkFlowController:Iterate()
    end
  end
end

function M:OnUIDialoguePanelClicked()
  Trace("TestTalkTask:OnUIDialoguePanelClicked", self:IsDialogueTypingFinished(), self:CanResponseUIClick(), self:IsPlayDialogueTaskFinished())
  if not self:IsDialogueTypingFinished() and not self.UI:SkipDialogueTyping() then
    return
  end
  if not self:CanResponseUIClick() then
    return
  end
  self.TalkFlowController:RequestSkipDialogue()
end

function M:OnUIWholeDialogueTypingFinished(FinishOrPageEnd)
  Trace("TestTalkTask:OnUIWholeDialogueTypingFinished", FinishOrPageEnd)
  if FinishOrPageEnd then
    self:SetDialogueTypingFinished(true)
  end
end

function M:ShowDialogueOptions(OptionIds)
  Trace("TestTalkTask:ShowDialogueOptions", OptionIds and OptionIds[1], OptionIds and OptionIds[2])
  self:SetCanResponseUIClick(false)
  self.TalkTaskState = "ShowingOption"
  local OptionData = TalkOptionData_C.New(ETalkOptionType.Dialogue, nil, OptionIds or {}, self.TalkFlowController)
  self.UI:ShowOptions(self, OptionData, function(ItemIdx, FinishType)
    self.UI:ClearOptions()
    self.TalkFlowController:Iterate(OptionIds[ItemIdx], FinishType)
  end)
end

function M:SkipOption(DialogueId)
  self:RunDSL(DataMgr.Dialogue[DialogueId] or {}, function()
  end)
  self:SkipDSL()
end

function M:BindDelegate()
  Trace("TestTalkTask:BindDelegate", self.UI)
  if self.UI then
    self.UI:AddDelegate_DialoguePanelClicked(self, self.OnUIDialoguePanelClicked)
    self.UI:AddDelegate_WholeDialogueTypingFinished(self, self.OnUIWholeDialogueTypingFinished)
    self.UI:AddDelegate_AutoPlayChanged(self, self.OnAutoPlayChanged)
    self.UI:AddDelegate_SkipButtonClicked(self, self.OnSkipButtonClicked)
  end
end

function M:UnbindDelegate()
  Trace("TestTalkTask:UnbindDelegate", self.UI)
  if self.UI then
    self.UI:RemoveDelegate_DialoguePanelClicked(self, self.OnUIDialoguePanelClicked)
    self.UI:RemoveDelegate_WholeDialogueTypingFinished(self, self.OnUIWholeDialogueTypingFinished)
    self.UI:RemoveDelegate_AutoPlayChanged(self, self.OnAutoPlayChanged)
    self.UI:RemoveDelegate_SkipButtonClicked(self, self.OnSkipButtonClicked)
  end
end

function M:OnAutoPlayChanged()
  Trace("TestTalkTask:OnAutoPlayChanged", self:IsAutoPlay(), self:IsPlayDialogueTaskFinished())
  if self:IsAutoPlay() and self:IsPlayDialogueTaskFinished() then
    self.TalkFlowController:Iterate()
  end
end

function M:OnSkipButtonClicked()
  Trace("TestTalkTask:OnSkipButtonClicked")
  if self.UI then
    self.UI:ToPageEnd()
  end
  local Flow = self.TalkFlowController and self.TalkFlowController.TalkFlow
  if not Flow then
    self:Finish()
    return
  end
  while not Flow:IsEnd() and Flow:Skip() do
  end
  if not self.bFinished then
    Flow:Start()
  end
end

function M:SetDialogueTypingFinished(bFinished)
  self.bDialogueTypingFinished = bFinished
end

function M:IsDialogueTypingFinished()
  return self.bDialogueTypingFinished == true
end

function M:SetPlayDialogueTaskFinished(bFinished)
  self.bTaskPlayDialogueFinished = bFinished
end

function M:IsPlayDialogueTaskFinished()
  return self.bTaskPlayDialogueFinished == true
end

function M:CanResponseUIClick()
  return self.bResponseUIClick == true
end

function M:SetCanResponseUIClick(bResponseUIClick)
  Trace("TestTalkTask:SetCanResponseUIClick", bResponseUIClick)
  self.bResponseUIClick = bResponseUIClick
  if self.UI and self.UI.SwitchWaitState then
    self.UI:SwitchWaitState(self.bResponseUIClick)
  end
end

return M
