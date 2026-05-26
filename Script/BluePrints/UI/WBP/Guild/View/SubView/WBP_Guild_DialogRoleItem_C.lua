require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClick)
  self.Btn_Click.OnHovered:Add(self, self.OnHovered)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.SelfWidget = self
  self:InitData(Content)
end

function M:OnHovered()
  if UIUtils.UtilsGetCurrentInputType() ~= UE4.ECommonInputType.Gamepad then
    return
  end
  self:OnClick()
end

function M:InitData(Content)
  self.Text_Role:SetText(GText(Content.TitleName))
  local JoBLv = Content.JoBLv
  local SlateColor = self.BG_Role.ColorAndOpacity
  SlateColor.SpecifiedColor = self["Color_BG_0" .. JoBLv]
  self.BG_Role:SetColorAndOpacity(SlateColor)
  local SlateColor = self.Text_Role.ColorAndOpacity
  SlateColor.SpecifiedColor = self["Color_Text_0" .. JoBLv]
  self.Text_Role:SetColorAndOpacity(SlateColor)
  if JoBLv >= self.Content.SelfJobLevel and not self:IsGuildMaster() then
    self.Text_No:SetText(GText("UI_InsufficientPermissions"))
    self.WS_Type:SetActiveWidgetIndex(1)
    self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:SetIsSelect(false)
  else
    if JoBLv == self.Content.SelfJobLevel - 1 and not self:IsGuildMaster() then
      self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    end
    self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible)
    self.WS_Type:SetActiveWidgetIndex(0)
    local IsSelect = JoBLv == (self.Content.LastChangeJobLevel or self.Content.CurJobLevel)
    self:SetIsSelect(IsSelect)
    if IsSelect then
      self:OnClick()
      self:SetFocus()
    end
  end
end

function M:IsGuildMaster()
  return 5 == self.Content.SelfJobLevel
end

function M:OnClick()
  if self.Content.JoBLv >= self.Content.SelfJobLevel and not self:IsGuildMaster() then
    return
  end
  if self.IsSelect == true then
    return
  end
  self.IsSelect = true
  self:SetIsSelect(true)
  self.Content.CellCallbackInfo.Func(self.Content.CellCallbackInfo.Obj, self.Content)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
end

function M:SetIsSelect(IsShow)
  if IsShow then
    self.Icon_Click:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.Icon_Click:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M
