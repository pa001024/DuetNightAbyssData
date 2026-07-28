require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.ButtonArea.OnCheckStateChanged:Add(self, self.OnCheckStateChanged)
  self:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:OnFocusReceived()
  if UIUtils.IsGamepadInput() then
    self:RefreshSelect(true, true)
  end
  return UIUtils.Unhandled
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if not Content then
    return
  end
  self.Content.UI = self
  self.ParentPanel = Content.Parent
  if self.TextNum then
    self.TextNum:SetText(Content.TabName or "")
  end
  if Content.IsSelected then
    self:RefreshSelect(Content.IsSelected)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:OnCheckStateChanged(bIsChecked)
  if bIsChecked then
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  end
  self.ButtonArea:SetVisibility(UIConst.VisibilityOp.Visible)
  if not self.Content then
    return
  end
  if not bIsChecked then
    return
  end
  self.ButtonArea:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:PlayAnimation(self.Click)
  local Parent = self.ParentPanel or self.Content.Parent
  if Parent and Parent.OnTabItemClicked then
    Parent:OnTabItemClicked(self.Content)
  end
end

function M:RefreshSelect(bSelected)
  self.Content.IsSelected = bSelected
  self.ButtonArea:SetChecked(bSelected)
end

return M
