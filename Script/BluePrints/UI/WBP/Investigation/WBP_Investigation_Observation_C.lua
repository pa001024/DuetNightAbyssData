require("UnLua")
local InvestigationUtils = require("BluePrints.UI.WBP.Investigation.InvestigationUtils")
local TalkAudioComp_C = require("BluePrints.Story.Talk.Controller.TalkAudioComp")
local EPanelState = InvestigationUtils.EPanelState
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.WBP.Investigation.Components.ObservationInputComponent",
  "BluePrints.UI.WBP.Investigation.Components.ObservationTalkComponent"
}
local Popup_Observation_Exit = 100419
local DefalutInfoTitle = "UI_Observation_InfoTitle"
local DisableInputTag = "InvestigationObservation"
local HidePlayerTag = "InvestigationObservation"
local AimScreenRadius = 180
local AimSnapFactor = 0.1
local DirectBlendOutTime = 1
local SequenceBlendOutTime = 0.3

function M:Construct()
  M.Super.Construct(self)
  self.CheckpointCompleted = {}
  self.SpawnedCheckpoints = {}
  self.PanelState = EPanelState.Normal
  self.Btn_Finish:SetText(GText("UI_Observation_Finsh"))
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  local SequencePath, PauseMark, bHidePlayer, InfoTitle, CameraMoveSpeed, CloseCallback = ...
  self.SequencePath = SequencePath or ""
  self.PauseMark = PauseMark or ""
  self.bHidePlayer = bHidePlayer
  self.InfoTitle = InfoTitle
  self.CameraMoveSpeed = math.clamp(CameraMoveSpeed or 1, 0.01, 2)
  self.CloseCallback = CloseCallback
  self.bExitPopupOpened = false
  self.Result = {Success = false, Reason = "Init"}
  self.CheckPointsVisible = true
  self.bAutoPlay = false
  self:PlayInAudio()
  self:InitObservationInput()
  self:InitPanelState()
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
  self.SequenceCamera = nil
  self.ObserverCamera = nil
  self.bSequencePausedHandled = false
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
  self.SequencePlayer.OnFinished:Add(self, self.OnSequenceFinished)
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
  if TargetActor:IsA(AObservationPoint) then
    table.insert(self.SpawnedCheckpoints, TargetActor)
    self:SetSingleCheckpointVisible(TargetActor, self.CheckPointsVisible)
  end
end

function M:OnSequencePaused()
  if self.bSequencePausedHandled then
    return
  end
  if not IsValid(self.SequencePlayer) then
    self:CloseWithResult(false, "SequencePlayerInvalid")
    return
  end
  self.bSequencePausedHandled = true
  self.SequencePlayer.OnPause:Remove(self, self.OnSequencePaused)
  self.SequencePlayer.OnFinished:Remove(self, self.OnSequenceFinished)
  self.SequencePlayer:SetDisableCameraCuts(true)
  self:AddTimer(0, function()
    self:EnterObservation()
  end, false, nil, nil, true)
end

function M:OnSequenceFinished()
  self:CloseWithResult(false, "SequenceFinishedBeforeObservation")
end

function M:EnterObservation()
  if self.bClosing then
    return
  end
  if 0 == #self.SpawnedCheckpoints then
    self:CloseWithResult(false, "SequenceObservationPointNotFound")
    return
  end
  local ViewTarget = self.PlayerController and self.PlayerController:GetViewTarget() or nil
  if not IsValid(ViewTarget) or not ViewTarget:IsA(ACameraActor) then
    self:CloseWithResult(false, "SequenceCameraNotFound")
    return
  end
  self.SequenceCamera = ViewTarget
  self.ObserverCamera = URuntimeCommonFunctionLibrary.DuplicateActor(self.SequenceCamera)
  if not IsValid(self.ObserverCamera) then
    self:CloseWithResult(false, "ObserverCameraDuplicateFailed")
    return
  end
  self.ObserverCamera:K2_SetActorTransform(self.SequenceCamera:GetTransform(), false, nil, false)
  self:InitObserveUI()
end

function M:InitObserveUI()
  if not IsValid(self.ObserverCamera) then
    self:CloseWithResult(false, "SequenceCameraNotFound")
    return
  end
  if self.PlayerController then
    USequenceFunctionLibrary.SetViewTarget(self.PlayerController, self.ObserverCamera)
  end
  if self.bHidePlayer then
    self:HidePlayer(true)
  end
  self.Result = {Success = false, Reason = "Observing"}
  self:InitInfoPanel()
  self:ChangeAutoPlayUI(false)
  self:PlayAnimation(self.In)
end

function M:HidePlayer(bHide)
  if not IsValid(self.Player) then
    return
  end
  self.Player:SetActorHideTag(HidePlayerTag, bHide, false, true)
  local BattlePet = self.Player:GetBattlePet()
  if IsValid(BattlePet) then
    BattlePet:HideBattlePet(HidePlayerTag, bHide)
  end
end

function M:InitPanelState()
  self.PanelState = EPanelState.Loading
  self:ApplyPanelState()
end

function M:InitBindings()
  self.Btn_Finish:UnBindEventOnClickedByObj(self)
  self.Btn_Finish:BindEventOnClicked(self, self.OnCompleteClicked)
  self.Btn_Background.OnClicked:Clear()
  self.Btn_Background.OnClicked:Add(self, self.OnBackgroundClicked)
  self:UnbindAllFromAnimationFinished(self.Out)
  self:UnbindAllFromAnimationFinished(self.Lock_In)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
  self:BindToAnimationFinished(self.Lock_In, {
    self,
    self.OnLockInAnimationFinished
  })
end

function M:ApplyPanelState(bUseCamera)
  local State = self.PanelState
  self:UpdateKeyState(State, bUseCamera)
  if State == EPanelState.Dialog then
    if bUseCamera then
      self.VB_Task:SetVisibility(ESlateVisibility.Collapsed)
      self.Panel_Aim:SetVisibility(ESlateVisibility.Collapsed)
      self:SetCheckpointWidgetsVisible(false)
    else
      self.VB_Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Panel_Aim:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self:SetCheckpointWidgetsVisible(true)
    end
    self.Panel_SimpleTalk:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Finish:SetVisibility(ESlateVisibility.Collapsed)
    return
  elseif State == EPanelState.Normal then
    self.VB_Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Panel_SimpleTalk:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Finish:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Aim:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:SetCheckpointWidgetsVisible(true)
    return
  elseif State == EPanelState.Completed then
    self.VB_Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Panel_SimpleTalk:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Finish:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Aim:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:SetCheckpointWidgetsVisible(true)
    return
  end
  self:SetCheckpointWidgetsVisible(false)
  self.VB_Task:SetVisibility(ESlateVisibility.Collapsed)
  self.Panel_SimpleTalk:SetVisibility(ESlateVisibility.Collapsed)
  self.Btn_Finish:SetVisibility(ESlateVisibility.Collapsed)
  self.Panel_Aim:SetVisibility(ESlateVisibility.Collapsed)
end

function M:SetPanelState(State, bUseCamera)
  local LastState = self.PanelState
  if LastState == State then
    return
  end
  self.PanelState = State
  if State ~= EPanelState.Hidden then
    self.StateBeforeHide = State
  end
  self:ApplyPanelState(bUseCamera)
  if LastState == EPanelState.Loading and State ~= EPanelState.Loading then
    self:StopAnimation(self.Hide_Out)
    self:PlayAnimation(self.Hide_In)
  end
  if LastState == EPanelState.Dialog and State ~= EPanelState.Dialog then
    self:StopAnimation(self.Talk_In)
    self:PlayAnimation(self.Talk_Out)
  elseif LastState ~= EPanelState.Dialog and State == EPanelState.Dialog then
    self:StopAnimation(self.Talk_Out)
    self:PlayAnimation(self.Talk_In)
  elseif LastState == EPanelState.Hidden and State ~= EPanelState.Hidden then
    self:StopAnimation(self.Hide_Out)
    self:PlayAnimation(self.Hide_In)
  elseif LastState ~= EPanelState.Hidden and State == EPanelState.Hidden then
    self:StopAnimation(self.Hide_In)
    self:PlayAnimation(self.Hide_Out)
  end
end

function M:TogglePanelHidden()
  if self.PanelState == EPanelState.Hidden then
    self:SetPanelState(self.StateBeforeHide or EPanelState.Normal)
  else
    self:ResetBtnAnimations()
    self:UnlockCurrentCheckpoint()
    self:SetPanelState(EPanelState.Hidden)
  end
end

function M:SetCheckpointWidgetsVisible(bVisible)
  if self.CheckPointsVisible == bVisible then
    return
  end
  self.CheckPointsVisible = bVisible
  if not self.SpawnedCheckpoints then
    return
  end
  for _, CheckPoint in ipairs(self.SpawnedCheckpoints) do
    self:SetSingleCheckpointVisible(CheckPoint, bVisible)
  end
end

function M:SetSingleCheckpointVisible(CheckPoint, bVisible)
  if not IsValid(CheckPoint) or not IsValid(CheckPoint.WidgetComponent) then
    return
  end
  local UserWidget = CheckPoint.WidgetComponent:GetUserWidgetObject()
  if not IsValid(UserWidget) then
    return
  end
  UserWidget:SetVisibility(bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:InitInfoPanel()
  local TotalCount = #self.SpawnedCheckpoints
  self.CompletedCount = 0
  self.CheckpointCompleted = {}
  self.CheckpointDialogues = {}
  self.CurrentAimCheckpointIndex = nil
  self.Text_TaskContent:SetText(GText(self.InfoTitle or DefalutInfoTitle) .. "(" .. self.CompletedCount .. "/" .. TotalCount .. ")")
  self:SetPanelState(EPanelState.Normal)
  self.List_Task:ClearListItems()
  for i, CheckPoint in ipairs(self.SpawnedCheckpoints) do
    CheckPoint:SetStateNormal()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Info = CheckPoint.Description
    self.CheckpointDialogues[i] = CheckPoint.DialogueId
    self.List_Task:AddItem(Content)
  end
  self.List_Task:RequestPlayEntriesAnim()
end

function M:RefreshInfoTitle()
  local TotalCount = #self.SpawnedCheckpoints
  self.Text_TaskContent:SetText(GText(self.InfoTitle or DefalutInfoTitle) .. "(" .. self.CompletedCount .. "/" .. TotalCount .. ")")
end

function M:Tick(MyGeometry, InDeltaTime)
  self:RefreshCheckpointAimState()
end

function M:RefreshCheckpointAimState()
  if not self.PlayerController then
    return
  end
  if self.PanelState ~= EPanelState.Normal and self.PanelState ~= EPanelState.Completed then
    return
  end
  local ViewportSize = UE4.UWidgetLayoutLibrary.GetViewportSize(self)
  local CenterX = ViewportSize.X * 0.5
  local CenterY = ViewportSize.Y * 0.5
  local BestIndex, BestDistSq
  local ViewportScale = UWidgetLayoutLibrary.GetViewportScale(GWorld.GameInstance)
  local ViewportRadius = AimScreenRadius * ViewportScale
  local MaxDistSq = ViewportRadius * ViewportRadius
  for i, CheckPoint in ipairs(self.SpawnedCheckpoints) do
    if not self.CheckpointCompleted[i] then
      local ScreenPos = FVector2D()
      if CheckPoint:GetScreenPosition(ScreenPos) then
        local DX = ScreenPos.X - CenterX
        local DY = ScreenPos.Y - CenterY
        local DistSq = DX * DX + DY * DY
        if MaxDistSq >= DistSq and (not BestDistSq or BestDistSq > DistSq) then
          BestIndex = i
          BestDistSq = DistSq
        end
      end
    end
  end
  if self.CurrentAimCheckpointIndex == BestIndex then
    return
  end
  self:UnlockCurrentCheckpoint()
  self.CurrentAimCheckpointIndex = BestIndex
  if BestIndex then
    self.SpawnedCheckpoints[BestIndex]:SetStateTargetedNotCollected()
    self:PlayLockAudio()
    self:PlayLockAnimation()
  end
end

function M:UnlockCurrentCheckpoint()
  if self.CurrentAimCheckpointIndex then
    local CheckPoint = self.SpawnedCheckpoints[self.CurrentAimCheckpointIndex]
    if CheckPoint and not self.CheckpointCompleted[self.CurrentAimCheckpointIndex] then
      CheckPoint:SetStateNormal()
      self:PlayUnlockAnimation()
    end
    self.CurrentAimCheckpointIndex = nil
  end
end

function M:PlayLockAnimation()
  self:StopAnimation(self.UnLock)
  self:StopAnimation(self.Lock_In)
  self:StopAnimation(self.Lock_Loop)
  self:PlayAnimation(self.Lock_In)
end

function M:OnLockInAnimationFinished()
  if self.CurrentAimCheckpointIndex then
    self:PlayAnimation(self.Lock_Loop, 0, 0)
  end
end

function M:PlayUnlockAnimation()
  self:StopAnimation(self.UnLock)
  self:StopAnimation(self.Lock_In)
  self:StopAnimation(self.Lock_Loop)
  self:PlayAnimation(self.UnLock)
end

function M:SnapAimToCheckpoint(PlayerMoveDeltaX, PlayerMoveDeltaY)
  if self.PanelState ~= EPanelState.Normal and self.PanelState ~= EPanelState.Completed then
    return
  end
  local CheckpointIndex = self.CurrentAimCheckpointIndex
  if not CheckpointIndex then
    return
  end
  local CheckPoint = self.SpawnedCheckpoints[CheckpointIndex]
  local ScreenPos = FVector2D()
  if not CheckPoint:GetScreenPosition(ScreenPos) then
    return
  end
  local ViewportSize = UE4.UWidgetLayoutLibrary.GetViewportSize(self)
  local CenterX = ViewportSize.X * 0.5
  local CenterY = ViewportSize.Y * 0.5
  local DX = ScreenPos.X - CenterX
  local DY = ScreenPos.Y - CenterY
  local SnapDX = DX * AimSnapFactor
  local SnapDY = -DY * AimSnapFactor
  if math.abs(DX) < 1 and math.abs(DY) < 1 then
    return
  end
  if self.CachedForbidSnap then
    return
  end
  if PlayerMoveDeltaX and PlayerMoveDeltaY then
    local Dot = PlayerMoveDeltaX * SnapDX + PlayerMoveDeltaY * SnapDY
    if Dot < 0 then
      self.CachedForbidSnap = true
      self:AddTimer(0.15, function()
        self.CachedForbidSnap = nil
      end, nil, nil, nil, true)
      return
    end
  end
  self:ProcessRotateInput(SnapDX, SnapDY)
end

function M:EnterCheckpointObserveView(CheckpointIndex)
  local CheckPoint = self.SpawnedCheckpoints[CheckpointIndex]
  if not self.PlayerController or not IsValid(CheckPoint) then
    return false
  end
  if CheckPoint.UseCamera == false then
    return false
  end
  local CameraComp = CheckPoint:GetComponentByClass(UCameraComponent)
  if not IsValid(CameraComp) then
    return false
  end
  local BlendInTime = CheckPoint.BlendInTime
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.PlayerController, CheckPoint, BlendInTime, UE4.EViewTargetBlendFunction.VTBlend_Linear)
  return true, BlendInTime
end

function M:ClearObserveBlendTimer()
  if self.ObserveBlendTimer then
    self:RemoveTimer(self.ObserveBlendTimer)
    self.ObserveBlendTimer = nil
  end
end

function M:ExitCheckpointObserveView(CheckPoint, EndCallback)
  if not self.PlayerController or not IsValid(self.ObserverCamera) then
    return
  end
  local BlendOutTime = CheckPoint and CheckPoint.BlendOutTime
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.PlayerController, self.ObserverCamera, BlendOutTime, UE4.EViewTargetBlendFunction.VTBlend_Linear)
  if EndCallback then
    self:AddTimer(BlendOutTime, EndCallback, nil, nil, nil, true)
  end
end

function M:ObserveCurrentCheckpoint()
  local CheckpointIndex = self.CurrentAimCheckpointIndex
  if not CheckpointIndex then
    return
  end
  self:ObserveCheckpoint(CheckpointIndex)
end

function M:ObserveCheckpoint(CheckpointIndex)
  if not CheckpointIndex or CheckpointIndex < 1 or CheckpointIndex > #self.SpawnedCheckpoints then
    return
  end
  if self.CheckpointCompleted[CheckpointIndex] then
    return
  end
  self:ClearObserveBlendTimer()
  local bEnterObserveView, BlendInTime = self:EnterCheckpointObserveView(CheckpointIndex)
  if bEnterObserveView then
    self:SetPanelState(EPanelState.Loading)
    self.ObserveBlendTimer = self:AddTimer(BlendInTime, function()
      self.ObserveBlendTimer = nil
      self:StartObeserving(CheckpointIndex, true)
    end, false, 0, nil, true)
    return
  end
  self:StartObeserving(CheckpointIndex)
end

function M:OnObserveCompleted()
  local CheckpointIndex = self.ObservingCheckpointIndex
  if not CheckpointIndex then
    return
  end
  self.CompletedCount = self.CompletedCount + 1
  self.CheckpointCompleted[CheckpointIndex] = true
  local CheckPoint = self.SpawnedCheckpoints[CheckpointIndex]
  
  local function Callback()
    if CheckPoint then
      CheckPoint:SetStateCollected()
      self:PlayCheckedAudio()
    end
    local ItemWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Task, CheckpointIndex - 1)
    if IsValid(ItemWidget) then
      ItemWidget:SetCompleted()
    end
    self.ObservingCheckpointIndex = nil
    if self.CurrentAimCheckpointIndex == CheckpointIndex then
      self.CurrentAimCheckpointIndex = nil
      self:PlayUnlockAnimation()
    end
    self:RefreshInfoTitle()
    local TotalCount = #self.SpawnedCheckpoints
    local bAllCompleted = TotalCount <= self.CompletedCount
    self.Result.Reason = bAllCompleted and "Completed" or "Observing"
    self:SetPanelState(bAllCompleted and EPanelState.Completed or EPanelState.Normal)
  end
  
  if CheckPoint and true ~= CheckPoint.UseCamera then
    Callback()
    return
  end
  self:SetPanelState(EPanelState.Loading)
  self:ExitCheckpointObserveView(CheckPoint, Callback)
end

function M:StartObeserving(CheckpointIndex, bUseCamera)
  if not CheckpointIndex or CheckpointIndex < 1 or CheckpointIndex > #self.SpawnedCheckpoints then
    return
  end
  if self.CheckpointCompleted[CheckpointIndex] then
    return
  end
  self.ObservingCheckpointIndex = CheckpointIndex
  local DialogueId = self.CheckpointDialogues[CheckpointIndex]
  if DialogueId and DataMgr.Dialogue[DialogueId] then
    self:SetPanelState(EPanelState.Dialog, bUseCamera)
    self:PlayDialogue(DialogueId, bUseCamera)
    return
  end
  self:OnObserveCompleted()
end

function M:OnExitClicked()
  self.bExitPopupOpened = true
  UIManager(self):ShowCommonPopupUI(Popup_Observation_Exit, {
    RightCallbackFunction = function()
      self:OnConfirmedExit()
    end,
    OnCloseCallbackFunction = function()
      self.bExitPopupOpened = false
    end
  })
end

function M:OnConfirmedExit()
  self:CloseWithResult(false, "Cancel")
end

function M:OnCompleteClicked()
  self:CloseWithResult(true, "Complete")
end

function M:IsAutoPlay()
  return self.bAutoPlay
end

function M:SwitchAutoPlay()
  self:SetAutoPlay(not self.bAutoPlay)
end

function M:ChangeAutoPlayUI(bAutoPlay)
end

function M:OnAutoPlayClicked()
  self:SwitchAutoPlay()
end

function M:SetAutoPlay(bAutoPlay)
  if self.bAutoPlay == bAutoPlay then
    return
  end
  self.bAutoPlay = bAutoPlay
  self:ChangeAutoPlayUI(bAutoPlay)
  if bAutoPlay then
    self:OnAutoPlayEnabled()
  end
end

function M:OnSkipClicked()
  self:SkipTalkFlow()
end

function M:OnContinueClicked()
  self:SkipCurrentDialogue()
end

function M:OnBackgroundClicked()
  self:SkipCurrentDialogue()
end

function M:OnAimClicked()
  self:ObserveCurrentCheckpoint()
end

function M:UpdateKeyState(State, bUseCamera)
end

function M:ResetBtnAnimations()
  self.Btn_Finish:OnBtnReleased()
end

function M:PlayInfoItemOutAnimation()
  for i = 1, #self.SpawnedCheckpoints do
    local ItemWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Task, i - 1)
    if IsValid(ItemWidget) then
      ItemWidget:PlayOut()
    end
  end
end

function M:CreateTalkAudioComponent()
  self.TalkAudioComp = TalkAudioComp_C.New()
end

function M:CloseWithResult(Success, Reason)
  if self.bClosing then
    return
  end
  self.bClosing = true
  if IsValid(self.SequencePlayer) then
    self.SequencePlayer.OnObjectSpawnedEvent:Remove(self, self.OnSequenceObjectSpawned)
    self.SequencePlayer.OnPause:Remove(self, self.OnSequencePaused)
    self.SequencePlayer.OnFinished:Remove(self, self.OnSequenceFinished)
  end
  self.Result = self.Result or {}
  self.Result.Success = Success and true or false
  self.Result.Reason = Reason or ""
  self:PlayInfoItemOutAnimation()
  self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
  self:Close()
end

function M:Interrupt()
  if self.bClosing then
    return
  end
  self.Result = nil
  self.CloseCallback = nil
  self:Close()
end

function M:OnEndClose()
  local Result = self.Result or {}
  local CloseCallback = self.CloseCallback
  local bExecuted = false
  
  local function EndCallback()
    if bExecuted then
      return
    end
    bExecuted = true
    if CloseCallback then
      CloseCallback(Result.Success, Result.Reason)
    end
  end
  
  self:TryResumeCamera(EndCallback)
  self:Cleanup()
end

function M:TryResumeCamera(EndCallback)
  local bResumingSequence = self:ResumeSequenceView(EndCallback)
  if not bResumingSequence then
    M.ResumeOringinalView(self.PlayerController, self.OriginalViewTarget, EndCallback)
    if IsValid(self.SequencePlayer) then
      self.SequencePlayer:SetDisableCameraCuts(false)
      self.SequencePlayer:Stop()
    end
    if IsValid(self.ObserverCamera) then
      self.ObserverCamera:K2_DestroyActor()
    end
    if IsValid(self.SequenceActor) then
      self.SequenceActor:K2_DestroyActor()
    end
  end
end

function M:ResumeSequenceView(EndCallback)
  if not (IsValid(self.PlayerController) and IsValid(self.SequenceCamera) and IsValid(self.SequencePlayer)) or not IsValid(self.SequenceActor) then
    return false
  end
  local SequencePlayer = self.SequencePlayer
  local SequenceActor = self.SequenceActor
  local ObserverCamera = self.ObserverCamera
  local PlayerController = self.PlayerController
  local OriginalViewTarget = self.OriginalViewTarget
  USequenceFunctionLibrary.SetViewTargetWithBlend(PlayerController, self.SequenceCamera, SequenceBlendOutTime, UE4.EViewTargetBlendFunction.VTBlend_Linear, 2, true)
  GWorld.GameInstance:AddTimer(SequenceBlendOutTime, function()
    if IsValid(SequencePlayer) and IsValid(SequenceActor) then
      SequencePlayer:SetDisableCameraCuts(false)
      local bSequenceEnded = false
      
      local function OnSequenceEnded()
        if bSequenceEnded then
          return
        end
        bSequenceEnded = true
        if IsValid(SequenceActor) then
          SequenceActor:K2_DestroyActor()
        end
        if EndCallback then
          EndCallback()
        end
      end
      
      SequencePlayer.OnFinished:Add(SequenceActor, OnSequenceEnded)
      SequencePlayer.OnStop:Add(SequenceActor, OnSequenceEnded)
      SequencePlayer:Play()
    else
      M.ResumeOringinalView(PlayerController, OriginalViewTarget, EndCallback)
    end
    if IsValid(ObserverCamera) then
      ObserverCamera:K2_DestroyActor()
    end
  end, false, nil, nil, true)
  return true
end

function M.ResumeOringinalView(PlayerController, ViewTarget, EndCallback)
  if not IsValid(PlayerController) then
    if EndCallback then
      EndCallback()
    end
    return
  end
  local Target = IsValid(ViewTarget) and ViewTarget or PlayerController:K2_GetPawn()
  USequenceFunctionLibrary.SetViewTargetWithBlend(PlayerController, Target, DirectBlendOutTime, UE4.EViewTargetBlendFunction.VTBlend_Linear)
  if EndCallback then
    GWorld.GameInstance:AddTimer(DirectBlendOutTime, EndCallback, nil, nil, nil, true)
  end
end

function M:Cleanup()
  self.bExitPopupOpened = nil
  self.bAutoPlay = nil
  self:ClearObserveBlendTimer()
  self:UnbindAllFromAnimationFinished(self.Out)
  self:UnbindAllFromAnimationFinished(self.Lock_In)
  self:ClearTalkFlow()
  self.Btn_Finish:UnBindEventOnClickedByObj(self)
  self.Btn_Background.OnClicked:Clear()
  self:SetCheckpointWidgetsVisible(false)
  if self.bHidePlayer then
    self:HidePlayer(false)
  end
  if IsValid(self.Player) then
    self.Player:RemoveDisableInputTag(DisableInputTag)
  end
  self.SequenceActor = nil
  self.SequencePlayer = nil
  self.SequenceCamera = nil
  self.OriginalViewTarget = nil
  self.ObserverCamera = nil
  self.SpawnedCheckpoints = nil
  self.Result = nil
  self.CloseCallback = nil
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  if TalkContext and TalkContext.TalkTimerManager then
    TalkContext.TalkTimerManager:ClearTimer(self)
  end
  self:StopInAudio()
end

function M:PlayInAudio()
  AudioManager(self):PlayUISound(self, "event:/ui/common/observe_start", "ObservationIn", nil)
end

function M:StopInAudio()
  AudioManager(self):SetEventSoundParam(self, "ObservationIn", {ToEnd = 1})
end

function M:PlayLockAudio()
  AudioManager(self):PlayUISound(self, "event:/ui/common/observe_hint_unlock", nil, nil)
end

function M:PlayCheckedAudio()
  AudioManager(self):PlayUISound(self, "event:/ui/common/observe_hint_checked", nil, nil)
end

AssembleComponents(M)
return M
