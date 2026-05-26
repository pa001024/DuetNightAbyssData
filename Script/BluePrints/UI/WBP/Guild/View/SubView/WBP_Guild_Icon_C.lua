require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClicked)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.CurrentEntry = self
  if not self.Btn_Click.OnCheckStateChanged:IsBound() then
    self.Btn_Click.OnCheckStateChanged:Add(self, self.OnSelected)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
  end
  if Content.bSelected then
    self:SetSelected(true)
  else
    self:SetSelected(false)
  end
  self:InitData(Content)
end

function M:OnHovered()
  if UIUtils.UtilsGetCurrentInputType() ~= UE4.ECommonInputType.Gamepad then
    return
  end
  if self.Content.Parent.IsTabRefreshing then
    return
  end
  self.Content.bSelected = true
  self:OnClicked()
  self:SetSelected(true)
end

function M:OnSelected(bIsChecked)
  if not self.Content then
    DebugPrint("Content is nil, cannot clear list item object.")
    return
  end
  self.Content.bSelected = bIsChecked
  if bIsChecked then
    self.Content.Parent:OnIconSelected(self.Content)
    self.Btn_Click:SetIsEnabled(false)
  else
    local IsSelected = false
    if self.Content.Parent.CurrentIconSelectedContent == self.Content then
      IsSelected = true
      self:SetSelected(true)
    end
    if not IsSelected then
      self.Btn_Click:SetIsEnabled(true)
    end
  end
end

function M:SetSelected(bIsChecked)
  if bIsChecked then
    self.Btn_Click:SetChecked(bIsChecked)
  else
    self.Btn_Click:SetChecked(bIsChecked)
    self:PlayAnimation(self.Normal)
  end
end

function M:InitData(Content)
  local Icon = Content.Icon or Content.FlagIcon
  if Icon then
    self.WS_Type:SetActiveWidgetIndex(0)
    local IconTexture = LoadObject(Icon)
    if Content.Icon then
      self.WS_Icon:SetActiveWidgetIndex(0)
      local Icon = self.Icon_Logo:GetDynamicMaterial()
      Icon:SetTextureParameterValue("Mask", IconTexture)
      self.Icon_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
    elseif Content.FlagIcon then
      self.WS_Icon:SetActiveWidgetIndex(1)
      local Icon = self.Icon_Flag:GetDynamicMaterial()
      Icon:SetTextureParameterValue("MainTex", IconTexture)
      self.Icon_Select:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  else
    self.WS_Type:SetActiveWidgetIndex(1)
  end
  self.VX_Hover_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OnClicked()
  local IconId = self.Content.LogoID or self.Content.FlagID
  self.Content.EditCallbackInfo.Func(self.Content.EditCallbackInfo.Obj, 3, IconId)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UIUtils.IsGamepadInput() and InKeyName == UIConst.GamePadKey.DPadUp then
    local a = 1
  end
  if IsHandled then
    return UIUtils.Handled
  else
    return UIUtils.UnHandled
  end
end

return M
