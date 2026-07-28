require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function IsLeftMouseButtonEvent(MouseEvent)
  return MouseEvent and UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent) == EKeys.LeftMouseButton
end

local function IsLeftMouseButtonDown(MouseEvent)
  return MouseEvent and UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Config = Content and Content.ParentConfig
  self.OwnerPanel = Content and Content.OwnerPanel
  self.ParentAction = Content and Content.ParentAction
  if self.ParentAction then
    self.ParentAction:RegisterEntry(Content, self)
  end
  self:Init(Content, self.OwnerPanel)
end

function M:Init(Content, OwnerPanel)
  self.Content = Content
  self.Config = Content and Content.ParentConfig
  self.OwnerPanel = OwnerPanel
  self:ResetVisualState()
  Utils.SetText(self.Text_Name or self.Panel_Name, self:GetActionName())
  Utils.SetText(self.Key_Num, Content and Content.Index and tostring(Content.Index) or "")
  self:SetActionIcon(Content and Content.Icon)
  self:DisableInnerButtonHitTest()
  self:Refresh()
end

function M:DisableInnerButtonHitTest()
  if not self.Btn_Area then
    return
  end
  if self.Btn_Area.OnClicked then
    self.Btn_Area.OnClicked:Clear()
  end
  if self.Btn_Area.OnHovered then
    self.Btn_Area.OnHovered:Clear()
  end
  if self.Btn_Area.OnUnhovered then
    self.Btn_Area.OnUnhovered:Clear()
  end
  if self.Btn_Area.OnPressed then
    self.Btn_Area.OnPressed:Clear()
  end
  if self.Btn_Area.OnReleased then
    self.Btn_Area.OnReleased:Clear()
  end
  if self.Btn_Area.SetVisibility then
    self.Btn_Area:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
end

function M:SetActionIcon(Icon)
  if not (self.Icon_Gesture and self.Icon_Gesture.SetBrushResourceObject) or not Icon then
    return
  end
  local IconObject = Icon
  if type(Icon) == "string" then
    if "" == Icon then
      return
    end
    IconObject = LoadObject(Icon)
  end
  if IconObject then
    self.Icon_Gesture:SetBrushResourceObject(IconObject)
  end
end

function M:Refresh()
  self:RefreshNewState()
  self:RefreshValue()
  self:RefreshFocus()
end

function M:RefreshValue()
  Utils.SetText(self.Text_Name or self.Panel_Name, self:GetActionName())
  Utils.SetText(self.Key_Num, self.Content and self.Content.Index and tostring(self.Content.Index) or "")
  self:SetActionIcon(self.Content and self.Content.Icon)
  self:RefreshItemState()
  self:RefreshForbidState()
end

function M:RefreshNewState()
  Utils.SetNew(self.New, self.Content and self.Content.IsNew == true)
end

function M:RefreshFocus()
  self:SetSelected(self.Content and self.Content.IsFocused == true, true)
end

function M:RefreshItemState()
  if self.WS_State and self.WS_State.SetActiveWidgetIndex then
    self.WS_State:SetActiveWidgetIndex(self.Content and self.Content.IsDefaultAction and 1 or 0)
  end
end

function M:RefreshForbidState()
  Utils.SetVisibility(self.Panel_Forbid, self.Content and self.Content.IsForbiddenAction == true)
end

function M:SetWidgetRenderOpacity(Widget, Opacity)
  if Widget and Widget.SetRenderOpacity then
    Widget:SetRenderOpacity(Opacity)
  end
end

function M:StopSelectionAnimations()
  if not self.StopAnimation then
    return
  end
  local StateAnimations = {
    self.Normal,
    self.Hover,
    self.UnHover,
    self.Press,
    self.Click
  }
  for _, Anim in ipairs(StateAnimations) do
    if Anim then
      self:StopAnimation(Anim)
    end
  end
end

function M:ResetVisualState()
  self:StopSelectionAnimations()
  self.bActionSelected = nil
  self.bActionHovered = false
  self.bActionPressed = false
  self.bActionDragging = false
  self.ActionMouseDownPos = nil
  self:SetWidgetRenderOpacity(self, 1)
  self:SetWidgetRenderOpacity(self.WidgetTree and self.WidgetTree.RootWidget, 1)
  self:SetWidgetRenderOpacity(self.WS_State, 1)
  self:SetWidgetRenderOpacity(self.Icon_Gesture, 1)
  self:SetWidgetRenderOpacity(self.Panel_Forbid, 1)
  self:SetWidgetRenderOpacity(self.BG_Forbid, 1)
  self:SetWidgetRenderOpacity(self.New, 1)
  self:SetWidgetRenderOpacity(self.Key_Num, 1)
  self:SetWidgetRenderOpacity(self.Text_Name, 1)
  self:SetWidgetRenderOpacity(self.Panel_Name, 1)
end

function M:PlayStateAnimation(Anim, bInstant)
  if not Anim then
    return
  end
  self:StopSelectionAnimations()
  if self.PlayAnimation then
    self:PlayAnimation(Anim)
    if true == bInstant and self.SetAnimationCurrentTime and Anim.GetEndTime then
      self:SetAnimationCurrentTime(Anim, Anim:GetEndTime())
    end
  end
end

function M:RefreshBaseState(bInstant)
  if self.bActionSelected then
    self:PlayStateAnimation(self.Click, bInstant)
  elseif self.bActionHovered then
    self:PlayStateAnimation(self.Hover, bInstant)
  else
    self:PlayStateAnimation(self.Normal, bInstant)
  end
end

function M:SetSelected(IsSelected, bForce)
  IsSelected = true == IsSelected
  if self.bActionSelected == IsSelected and true ~= bForce then
    return
  end
  local bPlayClickTransition = IsSelected and true == self.bPlayClickTransition
  self.bPlayClickTransition = false
  self.bActionSelected = IsSelected
  self.bActionPressed = false
  self:RefreshBaseState(true == bForce and not bPlayClickTransition)
end

function M:OnHovered()
  self.bActionHovered = true
  if self.bActionSelected then
    return
  end
  self:PlayStateAnimation(self.Hover)
end

function M:OnUnhovered()
  self.bActionHovered = false
  self.bActionPressed = false
  if self.bActionSelected then
    return
  end
  self:PlayStateAnimation(self.UnHover or self.Normal)
end

function M:OnPressed()
  self.bActionPressed = true
  if self.bActionSelected then
    return
  end
  self:PlayStateAnimation(self.Press)
end

function M:OnReleased()
  self.bActionPressed = false
  if self.bActionSelected then
    return
  end
  self:RefreshBaseState()
end

function M:IsActionDragTriggered(MouseEvent)
  return self.ActionMouseDownPos and UUIFunctionLibrary and UUIFunctionLibrary.HasTraveledFarEnoughToTriggerDrag and UUIFunctionLibrary.HasTraveledFarEnoughToTriggerDrag(MouseEvent, self.ActionMouseDownPos)
end

function M:ClearPointerPressState()
  self.ActionMouseDownPos = nil
  self.bActionDragging = false
  self:OnReleased()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  self:OnHovered()
end

function M:OnMouseLeave(MouseEvent)
  self.ActionMouseDownPos = nil
  self.bActionDragging = false
  self:OnUnhovered()
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if IsLeftMouseButtonEvent(MouseEvent) then
    self.ActionMouseDownPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
    self.bActionDragging = false
    self:OnPressed()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  if IsLeftMouseButtonDown(MouseEvent) and self:IsActionDragTriggered(MouseEvent) then
    self.ActionMouseDownPos = nil
    self.bActionDragging = true
    self:OnReleased()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  local bShouldClick = IsLeftMouseButtonEvent(MouseEvent) and self.ActionMouseDownPos and not self.bActionDragging
  if bShouldClick then
    self:OnClicked()
  else
    self:OnReleased()
  end
  self.ActionMouseDownPos = nil
  self.bActionDragging = false
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseCaptureLost()
  self:ClearPointerPressState()
end

function M:GetActionName()
  if not self.Content then
    return ""
  end
  return self.Content.ActionName or self.Content.UnitName or self.Content.ItemName or tostring(self.Content.UnitId or "")
end

function M:SetRedDot(RedDotType)
  if self.Content then
    self.Content.RedDotType = RedDotType
    self.Content.IsNew = RedDotType == UIConst.RedDotType.NewRedDot
  end
  self:RefreshNewState()
end

function M:SetCount(Count)
  if self.Content then
    self.Content.Count = Count
  end
end

function M:ClearNew()
  if self.Content then
    self.Content.IsNew = false
    self.Content.RedDotType = nil
  end
  self:Refresh()
end

function M:OnClicked()
  self.bActionPressed = false
  self.bPlayClickTransition = true
  if self.ParentAction and self.ParentAction.OnListItemClicked then
    self.ParentAction:OnListItemClicked(self.Content, true)
  end
  self.bPlayClickTransition = false
end

function M:HandleConfirm()
  self:ClearNew()
  if self.ParentAction and self.ParentAction.PlayAction then
    return self.ParentAction:PlayAction(self.Content) ~= false
  end
  return true
end

return M
