require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnButtonClicked)
  self.Btn_Click.OnPressed:Add(self, self.OnButtonPressed)
  self.Btn_Click.OnHovered:Add(self, self.OnButtonHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnButtonUnhovered)
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnButtonClicked)
  self.Btn_Click.OnPressed:Remove(self, self.OnButtonPressed)
  self.Btn_Click.OnHovered:Remove(self, self.OnButtonHovered)
  self.Btn_Click.OnUnhovered:Remove(self, self.OnButtonUnhovered)
end

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.Content = Content
  self.Parent = Content.Parent
  self.CallbackObj = Content.CallbackObj
  self.ClickCallback = Content.ClickCallback
  self.Num = Content.Num or 0
  self.Multiple = Content.Multiple or 0
  self:InitContent()
  self:InitNavigations()
end

function M:InitContent()
  self.Text_Num:SetText(self.Num)
  self.Text_NumMultiplier:SetText("x" .. self.Multiple)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:OnButtonClicked()
  return UIUtils.Handle
end

function M:InitNavigations()
  self:SetNavigationRuleBase(UE4.EUINavigation.Up, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Down, EUINavigationRule.Stop)
  self:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    self.HandleNavigationLeft
  })
  self:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    self.HandleNavigationRight
  })
end

function M:HandleNavigationLeft()
  if 0 == self.Content.Index then
    return self
  end
  self.Parent.List_Multiplier:NavigateToIndex(self.Content.Index - 1)
  return self.Parent.MultiplierContents[self.Content.Index].SelfWidget
end

function M:HandleNavigationRight()
  local MaxIndex = #self.Parent.MultiplierContents - 1
  if self.Content.Index == MaxIndex then
    return self
  end
  self.Parent.List_Multiplier:NavigateToIndex(self.Content.Index + 1)
  return self.Parent.MultiplierContents[self.Content.Index + 1].SelfWidget
end

function M:IsStopProcessEvent()
  return self.StopProcess
end

function M:PlayNormalAnimation()
  self.StopProcess = false
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:PlaySelectedAnimation()
  self.StopProcess = true
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:OnButtonClicked()
  if self:IsStopProcessEvent() then
    return
  end
  if self.CallbackObj and self.ClickCallback and type(self.ClickCallback) == "function" then
    self.ClickCallback(self.CallbackObj, self.Content)
  end
end

function M:OnButtonHovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnButtonUnhovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnButtonPressed()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

return M
