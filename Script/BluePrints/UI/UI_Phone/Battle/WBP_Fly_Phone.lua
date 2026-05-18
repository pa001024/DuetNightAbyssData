require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local SuyiRoleId = 1504
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnReleased)
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.bFlyActive = false
  self.bJumpPressed = false
  self.bWasInAir = false
  local IconMat = self.Image_Main:GetDynamicMaterial()
  IconMat:SetTextureParameterValue("IconMap", self.Icon_Fly)
  self:RefreshRoleVisible()
  if self:IsSuyi() then
    self.OwnerPlayer.bJetJump = true
  end
  self:AddDispatcher(EventID.UpdateMainPlayerSecondSp, self, self.OnUpdateSecondSp)
end

function M:ReleaseJumpHold(Reason)
  if not self.bJumpPressed then
    return
  end
  DebugPrint("[Fly] ReleaseJumpHold:", Reason)
  self.bJumpPressed = false
  self.OwnerPanel:TryToStopTargetCommand("Jump", true)
end

function M:OnPressed()
  if not self:IsSuyi() then
    return
  end
  if not IsValid(self.OwnerPlayer) then
    return
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
  local bFlying = self:CheckIsSkillFlying()
  local bInAir = self.OwnerPlayer.IsInAir
  DebugPrint("[Fly] OnPressed bFlying:", bFlying, "bJumpPressed:", self.bJumpPressed, "IsInAir:", bInAir)
  if bFlying then
    self:ReleaseJumpHold("PressedWhileFlying")
    return
  end
  if self.bJumpPressed and bInAir then
    DebugPrint("[Fly] Ignore repeated press while airborne")
    return
  end
  if self.bJumpPressed then
    self:ReleaseJumpHold("RestartBeforePressed")
  end
  self.bJumpPressed = true
  self.OwnerPanel:TryToPlayTargetCommand("Jump", true)
end

function M:OnReleased()
  if not self:IsSuyi() then
    return
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press, EUMGSequencePlayMode.Reverse)
end

function M:IsSuyi()
  if not IsValid(self.OwnerPlayer) then
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  end
  return IsValid(self.OwnerPlayer) and self.OwnerPlayer.CurrentRoleId == SuyiRoleId
end

function M:CheckIsSkillFlying()
  if not IsValid(self.OwnerPlayer) then
    return false
  end
  local Movement = self.OwnerPlayer:GetMovementComponent()
  if not Movement then
    return false
  end
  return Movement:IsJetJumpValid()
end

function M:RefreshRoleVisible()
  if self:IsSuyi() then
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnUpdateSecondSp(SecondSp, OwnerActor)
  if OwnerActor ~= self.OwnerPlayer then
    return
  end
  if SecondSp > 0 then
    return
  end
  if self.bJumpPressed and not self:CheckIsSkillFlying() then
    self:ReleaseJumpHold("SecondSpZero")
  end
end

function M:UpdateButtonInTimer()
  if not IsValid(self.OwnerPlayer) then
    return
  end
  local bInAir = self.OwnerPlayer.IsInAir
  local bFlying = self:CheckIsSkillFlying()
  if self.bJumpPressed and not bFlying and self.bWasInAir and not bInAir then
    self:ReleaseJumpHold("LandedWithoutFlying")
  end
  self.bWasInAir = bInAir
  if self.bFlyActive == bFlying then
    return
  end
  self.bFlyActive = bFlying
  if bFlying then
    DebugPrint("[Fly] Enter flying")
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Acceleration_In)
    self.OwnerPanel:OnEnterSkillFly()
  else
    self:ReleaseJumpHold("ExitFlyingState")
    DebugPrint("[Fly] Exit flying")
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Acceleration_Out)
    self.OwnerPanel:OnExitSkillFly()
  end
end

function M:OnStartMountFly()
end

function M:OnStopMountFly()
end

AssembleComponents(M)
return M
