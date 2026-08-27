require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Initialize(Initializer)
  self.WeaponTag = nil
  self.IsExtra = false
  self.IsActivated = false
end

function M:SetIsSelected(IsSelected)
  if IsSelected then
    self:PlayAnimation(self.Select)
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

function M:SetIsExtra(IsExtra)
  self.IsExtra = IsExtra
  self.Panel_Extra:SetVisibility(IsExtra and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
end

function M:SetRedDot(RedDotType)
  if RedDotType == UIConst.RedDotType.CommonRedDot then
    self.RedDot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  else
    self.RedDot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if RedDotType == UIConst.RedDotType.NewRedDot then
    self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetIsActivated(IsActivated)
  self.IsActivated = IsActivated
  if IsActivated then
    self.WS_State:SetActiveWidgetIndex(0)
    self.WS_Text:SetActiveWidgetIndex(0)
  else
    self.WS_State:SetActiveWidgetIndex(1)
    self.WS_Text:SetActiveWidgetIndex(1)
  end
end

function M:BindEventOnClicked(Obj, Func)
  self.Obj = Obj
  self.Func = Func
end

function M:Construct()
  self.Text_Name_Inactivie:SetText(GText("UI_Armory_ExcelWeponToBeActivated"))
  self.Text_Extra:SetText(GText("UI_Armory_ExtraExcelWeponSign"))
  self.Btn_Area.OnClicked:Add(self, self.OnBtnClicked)
end

function M:OnBtnClicked()
  if self.IsActivated then
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_skill_icon", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  end
  if self.Obj and self.Func then
    self.Func(self.Obj)
  end
end

function M:Destruct()
  self.Btn_Area.OnClicked:Clear()
end

return M
