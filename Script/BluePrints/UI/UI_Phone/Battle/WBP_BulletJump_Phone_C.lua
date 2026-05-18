require("UnLua")
local EMCache = require("EMCache.EMCache")
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
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
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

function M:ButtonBulletJumpDown(Index, StartPos)
  if self.OwnerPanel and self.OwnerPanel.Fly and self.OwnerPanel.Fly:CheckIsSkillFlying() then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Mechanism_CannotHook"))
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  self.HasAutoBulletJump = EMCache:Get("AutoBulletJump")
  self.HasBulletJumpCancel = EMCache:Get("BulletJumpCamRotate")
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
  if self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent and self.OwnerPlayer:CheckBulletJumpConditionForUI() then
    self.OwnerPlayer.CameraControlComponent:PushCameraStateFromPreset("BulletJumpAim", 0.2, 3)
  end
end

function M:ButtonBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
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
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  if self.HasBulletJumpCancel then
    self.OwnerPanel:SetBulletJumpOccupied(false, self)
    if self.IsOccupied then
      return
    end
    EventManager:FireEvent(EventID.OnQuitBulletJumpAim)
    self.OwnerPlayer:SetCanInteractiveTrigger(true, "BulletJumpAim")
    self:ChangeBattleWheelState(true)
    if self.HasAutoBulletJump then
      self:StopAutoRetryTimer()
      self.IsBtnDown = false
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    else
      if ScreenSpacePos and USlateBlueprintLibrary.IsUnderLocation(self.CancelBtn:GetCachedGeometry(), ScreenSpacePos) then
        EMUIAnimationSubsystem:EMStopAnimation(self.CancelBtn, self.CancelBtn.Loop)
        self.IsBtnDown = false
      elseif not ScreenSpacePos then
        self.IsBtnDown = false
      end
      if not self.IsBtnDown then
        if self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent then
          self.OwnerPlayer.CameraControlComponent:PopCameraState("BulletJumpAim")
        end
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        return
      end
      self.IsBtnDown = false
      self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    end
  elseif self.HasAutoBulletJump then
    self:StopAutoRetryTimer()
    self.IsBtnDown = false
    EventManager:FireEvent(EventID.OnQuitBulletJumpAim)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
  else
    self.OwnerPanel:TryToStopTargetCommand("BulletJump")
  end
  if self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent then
    self.OwnerPlayer.CameraControlComponent:PopCameraState("BulletJumpAim")
  end
end

function M:ActiveBulletJump(Tag)
  CommonUtils.RemoveValue(self.InActiveTags, Tag)
  if 0 == #self.InActiveTags then
    self:SetRenderOpacity(1)
  end
end

function M:InActiveBulletJump(Tag)
  if not CommonUtils.HasValue(self.InActiveTags, Tag) then
    table.insert(self.InActiveTags, Tag)
  end
  self:SetRenderOpacity(0.5)
end

function M:UpdateButtonInTimer()
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  if self.OwnerPlayer:CheckBulletJumpConditionForUI() then
    self:ActiveBulletJump("NoTime")
  else
    self:InActiveBulletJump("NoTime")
  end
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
