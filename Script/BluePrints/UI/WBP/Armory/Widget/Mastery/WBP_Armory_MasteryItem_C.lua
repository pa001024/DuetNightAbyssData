require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.ButtonAnimationComponent"
}

function M:Init(Params)
  self.Owner = Params.Owner
  self._OnAddedToFocusPath = Params.OnAddedToFocusPath
  self:SetWeaponTag(Params.WeaponTag)
  self:SetIsUnlocked(Params.IsUnlocked)
  self:SetIsSelected(Params.IsSelected)
end

function M:SetRedDot(RedDotType)
  self.RedDotType = RedDotType
  if RedDotType then
    self.RedDot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.RedDot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetWeaponTag(WeaponTag)
  self.WeaponTag = WeaponTag
  if WeaponTag then
    local WeaponTagData = DataMgr.WeaponTag[WeaponTag]
    if WeaponTagData then
      if WeaponTagData.Icon then
        local DMI = self.Icon_WeaponType:GetDynamicMaterial()
        if DMI then
          DMI:SetTextureParameterValue("IconTex", LoadObject(WeaponTagData.Icon))
        end
      end
      if WeaponTagData.WeaponTagTextmap then
        self.Text_Name:SetText(GText(WeaponTagData.WeaponTagTextmap))
      end
    end
  end
end

function M:SetIsEquipped(IsEquipped)
  if IsEquipped then
    self.Panel_Select:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Panel_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetIsUnlocked(IsUnlocked)
  self.IsUnlocked = IsUnlocked
  if self.IsUnlocked then
    self:StopAnimation(self.Inactive)
    self:PlayAnimation(self.Active)
  else
    self:StopAnimation(self.Active)
    self:PlayAnimation(self.Inactive)
  end
end

function M:PlayUnLockAnim()
  self:StopAllAnimations()
  self:PlayAnimation(self.UnLock)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/skill_unlock", nil, nil)
end

function M:BindEventOnClicked(Obj, Func)
  self.Obj = Obj
  self.Func = Func
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/click_skill_icon", nil, nil)
  if self.Func then
    self.Func(self.Obj)
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath(self.Owner, self)
  end
end

AssembleComponents(M)
return M
