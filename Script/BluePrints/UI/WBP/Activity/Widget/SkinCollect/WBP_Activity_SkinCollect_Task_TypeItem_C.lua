require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function FindWidgetByName(Widget, WidgetName)
  if not Widget or not WidgetName then
    return nil
  end
  if Widget.GetName and Widget:GetName() == WidgetName then
    return Widget
  end
  if Widget.WidgetTree and Widget.WidgetTree.FindWidget then
    local FoundWidget = Widget.WidgetTree:FindWidget(WidgetName)
    if FoundWidget then
      return FoundWidget
    end
  end
  if Widget.GetChildrenCount and Widget.GetChildAt then
    local ChildrenCount = Widget:GetChildrenCount()
    for Index = 0, ChildrenCount - 1 do
      local ChildWidget = Widget:GetChildAt(Index)
      local FoundWidget = FindWidgetByName(ChildWidget, WidgetName)
      if FoundWidget then
        return FoundWidget
      end
    end
  end
  if Widget.GetContent then
    local ContentWidget = Widget:GetContent()
    local FoundWidget = FindWidgetByName(ContentWidget, WidgetName)
    if FoundWidget then
      return FoundWidget
    end
  end
  return nil
end

local function SetGTextIfValid(TextWidget, TextKey)
  if TextWidget then
    TextWidget:SetText(TextKey and GText(TextKey) or "")
  end
end

local function SetNumberTextIfValid(TextWidget, Value)
  if TextWidget then
    TextWidget:SetText(tostring(Value or ""))
  end
end

local function SetImageIfValid(ImageWidget, IconPath)
  if not (ImageWidget and IconPath) or "" == IconPath then
    return
  end
  local IconObj = LoadObject(IconPath)
  if IconObj then
    ImageWidget:SetBrushFromTexture(IconObj)
  end
end

local function SetCommonItemIconIfValid(IconWidget, IconPath)
  if not (IconWidget and IconPath) or "" == IconPath then
    return
  end
  IconWidget.Icon = IconPath
  if IconWidget.SetIcon then
    IconWidget:SetIcon()
  elseif IconWidget.Init then
    IconWidget:Init({Icon = IconPath, NotInteractive = true})
  end
end

local function SetWidgetVisible(Widget, IsVisible)
  if Widget then
    Widget:SetVisibility(IsVisible and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
end

local function StopUINavigation(Widget)
  if not Widget or not Widget.SetNavigationRuleBase then
    return
  end
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
end

function M:GetChildWidget(WidgetName)
  if not WidgetName then
    return nil
  end
  self.CachedWidgets = self.CachedWidgets or {}
  local CachedWidget = self.CachedWidgets[WidgetName]
  if CachedWidget and IsValid(CachedWidget) then
    return CachedWidget
  end
  CachedWidget = self[WidgetName] or FindWidgetByName(self, WidgetName)
  self.CachedWidgets[WidgetName] = CachedWidget
  return CachedWidget
end

function M:GetClickButton()
  return self:GetChildWidget("Btn_Click")
end

function M:SetOwnerPopupItem(OwnerPopupItem)
  self.OwnerPopupItem = OwnerPopupItem
end

function M:StopNativeUINavigation()
  StopUINavigation(self)
  StopUINavigation(self:GetClickButton())
end

function M:RefreshView(Content)
  self.bIsFocusable = true
  self:StopNativeUINavigation()
  self.Content = Content
  SetGTextIfValid(self:GetChildWidget("Text_Title"), Content and Content.Title or "")
  SetNumberTextIfValid(self:GetChildWidget("Text_NumGet"), Content and Content.CurrentScore or 0)
  SetNumberTextIfValid(self:GetChildWidget("Text_NumTotal"), Content and Content.TotalScore or 0)
  SetImageIfValid(self:GetChildWidget("Image_Icon"), Content and (Content.IconPath or Content.Icon))
  SetCommonItemIconIfValid(self:GetChildWidget("Com_ItemIcon"), Content and Content.ScoreIcon)
  SetWidgetVisible(self:GetChildWidget("Image_Got"), self:IsTaskTypeGot())
  self:SetForbidden(Content and true == Content.Forbidden)
  self:BindClickEvent()
end

function M:IsTaskTypeGot()
  if not self.Content then
    return false
  end
  return (self.Content.CurrentScore or 0) == (self.Content.TotalScore or 0)
end

function M:SetClickCallback(Owner, Callback)
  self.ClickCallbackOwner = Owner
  self.ClickCallback = Callback
  self:BindClickEvent()
end

function M:ClearClickCallback()
  self:UnBindClickEvent()
  self.ClickCallbackOwner = nil
  self.ClickCallback = nil
end

function M:BindClickEvent()
  if self.IsClickEventBound then
    return
  end
  local ClickButton = self:GetClickButton()
  if not ClickButton then
    return
  end
  StopUINavigation(ClickButton)
  if ClickButton.OnClicked then
    ClickButton.OnClicked:Add(self, self.OnBtnClicked)
  end
  if ClickButton.OnHovered then
    ClickButton.OnHovered:Add(self, self.OnHovered)
  end
  if ClickButton.OnUnhovered then
    ClickButton.OnUnhovered:Add(self, self.OnUnhovered)
  end
  if ClickButton.OnPressed then
    ClickButton.OnPressed:Add(self, self.OnPressed)
  end
  if ClickButton.OnReleased then
    ClickButton.OnReleased:Add(self, self.OnReleased)
  end
  self.IsClickEventBound = true
end

function M:UnBindClickEvent()
  if not self.IsClickEventBound then
    return
  end
  local ClickButton = self:GetClickButton()
  if ClickButton then
    if ClickButton.OnClicked then
      ClickButton.OnClicked:Remove(self, self.OnBtnClicked)
    end
    if ClickButton.OnHovered then
      ClickButton.OnHovered:Remove(self, self.OnHovered)
    end
    if ClickButton.OnUnhovered then
      ClickButton.OnUnhovered:Remove(self, self.OnUnhovered)
    end
    if ClickButton.OnPressed then
      ClickButton.OnPressed:Remove(self, self.OnPressed)
    end
    if ClickButton.OnReleased then
      ClickButton.OnReleased:Remove(self, self.OnReleased)
    end
  end
  self.IsClickEventBound = false
end

local STATE_ANIMATION_NAMES = {
  "Normal",
  "Hover",
  "UnHover",
  "Press",
  "Click",
  "Forbidden"
}

function M:StopStateAnimations(ExceptAnimationName)
  for _, AnimationName in ipairs(STATE_ANIMATION_NAMES) do
    if AnimationName ~= ExceptAnimationName and self[AnimationName] then
      self:StopAnimation(self[AnimationName])
    end
  end
end

function M:PlayStateAnimation(AnimationName)
  local Animation = AnimationName and self[AnimationName]
  if Animation then
    self:StopStateAnimations(AnimationName)
    self:PlayAnimation(Animation)
    self.CurrentStateAnimationName = AnimationName
  end
end

function M:JumpStateAnimationToEnd(AnimationName)
  local Animation = AnimationName and self[AnimationName]
  if not Animation then
    return
  end
  self:StopStateAnimations(AnimationName)
  if Animation.GetEndTime and self.SetAnimationCurrentTime then
    self:SetAnimationCurrentTime(Animation, Animation:GetEndTime())
  elseif Animation.GetEndTime then
    self:PlayAnimation(Animation, Animation:GetEndTime())
  else
    self:PlayAnimation(Animation)
  end
  self.CurrentStateAnimationName = AnimationName
end

function M:ApplyStateAnimation(AnimationName, bKeepCurrentState)
  if true == bKeepCurrentState then
    self:JumpStateAnimationToEnd(AnimationName)
    return
  end
  self:PlayStateAnimation(AnimationName)
end

function M:SetSelected(IsSelected, bKeepCurrentState)
  local NewSelected = true == IsSelected
  local bShouldKeepCurrentState = true == bKeepCurrentState
  self.IsSelected = NewSelected
  if self.IsForbidden then
    self:ApplyStateAnimation("Forbidden", bShouldKeepCurrentState)
    return
  end
  if self.IsGamepadFocused and not self.IsSelected then
    self:ApplyStateAnimation("Hover", bShouldKeepCurrentState)
    return
  end
  self:ApplyStateAnimation(self.IsSelected and "Click" or "Normal", bShouldKeepCurrentState)
end

function M:SetForbidden(IsForbidden)
  self.IsForbidden = true == IsForbidden
  self:PlayStateAnimation(self.IsForbidden and "Forbidden" or "Normal")
end

function M:SetGamepadFocused(IsFocused, bKeepCurrentState)
  local NewFocused = true == IsFocused
  local bShouldKeepCurrentState = true == bKeepCurrentState
  self.IsGamepadFocused = NewFocused
  if self.IsForbidden then
    self:ApplyStateAnimation("Forbidden", bShouldKeepCurrentState)
    return
  end
  if self.IsSelected then
    self:ApplyStateAnimation("Click", bShouldKeepCurrentState)
    return
  end
  if self.IsGamepadFocused then
    self:ApplyStateAnimation("Hover", bShouldKeepCurrentState)
  else
    if self.Hover then
      self:StopAnimation(self.Hover)
    end
    self:ApplyStateAnimation("UnHover", bShouldKeepCurrentState)
  end
end

function M:OnBtnClicked()
  if self.IsForbidden then
    self:PlayStateAnimation("Forbidden")
    return
  end
  self:PlayStateAnimation("Click")
  if self.ClickCallbackOwner and self.ClickCallback then
    self.ClickCallback(self.ClickCallbackOwner)
  end
end

function M:OnHovered()
  if self.IsForbidden or self.IsSelected or self.IsGamepadFocused then
    return
  end
  self:PlayStateAnimation("Hover")
end

function M:OnUnhovered()
  if self.IsForbidden or self.IsSelected or self.IsGamepadFocused then
    return
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  self:PlayStateAnimation("UnHover")
end

function M:OnPressed()
  if self.IsForbidden or self.IsSelected then
    return
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  self:PlayStateAnimation("Press")
end

function M:OnReleased()
  if self.IsForbidden or self.IsSelected then
    return
  end
  self:PlayStateAnimation("Hover")
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  self:OnHovered()
end

function M:OnMouseLeave(MouseEvent)
  self:OnUnhovered()
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  self:OnPressed()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self:OnBtnClicked()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.OwnerPopupItem and self.OwnerPopupItem.OnTypeItemFocusReceived then
    self.OwnerPopupItem:OnTypeItemFocusReceived()
  end
  return UIUtils.Handled
end

function M:BP_OnEntryReleased()
  self:ClearClickCallback()
  self.Content = nil
  self.CachedWidgets = nil
  self.IsSelected = false
  self.IsForbidden = false
  self.IsGamepadFocused = false
  self.CurrentStateAnimationName = nil
  self.OwnerPopupItem = nil
end

function M:OnDestroyed()
  self:ClearClickCallback()
  M.Super.OnDestroyed(self)
end

return M
