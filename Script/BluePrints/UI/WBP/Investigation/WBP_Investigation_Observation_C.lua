require("UnLua")
local InvestigationUtils = require("BluePrints.UI.WBP.Investigation.InvestigationUtils")
local EPanelState = InvestigationUtils.EPanelState
local CheckpointState = InvestigationUtils.CheckpointState
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.WBP.Investigation.Components.ObservationInputComponent",
  "BluePrints.UI.WBP.Investigation.Components.ObservationTalkComponent"
}
local Popup_Observation_Exit = 100381
local DisableInputTag = "InvestigationObservation"
local AimScreenRadius = 80
local AimSnapFactor = 0.1
local ObserveBlendTime = 1

function M:Construct()
  M.Super.Construct(self)
  self.PanelState = PanelState
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  local SequencePath, PauseMark, CloseCallback = ...
  self.SequencePath = SequencePath or ""
  self.PauseMark = PauseMark or ""
  self.CloseCallback = CloseCallback
  self.Result = {Success = false, Reason = "Init"}
  self:InitObservationInput()
  self:InitPanel()
  self:InitBindings()
  self:InitSequence()
end

function M:InitSequence()
  self.PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.Player = self.PlayerController and self.PlayerController:K2_GetPawn() or nil
  self.OriginalViewTarget = self.PlayerController and self.PlayerController:GetViewTarget() or nil
  self.SpawnedCheckpoints = {}
  self.CurrentAimCheckpointIndex = nil
  self.SequenceActor = nil
  self.SequencePlayer = nil
  self.ObserverCamera = nil
  if self.SequencePath == "" then
    self:CloseWithResult(false, "SequencePathEmpty")
    return
  end
  local Sequence = UE4.LoadObject(self.SequencePath)
  if not Sequence then
    self:CloseWithResult(false, "SequenceLoadFailed")
    return
  end
  local World = self:GetWorld()
  if not World then
    self:CloseWithResult(false, "WorldInvalid")
    return
  end
  self.SequenceActor = World:SpawnActor(ALevelSequenceActor)
  if not IsValid(self.SequenceActor) then
    self:CloseWithResult(false, "SequenceActorSpawnFailed")
    return
  end
  self.SequenceActor:SetSequence(Sequence)
  self.SequencePlayer = self.SequenceActor:GetSequencePlayer()
  if not IsValid(self.SequencePlayer) then
    self:CloseWithResult(false, "SequencePlayerInvalid")
    return
  end
  if IsValid(self.Player) then
    self.Player:AddDisableInputTag(DisableInputTag)
  end
  self.SequencePlayer.OnObjectSpawnedEvent:Add(self, self.OnSequenceObjectSpawned)
  self.SequencePlayer.OnPause:Add(self, self.OnSequencePaused)
  self:PlayToPauseMark()
end

function M:PlayToPauseMark()
  if not IsValid(self.SequencePlayer) then
    self:CloseWithResult(false, "SequencePlayerInvalid")
    return
  end
  if self.PauseMark == "" then
    self.SequencePlayer:Play()
    self:AddTimer(0, function()
      if IsValid(self.SequencePlayer) then
        self.SequencePlayer:Pause()
        self:OnSequencePaused()
      end
    end, false, nil, nil, true)
    return
  end
  local PlaybackParams = FMovieSceneSequencePlaybackParams()
  PlaybackParams.PositionType = EMovieScenePositionType.MarkedFrame
  PlaybackParams.MarkedFrame = self.PauseMark
  PlaybackParams.UpdateMethod = EUpdatePositionMethod.Play
  self.SequencePlayer:PlayTo(PlaybackParams)
end

function M:OnSequenceObjectSpawned(TargetActor)
  if not IsValid(TargetActor) then
    return
  end
  if TargetActor:IsA(ACameraActor) then
    self.ObserverCamera = TargetActor
    return
  end
  local Name = TargetActor.GetName and TargetActor:GetName() or ""
  local LowerName = string.lower(tostring(Name))
  if string.find(LowerName, "checkpoint", 1, true) then
    table.insert(self.SpawnedCheckpoints, TargetActor)
  end
end

function M:OnSequencePaused()
  if not IsValid(self.SequencePlayer) then
    self:CloseWithResult(false, "SequencePlayerInvalid")
    return
  end
  self:SetupObserverCamera()
end

function M:SetupObserverCamera()
  if not IsValid(self.ObserverCamera) then
    self:CloseWithResult(false, "SequenceCameraNotFound")
    return
  end
  if self.PlayerController then
    USequenceFunctionLibrary.SetViewTarget(self.PlayerController, self.ObserverCamera)
  end
  self.Result = {
    Success = true,
    Reason = "OK",
    Checkpoints = self:GetCheckpointTransforms()
  }
  self:InitInfoPanel()
end

function M:GetCheckpointTransforms()
  local Out = {}
  for _, CP in ipairs(self.SpawnedCheckpoints) do
    if IsValid(CP) and CP.K2_GetActorTransform then
      table.insert(Out, CP:K2_GetActorTransform())
    end
  end
  return Out
end

function M:InitPanel()
  self.PanelState = EPanelState.Loading
  self.LastPanelState = EPanelState.Normal
  self:ApplyPanelState()
end

function M:InitBindings()
  self.Btn_Complete.OnClicked:Add(self, self.OnCompleteClicked)
end

function M:ApplyPanelState()
  local State = self.PanelState
  if State == EPanelState.Dialog then
    self.Group_Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_Dialog:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Complete:SetVisibility(ESlateVisibility.Collapsed)
    self.Icon_Aim:SetVisibility(ESlateVisibility.Collapsed)
    return
  elseif State == EPanelState.Normal then
    self.Group_Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_Dialog:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Complete:SetVisibility(ESlateVisibility.Collapsed)
    self.Icon_Aim:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    return
  elseif State == EPanelState.Completed then
    self.Group_Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_Dialog:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Complete:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Icon_Aim:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    return
  end
  self.Group_Info:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Dialog:SetVisibility(ESlateVisibility.Collapsed)
  self.Btn_Complete:SetVisibility(ESlateVisibility.Collapsed)
  self.Icon_Aim:SetVisibility(ESlateVisibility.Collapsed)
end

function M:SetPanelState(State)
  self.PanelState = State
  if State ~= EPanelState.Hidden then
    self.LastPanelState = State
  end
  self:ApplyPanelState()
end

function M:TogglePanelHidden()
  if self.PanelState == EPanelState.Hidden then
    self:SetPanelState(self.LastPanelState or EPanelState.Normal)
    return
  end
  self:SetPanelState(EPanelState.Hidden)
end

function M:InitInfoPanel()
  local TotalCount = #self.SpawnedCheckpoints
  self.CompletedCount = 0
  self.CheckpointCompleted = {}
  self.CheckpointDialogues = {}
  self.CurrentAimCheckpointIndex = nil
  self.Text_InfoTitle:SetText(GText("UI_Observation_InfoTitle") .. "(" .. self.CompletedCount .. "/" .. TotalCount .. ")")
  self:SetPanelState(EPanelState.Normal)
  self.List_Info:ClearListItems()
  for i, CheckPoint in ipairs(self.SpawnedCheckpoints) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Info = CheckPoint.Info
    self.CheckpointDialogues[i] = CheckPoint.DialogueId
    self.List_Info:AddItem(Content)
  end
end

function M:RefreshInfoTitle()
  local TotalCount = #self.SpawnedCheckpoints
  self.Text_InfoTitle:SetText(GText("UI_Observation_InfoTitle") .. "(" .. self.CompletedCount .. "/" .. TotalCount .. ")")
end

function M:Tick(MyGeometry, InDeltaTime)
  self:RefreshCheckpointAimState()
  self:SnapAimToCheckpoint()
end

function M:RefreshCheckpointAimState()
  if not self.PlayerController then
    return
  end
  local ViewportSize = UE4.UWidgetLayoutLibrary.GetViewportSize(self)
  local CenterX = ViewportSize.X * 0.5
  local CenterY = ViewportSize.Y * 0.5
  local BestIndex, BestDistSq
  local MaxDistSq = AimScreenRadius * AimScreenRadius
  for i, CheckPoint in ipairs(self.SpawnedCheckpoints) do
    if not self.CheckpointCompleted[i] then
    end
  end
  if self.CurrentAimCheckpointIndex == BestIndex then
    return
  end
  if self.CurrentAimCheckpointIndex then
    local LastCheckPoint = self.SpawnedCheckpoints[self.CurrentAimCheckpointIndex]
    if not LastCheckPoint or not self.CheckpointCompleted[self.CurrentAimCheckpointIndex] then
    end
  end
  self.CurrentAimCheckpointIndex = BestIndex
  if BestIndex then
  end
end

function M:SnapAimToCheckpoint()
  if self.PanelState ~= EPanelState.Normal and self.PanelState ~= EPanelState.Completed then
    return
  end
  local CheckpointIndex = self.CurrentAimCheckpointIndex
  if not CheckpointIndex then
    return
  end
  local CheckPoint = self.SpawnedCheckpoints[CheckpointIndex]
  self:ProcessRotateInput(DX * AimSnapFactor, DY * AimSnapFactor)
end

function M:EnterCheckpointObserveView(CheckpointIndex)
  local CheckPoint = self.SpawnedCheckpoints[CheckpointIndex]
  if not self.PlayerController or not IsValid(CheckPoint) then
    return false
  end
  local CameraComp = CheckPoint:GetComponentByClass(UCameraComponent)
  if not IsValid(CameraComp) then
    return false
  end
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.PlayerController, CheckPoint, ObserveBlendTime, UE4.EViewTargetBlendFunction.VTBlend_Linear)
  return true
end

function M:ClearObserveBlendTimer()
  if self.ObserveBlendTimer then
    self:RemoveTimer(self.ObserveBlendTimer)
    self.ObserveBlendTimer = nil
  end
end

function M:ExitCheckpointObserveView()
  if not self.PlayerController or not IsValid(self.ObserverCamera) then
    return
  end
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.PlayerController, self.ObserverCamera, ObserveBlendTime, UE4.EViewTargetBlendFunction.VTBlend_Linear)
end

function M:ObserveCurrentCheckpoint()
  local CheckpointIndex = self.CurrentAimCheckpointIndex
  if not CheckpointIndex then
    return false
  end
  self:ObserveCheckpoint(CheckpointIndex)
  return true
end

function M:ObserveCheckpoint(CheckpointIndex)
  if not CheckpointIndex or CheckpointIndex < 1 or CheckpointIndex > #self.SpawnedCheckpoints then
    return
  end
  if self.CheckpointCompleted[CheckpointIndex] then
    return
  end
  self:ClearObserveBlendTimer()
  if self:EnterCheckpointObserveView(CheckpointIndex) then
    self.ObserveBlendTimer = self:AddTimer(ObserveBlendTime, function()
      self.ObserveBlendTimer = nil
      self:StartObeserving(CheckpointIndex)
    end, false, 0, nil, true)
    return
  end
  self:StartObeserving(CheckpointIndex)
end

function M:OnObserveCompleted()
  local CheckpointIndex = self.ObservingCheckpointIndex
  self.ObservingCheckpointIndex = nil
  if not CheckpointIndex then
    return
  end
  self.CompletedCount = self.CompletedCount + 1
  self.CheckpointCompleted[CheckpointIndex] = true
  if self.CurrentAimCheckpointIndex == CheckpointIndex then
    self.CurrentAimCheckpointIndex = nil
  end
  self:ExitCheckpointObserveView()
  self:RefreshInfoTitle()
  local TotalCount = #self.SpawnedCheckpoints
  local bAllCompleted = TotalCount <= self.CompletedCount
  self:SetPanelState(bAllCompleted and EPanelState.Completed or EPanelState.Normal)
  local ItemWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Info, CheckpointIndex - 1)
  if IsValid(ItemWidget) then
    ItemWidget:SetCompleted()
  end
end

function M:StartObeserving(CheckpointIndex)
  if not CheckpointIndex or CheckpointIndex < 1 or CheckpointIndex > #self.SpawnedCheckpoints then
    return
  end
  if self.CheckpointCompleted[CheckpointIndex] then
    return
  end
  self.ObservingCheckpointIndex = CheckpointIndex
  local DialogueId = self.CheckpointDialogues[CheckpointIndex]
  if DialogueId and DataMgr.Dialogue[DialogueId] then
    self:PlayDialogue(DialogueId)
    return
  end
  self:OnObserveCompleted()
end

function M:OnExitClicked()
  UIManager(self):ShowCommonPopupUI(Popup_Observation_Exit, {
    RightCallbackFunction = function()
      self:OnConfirmedExit()
    end
  })
end

function M:OnConfirmedExit()
  self:CloseWithResult(false, "Cancel")
end

function M:OnCompleteClicked()
  self:CloseWithResult(true, "Complete")
end

function M:OnSkipClicked()
  self:StopTalkFlow()
end

function M:UpdateKeyState(State)
end

function M:CloseWithResult(Success, Reason)
  self.Result = self.Result or {}
  self.Result.Success = Success and true or false
  self.Result.Reason = Reason or ""
  self.Result.Checkpoints = self:GetCheckpointTransforms()
  self:Close()
end

function M:OnEndClose()
  self:Cleanup()
  if self.CloseCallback then
    self.CloseCallback(self.Result)
    return
  end
end

function M:Cleanup()
  self:ClearObserveBlendTimer()
  self:ClearTalkFlow()
  self.Btn_Complete.OnClicked:Remove(self, self.OnCompleteClicked)
  if IsValid(self.SequencePlayer) then
    self.SequencePlayer.OnObjectSpawnedEvent:Remove(self, self.OnSequenceObjectSpawned)
    self.SequencePlayer.OnPause:Remove(self, self.OnSequencePaused)
    self.SequencePlayer:Stop()
  end
  if IsValid(self.PlayerController) then
    if IsValid(self.OriginalViewTarget) then
      USequenceFunctionLibrary.SetViewTarget(self.PlayerController, self.OriginalViewTarget)
    elseif IsValid(self.Player) then
      USequenceFunctionLibrary.SetViewTarget(self.PlayerController, self.Player)
    end
  end
  if IsValid(self.Player) then
    self.Player:RemoveDisableInputTag(DisableInputTag)
  end
  if IsValid(self.SequenceActor) then
    self.SequenceActor:K2_DestroyActor()
    self.SequenceActor = nil
  end
  self.SequencePlayer = nil
  self.ObserverCamera = nil
  self.SpawnedCheckpoints = nil
end

AssembleComponents(M)
return M
