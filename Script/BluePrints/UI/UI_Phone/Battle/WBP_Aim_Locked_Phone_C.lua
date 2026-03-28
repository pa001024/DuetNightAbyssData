require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.IsShowButton = false
  self.LastShowButton = false
  self.CurButtonState = "UnLock"
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnPressed()
  self.OwnerPlayer:FlipCameraLockOnMonster()
  self.OwnerPanel:CancelBulletJump()
  if self.OwnerPlayer.CameraRotationComponent.IsCameraLookingToTarget then
    self.CurButtonState = "Lock"
    self:PlayAnimation(self.Lock)
  else
    self.CurButtonState = "Unlock"
    self:PlayAnimation(self.Unlock)
  end
end

function M:OnLockOnButtonShowChanged(IsLooking, IsShow)
  if IsLooking then
    self:PlayAnimation(self.Lock)
    self.CurButtonState = "Lock"
  else
    self:PlayAnimation(self.Unlock)
    self.CurButtonState = "UnLock"
  end
  if IsShow then
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnCameraLockOnChanged(IsLooking)
  if self.CurButtonState == "Lock" and not IsLooking then
    self.CurButtonState = "Unlock"
    self:PlayAnimation(self.Unlock)
  end
end

AssembleComponents(M)
return M
