require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.DefaultIconPath = "/Game/UI/Texture/Static/Atlas/Battle/T_Battle_Melee.T_Battle_Melee"
  self.ImageMat = self.Image_Main:GetDynamicMaterial()
  UE.UResourceLibrary.LoadObjectAsync(self, self.DefaultIconPath, {
    self,
    M.OnWeaponHUDIconLoadFinish
  })
end

function M:OnPropEffectReplaceAttack(PropEffectId)
  local ReplaceIconPath = DataMgr.PropEffect[PropEffectId].ReplaceAttackIconPath
  if not ReplaceIconPath then
    return
  end
  UE.UResourceLibrary.LoadObjectAsync(self, ReplaceIconPath, {
    self,
    M.OnPropIconLoadFinish
  })
end

function M:OnPropEffectEndReplaceAttack()
  if self.DefaultIconPath then
    UE.UResourceLibrary.LoadObjectAsync(self, self.DefaultIconPath, {
      self,
      M.OnWeaponHUDIconLoadFinish
    })
  end
end

function M:OnWeaponHUDIconLoadFinish(Object)
  if not IsValid(self) or not Object then
    return
  end
  self:WeaponIcon()
  self.ImageMat = self.Image_Main:GetDynamicMaterial()
  if self.ImageMat then
    self.ImageMat:SetTextureParameterValue("IconMap", Object)
  end
  if self.Icon_Skill then
    self.Icon_Skill:GetDynamicMaterial():SetTextureParameterValue("Mask", nil)
  end
end

function M:OnPropIconLoadFinish(Object, ResourceID)
  if not (IsValid(self) and Object) or self.LoadPropResourceID ~= ResourceID then
    return
  end
  self:OrganIcon(Object)
end

function M.ButtonAtkMeleeDown(Battle_Button_Phone, Index, StartPos)
  local MeleeBtn = Battle_Button_Phone.AtkMelee
  Battle_Button_Phone:TryToPlayTargetCommand("Attack", true)
  if MeleeBtn.IsUltimateEnabled and MeleeBtn.Joystick then
    MeleeBtn.Joystick:SetRenderOpacity(1.0)
    MeleeBtn.Joystick:SetRenderTranslation(FVector2D(0, 0))
  end
  if MeleeBtn.CurrentUltimateAnim == MeleeBtn.Enable and not EMUIAnimationSubsystem:EMAnimationIsPlaying(MeleeBtn, MeleeBtn.Press) then
    EMUIAnimationSubsystem:EMPlayAnimation(MeleeBtn, MeleeBtn.Press)
  end
end

function M.ButtonAtkMeleeMove(Battle_Button_Phone, TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
  local MeleeBtn = Battle_Button_Phone.AtkMelee
  if not MeleeBtn.IsUltimateEnabled then
    return
  end
  local WorldDeltaTime = UE4.UGameplayStatics.GetWorldDeltaSeconds(MeleeBtn)
  Battle_Button_Phone.OwnerPlayer:AddCharacterPitchInput(-2 * LastDeltaDis.Y * WorldDeltaTime)
  Battle_Button_Phone.OwnerPlayer:AddCharacterYawInput(4.5 * LastDeltaDis.X * WorldDeltaTime)
  if MeleeBtn.Joystick then
    local Radius = 40
    local Dx, Dy = TotalDeltaDis.X, TotalDeltaDis.Y
    local Dist = math.sqrt(Dx * Dx + Dy * Dy)
    if Radius < Dist then
      local S = Radius / Dist
      Dx, Dy = Dx * S, Dy * S
    end
    MeleeBtn.Joystick:SetRenderTranslation(FVector2D(Dx, Dy))
  end
end

function M.ButtonAtkMeleeUp(Battle_Button_Phone, Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  local MeleeBtn = Battle_Button_Phone.AtkMelee
  Battle_Button_Phone:TryToStopTargetCommand("Attack", true)
  if MeleeBtn.Joystick then
    MeleeBtn.Joystick:SetRenderOpacity(0)
    MeleeBtn.Joystick:SetRenderTranslation(FVector2D(0, 0))
  end
  if MeleeBtn.CurrentUltimateAnim == MeleeBtn.Enable then
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(MeleeBtn, MeleeBtn.Press) then
      EMUIAnimationSubsystem:EMStopAnimation(MeleeBtn, MeleeBtn.Press)
    end
    EMUIAnimationSubsystem:EMPlayAnimation(MeleeBtn, MeleeBtn.Click)
  end
end

function M:OnUltimateStateChanged(IsActive, IsType1)
  if IsActive then
    self.IsUltimateEnabled = true
    local Anim = IsType1 and self.Enable or self.Enable_2
    self.CurrentUltimateAnim = Anim
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, Anim) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, Anim)
    end
    if IsType1 and self.Button_Area then
      self.Button_Area:SetVisibility(ESlateVisibility.HitTestInvisible)
    end
  else
    if self.IsUltimateEnabled then
      self.IsUltimateEnabled = false
      local Anim = self.CurrentUltimateAnim or self.Enable_2
      EMUIAnimationSubsystem:EMStopAnimation(self, Anim)
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.EnableEnd)
      self.CurrentUltimateAnim = nil
    end
    if self.Button_Area then
      self.Button_Area:SetVisibility(ESlateVisibility.Visible)
    end
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
    self.ImageMat:SetTextureParameterValue("IconMap", Object)
  end
  if self.Icon_Skill then
    self.Icon_Skill:GetDynamicMaterial():SetTextureParameterValue("Mask", Object)
  end
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
  if not self.IsUltimateIconActive then
    return
  end
  self.IsUltimateIconActive = false
  if self.DefaultIconPath then
    UE.UResourceLibrary.LoadObjectAsync(self, self.DefaultIconPath, {
      self,
      M.OnWeaponHUDIconLoadFinish
    })
  end
end

AssembleComponents(M)
return M
