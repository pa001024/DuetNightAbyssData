local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")

local function ShowUIDialoguePanel(UI)
  UI.Dialogue_Boss:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

local function CollapseUIDialoguePanel(UI)
  if IsValid(UI) then
    UI.Dialogue_Boss:SetVisibility(ESlateVisibility.Collapsed)
  end
end

local M = Class("BluePrints.Story.Talk.Controller.TalkTaskBase")

function M:Start(TalkTaskData, TaskFinished_Callback)
  M.Super.Start(self, TalkTaskData, TaskFinished_Callback)
  self.TalkTaskData = TalkTaskData
  self.NodeFinished_Callback = TaskFinished_Callback
  self.bCleared = false
  self.bHasInterrupted = false
  self:InitUI()
  AudioManager(GWorld.GameInstance):AddAuANotifyForbidTag(self.UnitKey)
  EventManager:AddEvent(EventID.OnTeamRecoveryStateChange, self, self.HandleOnTeamRecoveryStateChange)
  if not self.TalkTaskData.FirstDialogueId or not DataMgr.Dialogue[self.TalkTaskData.FirstDialogueId] then
    self:EndDialogue()
    return
  end
  self:StartTalkFlow()
end

function M:Clear()
  if self.bCleared then
    return
  end
  self.bCleared = true
  DebugPrint("NewBossTalkTask:Clear")
  self:ClearUI()
  self:ClearAudio()
  self:ClearAllTimers()
  AudioManager(GWorld.GameInstance):RemoveAuANotifyForbidTag(self.UnitKey)
  EventManager:RemoveEvent(EventID.OnTeamRecoveryStateChange, self)
end

function M:CreatePrepareDialogueNode(SubFlow, Params)
  local DialogueData = Params and Params.DialogueData
  if not DialogueData then
    return
  end
  local Content = TalkUtils:DialogueIdToContent(DialogueData.DialogueId)
  if not Content then
    return
  end
  local PrepareNode = SubFlow:CreateNode(UEFNode_Delegate)
  PrepareNode.DebugLog = string.format("NewBossTalkTask PrepareDialogueNode: %s", tostring(DialogueData and DialogueData.DialogueId))
  PrepareNode.OnStart:Add(PrepareNode, function(Node)
    if self.bCleared then
      Node:Finish({
        Node.FinishPin
      })
      return
    end
    self:UpdateTalkSnapShot(DialogueData)
    if self.UI and self.UI.Text_Boss then
      self.UI.Text_Boss:SetText(Content)
    end
    Node:Finish({
      Node.FinishPin
    })
  end)
  return PrepareNode
end

function M:InitUI()
  self.UI = self:CreateBattleMainUI()
  local PlayerCharacter = GWorld:GetMainPlayer()
  if PlayerCharacter:IsDead() then
    CollapseUIDialoguePanel(self.UI)
  else
    ShowUIDialoguePanel(self.UI)
  end
end

function M:CreateComponents()
  M.Super.CreateComponents(self)
  if not self.TaskData then
    return
  end
  self.TalkTaskData = self.TaskData
  self.TalkContext = self.TaskData.TalkContext
  self.TalkTimerManager = self.TalkContext.TalkTimerManager
  self:CreateTalkAudioComponent()
end

function M:CreateBattleMainUI()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local BattleMain = UIManager:GetUIObj("BattleMain")
  return BattleMain
end

function M:HandleOnTeammateRecovery(Eid)
  local Entity = GWorld.Battle:GetEntity(Eid)
  if Entity and Entity.IsMainPlayer and Entity:IsMainPlayer() then
    ShowUIDialoguePanel(self.UI)
  end
end

function M:HandleOnCharWaitingResurgence(Eid)
  local Entity = GWorld.Battle:GetEntity(Eid)
  if Entity and Entity.IsMainPlayer and Entity:IsMainPlayer() then
    CollapseUIDialoguePanel(self.UI)
  end
end

function M:HandleOnTeamRecoveryStateChange(Eid, State, PrevState)
  if State == UE4.ETeamRecoveryState.IsWaitingRecover and PrevState == UE4.ETeamRecoveryState.Dying then
    self:HandleOnCharWaitingResurgence(Eid)
  elseif State == UE4.ETeamRecoveryState.Alive and PrevState == UE4.ETeamRecoveryState.IsWaitingRecover then
    self:HandleOnTeammateRecovery(Eid)
  end
end

function M:FinishDialogue()
  if self.bCleared then
    return
  end
  self:Clear()
  self:TryEndFlowGraph()
  self:TryFireEndingCallback()
end

function M:ClearUI()
  CollapseUIDialoguePanel(self.UI)
end

function M:OnExceptionInterruptedBySTL()
  DebugPrint("NewBossTalkTask:OnExceptionInterruptedBySTL")
  TalkUtils:RemovePlayerInvincible()
  self:Clear()
  self.NodeFinished_Callback = nil
end

function M:OnInterrupted()
  DebugPrint("NewBossTalkTask:OnInterrupted")
  self.bHasInterrupted = true
  self:StopTalkFlow()
  self:Clear()
end

function M:OnPaused()
  DebugPrint("NewBossTalkTask:对话被暂停", self)
  self:PauseAllTimers(true)
  self:PauseTalkFlow()
end

function M:OnPauseResumed()
  if self.bHasInterrupted then
    return
  end
  DebugPrint("NewBossTalkTask:对话暂停恢复", self)
  self:PauseAllTimers(false)
  self:ResumeTalkFlow()
end

return M
