require("UnLua")
local EMCache = require("EMCache.EMCache")
local TRIPLE_LONGPRESS_SEC = 0.5
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.Btn_BulletJump:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Btn_BulletJump.OnPressed:Add(self, self.OnBtnPressed)
  self.Btn_BulletJump.OnReleased:Add(self, self.OnBtnReleased)
  self.LocalTurnSpeed_Horizontal = 4.5
  self.LocalTurnSpeed_Vertical = 2
  self.InActiveTags = {}
  self.TripleJumpLocked = false
  self.TripleBulletJumpLocked = false
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.IconMat = self.Image_Main:GetDynamicMaterial()
  self:ActiveBulletJump()
end

function M:OnBtnPressed()
  if self.OwnerPanel and self.OwnerPanel.Fly and self.OwnerPanel.Fly:CheckIsSkillFlying() then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Mechanism_CannotHook"))
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function M:OnBtnReleased()
  if EMCache:Get("AutoBulletJump") then
    self:StopAutoRetryTimer()
    self.OwnerPanel:TryToStopTargetCommand("BulletJump")
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  self.OwnerPanel:TryToStopTargetCommand("BulletJump")
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
end

function M:StartAutoRetryTimer()
  if self.BulletJumpRetryTimer then
    return
  end
  self.BulletJumpRetryTimer = self:AddTimer(0.1, function()
    if not self.OwnerPlayer then
      return
    end
    self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
  end, true, 0, "BulletJumpRetryTimer", true)
end

function M:StopAutoRetryTimer()
  if self.BulletJumpRetryTimer then
    self:RemoveTimer(self.BulletJumpRetryTimer)
    self.BulletJumpRetryTimer = nil
  end
end

function M:IsTripleMode()
  return self.OwnerPanel ~= nil and self.OwnerPanel.CurrentLayout >= 7
end

function M:IsMountJumpMode()
  return self:IsTripleMode() and self.OwnerPlayer.CurMount ~= nil
end

function M:SetTripleActionLocked(SkillName, bLocked)
  if SkillName == ESkillName.Jump then
    self.TripleJumpLocked = bLocked
  elseif SkillName == ESkillName.BulletJump then
    self.TripleBulletJumpLocked = bLocked
    if bLocked then
      if self.TriplePhase == "CONTINUOUS" then
        self.OwnerPanel:TryToStopTargetCommand("BulletJump")
        self:TripleCleanupTimers()
        self:TripleCleanupCam()
        self.TriplePhase = nil
      elseif self.TriplePhase == "SQUAT" then
        self:TripleHideCancelRight()
      end
      self:StopAutoRetryTimer()
    elseif self.TriplePhase == "SQUAT" then
      self:TripleShowCancelRight()
    end
  end
end

function M:IsTripleJumpLocked()
  return self.TripleJumpLocked == true
end

function M:IsTripleBulletJumpLocked()
  return self.TripleBulletJumpLocked == true
end

function M:IsTripleButtonLocked()
  return self:IsTripleJumpLocked() and self:IsTripleBulletJumpLocked()
end

function M:ShouldShowTripleButton()
  return not self:IsTripleButtonLocked()
end

function M:TripleHideCancelRight()
  if self.OwnerPanel.BulletJumpCancelShowTimer then
    self.OwnerPanel:RemoveTimer(self.OwnerPanel.BulletJumpCancelShowTimer)
    self.OwnerPanel.BulletJumpCancelShowTimer = nil
  end
  self.OwnerPanel.BulletJumpCancelRight:SetVisibility(ESlateVisibility.Collapsed)
  self.IsUnderCancelBtn = false
  self.LastUnderCancelBtn = false
end

function M:TripleShowCancelRight()
  if self.OwnerPanel.BattleCancelRightPos then
    self.OwnerPanel.BattleCancelRightPos:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  self.OwnerPanel.BulletJumpCancelRight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:MountJumpDown()
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) then
    return
  end
  self.IsMountJumpBtnDown = true
  self.OwnerPanel:TryToPlayTargetCommand("Jump", true)
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function M:MountJumpUp()
  if not self.IsMountJumpBtnDown then
    return
  end
  self.IsMountJumpBtnDown = false
  self.OwnerPanel:TryToStopTargetCommand("Jump", true)
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
end

function M:TripleDown()
  if self:IsTripleButtonLocked() then
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) and not self:IsTripleBulletJumpLocked() then
    return
  end
  if self.TriplePhase == "SQUAT" then
    self.OwnerPanel:TryToStopTargetCommand("Slide")
  elseif self.TriplePhase == "CONTINUOUS" then
    self.OwnerPanel:TryToStopTargetCommand("BulletJump")
  end
  self:TripleCleanupTimers()
  self:TripleCleanupCam()
  self.TripleSquatMoved = false
  self.TriplePhase = nil
  self.HasBulletJumpCancel = false
  self.TripleLongPressTimer = self:AddTimer(TRIPLE_LONGPRESS_SEC, function()
    self.TripleLongPressTimer = nil
    if self:IsTripleBulletJumpLocked() then
      self:TripleStartSquat()
      return
    end
    if self.OwnerPlayer:HasMoveInput() then
      self:TripleStartContinuous()
    else
      self:TripleStartSquat()
    end
  end, false)
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function M:TripleStartSquat()
  self.TriplePhase = "SQUAT"
  self.OwnerPanel.SuppressBulletJumpSelfCancel = true
  self.OwnerPanel:TryToPlayTargetCommand("Slide")
  self.OwnerPanel.SuppressBulletJumpSelfCancel = false
  if self.TripleMovePollTimer then
    self:RemoveTimer(self.TripleMovePollTimer)
    self.TripleMovePollTimer = nil
  end
  self.TripleMovePollTimer = self:AddTimer(0.1, function()
    if self.OwnerPlayer:HasMoveInput() then
      self.TripleSquatMoved = true
    end
  end, true, 0, nil, false)
  if not self.HasBulletJumpCancel then
    self.HasBulletJumpCancel = true
    self.OwnerPanel:SetBulletJumpOccupied(true, self)
    EventManager:FireEvent(EventID.OnEnterBulletJumpAim)
    self:ChangeBattleWheelState(false)
    self.OwnerPlayer:SetCanInteractiveTrigger(false, "BulletJumpAim")
    local CamComp = self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent
    if CamComp then
      CamComp:PushCameraStateFromPreset("BulletJumpAim", 0.2, 3)
    end
    local Fly = self.OwnerPanel and self.OwnerPanel.Fly
    if IsValid(Fly) then
      self.TripleFlyPrevVis = Fly:GetVisibility()
      Fly:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  if self.OwnerPanel.BulletJumpCancelShowTimer then
    self.OwnerPanel:RemoveTimer(self.OwnerPanel.BulletJumpCancelShowTimer)
    self.OwnerPanel.BulletJumpCancelShowTimer = nil
  end
  if self:IsTripleBulletJumpLocked() then
    self:TripleHideCancelRight()
  else
    self:TripleShowCancelRight()
  end
end

function M:TripleStartContinuous()
  if self:IsTripleBulletJumpLocked() then
    return
  end
  self.TriplePhase = "CONTINUOUS"
  self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
  if self.OwnerPanel.BulletJumpCancelShowTimer then
    self.OwnerPanel:RemoveTimer(self.OwnerPanel.BulletJumpCancelShowTimer)
    self.OwnerPanel.BulletJumpCancelShowTimer = nil
  end
  if self.OwnerPanel.BattleCancelRightPos then
    self.OwnerPanel.BattleCancelRightPos:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.OwnerPanel.BulletJumpCancelRight:SetVisibility(ESlateVisibility.Collapsed)
  if not self.HasBulletJumpCancel then
    self.HasBulletJumpCancel = true
    self.OwnerPanel:SetBulletJumpOccupied(true, self)
    EventManager:FireEvent(EventID.OnEnterBulletJumpAim)
    self:ChangeBattleWheelState(false)
    self.OwnerPlayer:SetCanInteractiveTrigger(false, "BulletJumpAim")
    local CamComp = self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent
    if CamComp then
      CamComp:PushCameraStateFromPreset("BulletJumpAim", 0.2, 3)
    end
    local Fly = self.OwnerPanel and self.OwnerPanel.Fly
    if IsValid(Fly) then
      self.TripleFlyPrevVis = Fly:GetVisibility()
      Fly:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  self.TripleContinuousTimer = self:AddTimer(0.1, function()
    if self:IsTripleBulletJumpLocked() then
      self:TripleStopContinuous()
      return
    end
    if not self.OwnerPlayer:HasMoveInput() then
      self:TripleStopContinuous()
      self:TripleStartSquat()
    else
      self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
    end
  end, true, 0, nil, false)
end

function M:TripleStopContinuous()
  if self.TripleContinuousTimer then
    self:RemoveTimer(self.TripleContinuousTimer)
    self.TripleContinuousTimer = nil
  end
  if self:IsTripleBulletJumpLocked() then
    return
  end
  self.OwnerPanel:TryToStopTargetCommand("BulletJump")
end

function M:TripleCleanupCam()
  if not self.HasBulletJumpCancel then
    return
  end
  self.HasBulletJumpCancel = false
  self.OwnerPanel:SetBulletJumpOccupied(false, self)
  EventManager:FireEvent(EventID.OnQuitBulletJumpAim)
  self.OwnerPlayer:SetCanInteractiveTrigger(true, "BulletJumpAim")
  self:ChangeBattleWheelState(true)
  local CamComp = self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent
  if CamComp then
    CamComp:PopCameraState("BulletJumpAim")
  end
  if self.OwnerPanel.BattleCancelRightPos then
    self.OwnerPanel.BattleCancelRightPos:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.OwnerPanel.BulletJumpCancelRight:SetVisibility(ESlateVisibility.Collapsed)
  self.IsUnderCancelBtn = false
  self.LastUnderCancelBtn = false
  local Fly = self.OwnerPanel and self.OwnerPanel.Fly
  if IsValid(Fly) and self.TripleFlyPrevVis ~= nil then
    Fly:SetVisibility(self.TripleFlyPrevVis)
    self.TripleFlyPrevVis = nil
  end
end

function M:TripleCleanupTimers()
  if self.TripleLongPressTimer then
    self:RemoveTimer(self.TripleLongPressTimer)
    self.TripleLongPressTimer = nil
  end
  if self.TripleMovePollTimer then
    self:RemoveTimer(self.TripleMovePollTimer)
    self.TripleMovePollTimer = nil
  end
  if self.TripleContinuousTimer then
    self:RemoveTimer(self.TripleContinuousTimer)
    self.TripleContinuousTimer = nil
  end
end

function M:TripleUp(ScreenSpacePos)
  if self.HasBulletJumpCancel and self.TriplePhase == "SQUAT" and ScreenSpacePos and USlateBlueprintLibrary.IsUnderLocation(self.CancelBtn:GetCachedGeometry(), ScreenSpacePos) then
    EMUIAnimationSubsystem:EMStopAnimation(self.CancelBtn, self.CancelBtn.Loop)
    self:TripleCleanupTimers()
    self.OwnerPanel:TryToStopTargetCommand("Slide")
    self:TripleCleanupCam()
    self.TriplePhase = nil
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    return
  end
  if self.TripleLongPressTimer then
    self:TripleCleanupTimers()
    self:TripleCleanupCam()
    if not self:IsTripleJumpLocked() and not self.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) then
      self.OwnerPanel:TryToPlayTargetCommand("Jump")
      self.OwnerPanel:TryToStopTargetCommand("Jump")
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    self.TriplePhase = nil
    return
  end
  local wasActive = self.TriplePhase ~= nil
  self:TripleCleanupTimers()
  self:TripleCleanupCam()
  if self.TriplePhase == "SQUAT" then
    self.OwnerPanel:TryToStopTargetCommand("Slide")
    if not self.TripleSquatMoved and not self:IsTripleBulletJumpLocked() then
      self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
      self.OwnerPanel:TryToStopTargetCommand("BulletJump")
    end
  elseif self.TriplePhase == "CONTINUOUS" then
    self:TripleStopContinuous()
  end
  self.TriplePhase = nil
  if wasActive then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
  end
end

function M:ButtonBulletJumpDown(Index, StartPos)
  DebugPrint("[LAYOUT_DBG][BulletJump] ButtonBulletJumpDown fired! OwnerPanel.CurrentLayout=", self.OwnerPanel and self.OwnerPanel.CurrentLayout or "nil", "IsTripleMode=", self:IsTripleMode())
  if self.OwnerPanel and self.OwnerPanel.Fly and self.OwnerPanel.Fly:CheckIsSkillFlying() then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Mechanism_CannotHook"))
    return
  end
  if self:IsTripleMode() and self:IsTripleButtonLocked() then
    return
  end
  if self:IsMountJumpMode() then
    self:MountJumpDown()
    return
  end
  if self:IsTripleMode() then
    self:TripleDown()
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  self.HasAutoBulletJump = EMCache:Get("AutoBulletJump") or false
  self.HasBulletJumpCancel = EMCache:Get("BulletJumpCamRotate") or false
  if self.HasBulletJumpCancel then
    if not self.IsOccupied then
      self.OwnerPanel:SetBulletJumpOccupied(true, self)
    else
      return
    end
    EventManager:FireEvent(EventID.OnEnterBulletJumpAim)
    self:ChangeBattleWheelState(false)
    self.IsBtnDown = true
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    self.OwnerPlayer:SetCanInteractiveTrigger(false, "BulletJumpAim")
    if self.HasAutoBulletJump then
      self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
      self:StartAutoRetryTimer()
    end
  else
    self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
    if self.HasAutoBulletJump then
      self:StartAutoRetryTimer()
      EventManager:FireEvent(EventID.OnEnterBulletJumpAim)
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    else
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    end
  end
  local CamComp = self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent
  if CamComp and self.OwnerPlayer:CheckBulletJumpConditionForUI() then
    CamComp:PushCameraStateFromPreset("BulletJumpAim", 0.2, 3)
  end
end

function M:ButtonBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
  if self:IsTripleMode() and self:IsTripleButtonLocked() then
    return
  end
  if self:IsMountJumpMode() then
    return
  end
  if self:IsTripleMode() then
    if not self.HasBulletJumpCancel then
      return
    end
    local phase = self.TriplePhase
    if "SQUAT" ~= phase and "CONTINUOUS" ~= phase then
      return
    end
    if "SQUAT" == phase then
      self.IsUnderCancelBtn = USlateBlueprintLibrary.IsUnderLocation(self.CancelBtn:GetCachedGeometry(), ScreenSpacePos)
      if self.IsUnderCancelBtn and not self.LastUnderCancelBtn then
        EMUIAnimationSubsystem:EMPlayAnimation(self.CancelBtn, self.CancelBtn.Loop, EUMGSequencePlayMode.Forward, true)
      elseif not self.IsUnderCancelBtn and self.LastUnderCancelBtn then
        EMUIAnimationSubsystem:EMStopAnimation(self.CancelBtn, self.CancelBtn.Loop)
      end
      self.LastUnderCancelBtn = self.IsUnderCancelBtn
    end
    local WorldDeltaTime = UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
    self.OwnerPlayer:AddCharacterPitchInput(-self.LocalTurnSpeed_Vertical * LastDeltaDis.Y * WorldDeltaTime)
    self.OwnerPlayer:AddCharacterYawInput(self.LocalTurnSpeed_Horizontal * LastDeltaDis.X * WorldDeltaTime)
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  if not self.HasBulletJumpCancel then
    return
  end
  if self.IsOccupied then
    return
  end
  self.IsUnderCancelBtn = USlateBlueprintLibrary.IsUnderLocation(self.CancelBtn:GetCachedGeometry(), ScreenSpacePos)
  if self.IsUnderCancelBtn and not self.LastUnderCancelBtn then
    EMUIAnimationSubsystem:EMPlayAnimation(self.CancelBtn, self.CancelBtn.Loop, EUMGSequencePlayMode.Forward, true)
  elseif not self.IsUnderCancelBtn and self.LastUnderCancelBtn then
    EMUIAnimationSubsystem:EMStopAnimation(self.CancelBtn, self.CancelBtn.Loop)
  end
  self.LastUnderCancelBtn = self.IsUnderCancelBtn
  local WorldDeltaTime = UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
  self.OwnerPlayer:AddCharacterPitchInput(-self.LocalTurnSpeed_Vertical * LastDeltaDis.Y * WorldDeltaTime)
  self.OwnerPlayer:AddCharacterYawInput(self.LocalTurnSpeed_Horizontal * LastDeltaDis.X * WorldDeltaTime)
end

function M:ButtonBulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  if self:IsTripleMode() and self:IsTripleButtonLocked() then
    return
  end
  if self:IsMountJumpMode() then
    self:MountJumpUp()
    return
  end
  if self:IsTripleMode() then
    self:TripleUp(ScreenSpacePos)
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    DebugPrint("[ButtonBulletJumpUp] BulletJump inactive, early return")
    return
  end
  DebugPrint("[ButtonBulletJumpUp] BulletJump ACTIVE, HasBulletJumpCancel=", self.HasBulletJumpCancel, "HasAutoBulletJump=", self.HasAutoBulletJump)
  local CamComp = self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent
  if self.HasBulletJumpCancel then
    self.OwnerPanel:SetBulletJumpOccupied(false, self)
    if self.IsOccupied then
      if CamComp then
        CamComp:PopCameraState("BulletJumpAim")
      end
      return
    end
    EventManager:FireEvent(EventID.OnQuitBulletJumpAim)
    self.OwnerPlayer:SetCanInteractiveTrigger(true, "BulletJumpAim")
    self:ChangeBattleWheelState(true)
    if self.HasAutoBulletJump then
      local wasActive = self.BulletJumpRetryTimer ~= nil
      self:StopAutoRetryTimer()
      self.IsBtnDown = false
      if wasActive then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
      end
    else
      if ScreenSpacePos and USlateBlueprintLibrary.IsUnderLocation(self.CancelBtn:GetCachedGeometry(), ScreenSpacePos) then
        EMUIAnimationSubsystem:EMStopAnimation(self.CancelBtn, self.CancelBtn.Loop)
        self.IsBtnDown = false
      elseif not ScreenSpacePos then
        self.IsBtnDown = false
      end
      if not self.IsBtnDown then
        if CamComp then
          CamComp:PopCameraState("BulletJumpAim")
        end
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        return
      end
      self.IsBtnDown = false
      self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    end
  elseif self.HasAutoBulletJump then
    local wasActive = self.BulletJumpRetryTimer ~= nil
    self:StopAutoRetryTimer()
    self.IsBtnDown = false
    EventManager:FireEvent(EventID.OnQuitBulletJumpAim)
    if wasActive then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    end
  else
    self.OwnerPanel:TryToStopTargetCommand("BulletJump")
  end
  if CamComp then
    CamComp:PopCameraState("BulletJumpAim")
  end
end

function M:ActiveBulletJump(Tag)
  CommonUtils.RemoveValue(self.InActiveTags, Tag)
  if 0 == #self.InActiveTags then
    self:SetRenderOpacity(1)
  end
end

function M:InActiveBulletJump(Tag)
  if self:IsMountJumpMode() then
    return
  end
  if self:IsTripleMode() and self:IsTripleBulletJumpLocked() and not self:IsTripleJumpLocked() then
    return
  end
  if not CommonUtils.HasValue(self.InActiveTags, Tag) then
    table.insert(self.InActiveTags, Tag)
  end
  self:SetRenderOpacity(0.5)
end

function M:UpdateButtonInTimer()
  if self:IsMountJumpMode() then
    self:ActiveBulletJump("NoTime")
    return
  end
  if self:IsTripleMode() and self:IsTripleBulletJumpLocked() and not self:IsTripleJumpLocked() then
    self:ActiveBulletJump("NoTime")
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  if self.OwnerPlayer:CheckBulletJumpConditionForUI() then
    self:ActiveBulletJump("NoTime")
  else
    self:InActiveBulletJump("NoTime")
  end
end

function M:SyncMountFlyState()
  if not self:IsTripleMode() then
    return
  end
  local IsMounted = self.OwnerPlayer ~= nil and nil ~= self.OwnerPlayer.CurMount
  if not IsMounted then
    self:OnDisableBattleMount()
    return
  end
  self:OnEnableBattleMount()
  if self.OwnerPlayer:IsFlying() then
    self:OnStartMountFly()
  else
    self:OnStopMountFly()
  end
end

function M:OnEnableBattleMount()
  if not self:IsTripleMode() then
    return
  end
  local IconMat = self.Image_Main:GetDynamicMaterial()
  IconMat:SetScalarParameterValue("IconState", 1)
end

function M:OnDisableBattleMount()
  if not self:IsTripleMode() then
    return
  end
  local IconMat = self.Image_Main:GetDynamicMaterial()
  IconMat:SetScalarParameterValue("IconState", 0)
end

function M:OnStartMountFly()
  if not self:IsTripleMode() then
    return
  end
  local IconMat = self.Image_Main:GetDynamicMaterial()
  IconMat:SetScalarParameterValue("IconState", 2)
end

function M:OnStopMountFly()
  if not self:IsTripleMode() then
    return
  end
  local IconMat = self.Image_Main:GetDynamicMaterial()
  IconMat:SetScalarParameterValue("IconState", 1)
end

function M:ChangeBattleWheelState(bShow)
  if not self.OwnerPlayer then
    return
  end
  local PlayerController = self.OwnerPlayer:GetController()
  if not PlayerController then
    return
  end
  if not bShow then
    self.OwnerPanel:ChangeBattleWheelState(PlayerController.bEnableBattleWheel, false)
  else
    self.OwnerPanel:ChangeBattleWheelState(PlayerController.bEnableBattleWheel, PlayerController.bShowBattleWheel)
  end
end

AssembleComponents(M)
return M
