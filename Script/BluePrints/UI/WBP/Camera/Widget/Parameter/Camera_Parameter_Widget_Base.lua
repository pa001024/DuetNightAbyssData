local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:Init(Content)
  rawset(self, "Content", Content)
  rawset(self, "Owner", Content.Owner)
  self:SetRedDot(Content.RedDotType)
end

function M:SetRedDot(RedDotType)
  if not self.New then
    return
  end
  if RedDotType == UIConst.RedDotType.NewRedDot then
    self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  rawset(self, "IsGamePadInput", CurInputDevice == ECommonInputType.Gamepad)
  rawset(self, "CurGamepadName", CurGamepadName)
  if rawget(self, "IsInFocusPath") and not self:HasAnyUserFocus() then
    self:SetFocus()
  end
  if rawget(self, "IsGamePadInput") and rawget(self, "IsInFocusPath") then
    self:PlayHoverAnim()
  end
end

function M:PlayHoverAnim()
  if self.IsHoverAnimPlayed then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
  rawset(self, "IsHoverAnimPlayed", true)
  DebugPrint("PlayHoverAnim", self.Content.OptionId)
end

function M:OnAddedToFocusPath(InFocusEvent)
  rawset(self, "IsInFocusPath", true)
  if self.IsGamePadInput then
    self:PlayHoverAnim()
  end
end

function M:OnRemovedFromFocusPath()
  rawset(self, "IsInFocusPath", false)
  if self.IsHoverAnimPlayed then
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
    rawset(self, "IsHoverAnimPlayed", false)
    DebugPrint("PlayUnHoverAnim", self.Content.OptionId)
  end
end

function M:GetDesiredFocusTarget()
  return self
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Widget = self:GetDesiredFocusTarget()
  if self.Owner and self.Owner.ScrollBox_Parameter and self.IsGamePadInput then
    self.Owner.ScrollBox_Parameter:ScrollWidgetIntoView(Widget, false, 0)
  end
  if Widget == self then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget())
end

AssembleComponents(M)
return M
