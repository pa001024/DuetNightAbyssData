require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
local INTERACTION_ANIMATION_NAMES = {
  "Normal",
  "Hover",
  "UnHover",
  "Press",
  "Click"
}
local STATE_ANIMATION_NAMES = {
  "Normal",
  "Hover",
  "UnHover",
  "Press",
  "Click",
  "Select"
}

local function FlushAnimations(Widget)
  if Widget.FlushAnimations then
    Widget:FlushAnimations()
  end
end

local function StopAnimations(Widget, AnimationNames)
  FlushAnimations(Widget)
  for _, AnimationName in ipairs(AnimationNames) do
    local Animation = Widget[AnimationName]
    if Animation then
      Widget:StopAnimation(Animation)
    end
  end
  FlushAnimations(Widget)
end

local function StopInteractionAnimations(Widget)
  StopAnimations(Widget, INTERACTION_ANIMATION_NAMES)
end

local function StopStateAnimations(Widget)
  StopAnimations(Widget, STATE_ANIMATION_NAMES)
end

local function PlayStateAnimation(Widget, Animation)
  StopInteractionAnimations(Widget)
  if Animation then
    Widget:PlayAnimation(Animation)
    FlushAnimations(Widget)
  end
end

local function IsSelected(Widget)
  return Widget.Obj and Widget.Obj.IsSelected == true
end

local function ApplyAnimationStart(Widget, Animation)
  if not Animation then
    return
  end
  EMUIAnimationSubsystem:SetWidgetAnimationToStart(Widget, Animation)
end

local function ApplyAnimationEnd(Widget, Animation)
  if not Animation then
    return
  end
  EMUIAnimationSubsystem:SetWidgetAnimation(Widget, Animation)
end

function M:Construct()
  self.BtnArea.OnClicked:Add(self, self.OnBtnClicked)
  self.BtnArea.OnHovered:Add(self, self.OnBtnHovered)
  self.BtnArea.OnUnhovered:Add(self, self.OnBtnUnhovered)
  self.BtnArea.OnPressed:Add(self, self.OnBtnPressed)
  self.BtnArea.OnReleased:Add(self, self.OnBtnReleased)
end

function M:Destruct()
  self.BtnArea.OnClicked:Remove(self, self.OnBtnClicked)
  self.BtnArea.OnHovered:Remove(self, self.OnBtnHovered)
  self.BtnArea.OnUnhovered:Remove(self, self.OnBtnUnhovered)
  self.BtnArea.OnPressed:Remove(self, self.OnBtnPressed)
  self.BtnArea.OnReleased:Remove(self, self.OnBtnReleased)
  self.Obj = nil
  self.bSelected = nil
  self.bGamepadFocusHover = nil
end

function M:BP_OnEntryReleased()
  if self.Obj then
    self.Obj.Entry = nil
  end
  self.Obj = nil
  self.bSelected = nil
  self.bGamepadFocusHover = false
  self:ResetEntryVisualState()
end

function M:OnListItemObjectSet(Obj)
  if self.Obj and self.Obj ~= Obj then
    self.Obj.Entry = nil
  end
  self:ResetEntryVisualState()
  self.Obj = Obj
  self.bSelected = false
  self.bGamepadFocusHover = false
  Obj.Entry = self
  self.WS_BG:SetActiveWidgetIndex(((Obj.Index or 1) - 1) % 2)
  self:SetText(Obj.TextKey and GText(Obj.TextKey) or Obj.Text or "")
  self:OnEntrySelectionChanged()
end

function M:SetText(Text)
  self.Text_On:SetText(Text or "")
  self.Text_On_Select:SetText(Text or "")
end

function M:OnBtnClicked()
  if self.Obj and self.Obj.OnListItemClicked and self.Obj.Owner then
    UIUtils.PlayCommonBtnSe(self)
    self.Obj.OnListItemClicked(self.Obj.Owner, self.Obj)
  end
end

function M:OnBtnHovered()
  self:OnEntryHoveredChanged(true)
  if self.Obj and self.Obj.OnListItemHovered and self.Obj.Owner then
    self.Obj.OnListItemHovered(self.Obj.Owner, self.Obj)
  end
end

function M:OnBtnUnhovered()
  self:OnEntryHoveredChanged(false)
end

function M:OnBtnPressed()
  if IsSelected(self) then
    return
  end
  PlayStateAnimation(self, self.Press)
end

function M:OnBtnReleased()
  if IsSelected(self) then
    return
  end
  StopInteractionAnimations(self)
  ApplyAnimationEnd(self, self.Normal)
end

function M:OnEntryHoveredChanged(bHovered)
  if IsSelected(self) then
    return
  end
  if bHovered then
    PlayStateAnimation(self, self.Hover)
  else
    PlayStateAnimation(self, self.UnHover)
  end
end

function M:ResetEntryVisualState()
  StopStateAnimations(self)
  ApplyAnimationStart(self, self.Hover)
  ApplyAnimationEnd(self, self.Normal)
  ApplyAnimationStart(self, self.Select)
end

function M:OnEntrySelectionChanged()
  local bSelected = IsSelected(self)
  local bSelectionChanged = self.bSelected ~= bSelected
  self.bSelected = bSelected
  if bSelected then
    self:ResetEntryVisualState()
    if bSelectionChanged and self.Select then
      self:PlayAnimation(self.Select)
      FlushAnimations(self)
    else
      ApplyAnimationEnd(self, self.Select)
    end
  else
    self:ResetEntryVisualState()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Obj and self.Obj.OnListItemFocused and self.Obj.Owner then
    self.Obj.OnListItemFocused(self.Obj.Owner, self.Obj)
  end
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.BtnArea)
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.Obj and self.Obj.OnListItemFocused and self.Obj.Owner then
    self.Obj.OnListItemFocused(self.Obj.Owner, self.Obj)
  end
  self.bGamepadFocusHover = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if self.bGamepadFocusHover then
    self:OnEntryHoveredChanged(true)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if self.bGamepadFocusHover then
    self:OnEntryHoveredChanged(false)
  end
  self.bGamepadFocusHover = false
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local Owner = self.Obj and self.Obj.Owner
  if Owner and Owner.ForwardRecruitPreviewKeyDown and Owner:ForwardRecruitPreviewKeyDown(MyGeometry, InKeyEvent) then
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Owner = self.Obj and self.Obj.Owner
  if Owner and Owner.ForwardRecruitPreviewKeyDown and Owner:ForwardRecruitPreviewKeyDown(MyGeometry, InKeyEvent) then
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

return M
