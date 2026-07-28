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
    self:AddTimer(self.Click:GetEndTime(), function()
      if self.IsUltimateEnabled and self.CurrentUltimateAnim == self.Enable_2 then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Enable_2)
      end
    end)
  end
end

function M:OnWeaponHUDIconLoadFinish(Object)
  self.ImageMat = self.Image_Main:GetDynamicMaterial()
  if self.ImageMat then
    self.ImageMat:SetTextureParameterValue("Icon_Ranged", Object)
  end
  if self.Icon_Skill then
    self.Icon_Skill:GetDynamicMaterial():SetTextureParameterValue("Mask", nil)
  end
  self:UpdateRangeWeaponButtonByState(self.CurButtonState)
end

function M:OnPropIconLoadFinish(Object)
  self:OrganIcon(Object)
end

function M:UpdateRangeWeaponButtonByState(CurButtonState)
  if self.CurButtonState == "Ban" then
    return
  end
  self.CurButtonState = CurButtonState
  DebugPrint("Left射击键当前状态", self.CurButtonState)
  if self.CurButtonState == "Forbidden" then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Forbidden)
  elseif self.CurButtonState == "ChangeMagazine" then
    self.ImageMat:SetScalarParameterValue("IconState", 1)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
  elseif self.CurButtonState == "Normal" then
    self.ImageMat:SetScalarParameterValue("IconState", 2)
    if not self.IsUltimateEnabled then
      self:StopAllAnimations()
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    end
    self.Image_Main:SetRenderOpacity(1.0)
  elseif self.CurButtonState == "Empty" then
    self.ImageMat:SetScalarParameterValue("IconState", 0)
  end
end

function M:OnUltimateIconLoadFinish(Object)
  if not IsValid(self) or not Object then
    return
  end
  self.IsUltimateIconActive = true
  self:WeaponIcon()
  self.ImageMat = self.Image_Main:GetDynamicMaterial()
  if self.ImageMat then
    self.ImageMat:SetTextureParameterValue("Icon_Ranged", Object)
  end
  if self.Icon_Skill then
    self.Icon_Skill:GetDynamicMaterial():SetTextureParameterValue("Mask", Object)
  end
  self:UpdateRangeWeaponButtonByState(self.CurButtonState)
end

function M:LoadUltimateIcon(OwnerPlayer)
  if not OwnerPlayer or not OwnerPlayer.UltraWeapon then
    return
  end
  local WeaponId = OwnerPlayer.UltraWeapon.WeaponId
  local BattleWeaponConfig = DataMgr.BattleWeapon[WeaponId]
  if not BattleWeaponConfig or not BattleWeaponConfig.WeaponHUDIcon then
    return
  end
  local IconPath = "/Game/UI/Texture/Dynamic/Atlas/Battle/Weapon/T_" .. BattleWeaponConfig.WeaponHUDIcon
  UE.UResourceLibrary.LoadObjectAsync(self, IconPath, {
    self,
    M.OnUltimateIconLoadFinish
  })
end

function M:RestoreDefaultIcon()
  self.IsUltimateIconActive = false
end

function M:OnUltimateStateChanged(IsActive, IsType1)
  if IsActive then
    self.IsUltimateEnabled = true
    local Anim = IsType1 and self.Enable or self.Enable_2
    self.CurrentUltimateAnim = Anim
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, Anim) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, Anim)
    end
  elseif self.IsUltimateEnabled then
    self.IsUltimateEnabled = false
    local Anim = self.CurrentUltimateAnim or self.Enable_2
    EMUIAnimationSubsystem:EMStopAnimation(self, Anim)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.EnableEnd)
    self.CurrentUltimateAnim = nil
  end
end

AssembleComponents(M)
return M
