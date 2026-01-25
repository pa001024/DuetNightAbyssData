require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.CurButtonState = "Normal"
  self.OccupiedTag = "Left"
  self.ImageMat = self.Image_Main:GetDynamicMaterial()
  self.Btn_AtkRange.OnPressed:Add(self, self.OnBtnPressed)
  self.Btn_AtkRange.OnReleased:Add(self, self.OnBtnReleased)
end

function M:OnBtnPressed()
  if not self.OwnerPanel.FireOccupied then
    self.OwnerPanel.FireOccupied = self.OccupiedTag
  else
    return
  end
  self.OwnerPanel:TryToPlayTargetCommand("Fire", true)
  if self.CurButtonState == "Ban" then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_RANGED_FORBIDDEN"))
    return
  elseif self.OwnerPlayer:CheckSkillInActive(ESkillName.Fire) or self.Cur then
    return
  end
  if self.CurButtonState ~= "Forbidden" then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
  end
end

function M:OnBtnReleased()
  if self.OwnerPanel.FireOccupied == self.OccupiedTag then
    self.OwnerPanel.FireOccupied = nil
  else
    return
  end
  self.OwnerPanel:TryToStopTargetCommand("Fire", true)
  if self.CurButtonState ~= "Forbidden" and self.CurButtonState ~= "Ban" and self.CurButtonState ~= "Empty" then
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Press) then
      EMUIAnimationSubsystem:EMStopAnimation(self, self.Press)
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
  end
end

function M:OnWeaponHUDIconLoadFinish(Object)
  self:WeaponIcon()
  self.ImageMat = self.Image_Main:GetDynamicMaterial()
  if self.ImageMat then
    self.ImageMat:SetTextureParameterValue("Icon_Ranged", Object)
  end
  self:UpdateRangeWeaponButtonByState(self.CurButtonState)
end

function M:OnPropIconLoadFinish(Object)
  self:OrganIcon(Object)
end

function M:UpdateRangeWeaponButtonByState(CurButtonState)
  self.CurButtonState = CurButtonState
  DebugPrint("Left射击键当前状态", self.CurButtonState)
  if self.CurButtonState == "Forbidden" then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Forbidden)
  elseif self.CurButtonState == "ChangeMagazine" then
    self.ImageMat:SetScalarParameterValue("IconState", 1)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
  elseif self.CurButtonState == "Normal" then
    self.ImageMat:SetScalarParameterValue("IconState", 2)
    self:StopAllAnimations()
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    self.Image_Main:SetRenderOpacity(1.0)
  elseif self.CurButtonState == "Empty" then
    self.ImageMat:SetScalarParameterValue("IconState", 0)
  end
end

AssembleComponents(M)
return M
