local M = {}

function M:InitAllDraggableWidgetInfo(OwnerWidget, WidgetInfo)
  local ParentLayoutNode = OwnerWidget[WidgetInfo.ParentNodeName]
  local DraggableWidget = OwnerWidget[WidgetInfo.WidgetName]
  self:RegisterDraggableComponent(OwnerWidget, DraggableWidget, ParentLayoutNode, WidgetInfo.InnerActiveSlateName, WidgetInfo.MaskNodeName)
end

function M:LeaveDesignState()
  self:UnSelectWidget()
  self:UnRegisterDraggableComponent()
end

function M:SelectWidget()
  local TargetMaskWidget
  if type(self.MaskNodeName) == "table" then
    local TargetMaskWidgetName = self.MaskNodeName[self.CurEditPlanIndex]
    if nil ~= TargetMaskWidgetName then
      TargetMaskWidget = self.OwnerWidget[TargetMaskWidgetName]
    end
  else
    TargetMaskWidget = self.OwnerWidget[self.MaskNodeName]
  end
  if nil ~= TargetMaskWidget then
    TargetMaskWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetSelected) == "function" then
    self.OwnerWidget:OnDraggableWidgetSelected(self)
  end
end

function M:UnSelectWidget()
  local TargetMaskWidget
  if type(self.MaskNodeName) == "table" then
    local TargetMaskWidgetName = self.MaskNodeName[self.CurEditPlanIndex]
    if nil ~= TargetMaskWidgetName then
      TargetMaskWidget = self.OwnerWidget[TargetMaskWidgetName]
    end
  else
    TargetMaskWidget = self.OwnerWidget[self.MaskNodeName]
  end
  if nil ~= TargetMaskWidget then
    TargetMaskWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:EnterDesignState(CurEditPlanIndex)
  self.CurEditPlanIndex = CurEditPlanIndex
end

function M:MoveWidgetByOffset(Offset)
  if not IsValid(self.DraggableWidget) then
    return
  end
  local CurParentNodePos = self:GetWidgetPosition()
  local NewPosition = CurParentNodePos + Offset
  self:SetWidgetPosition(NewPosition)
  if self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetInfoChanged) == "function" then
    self.OwnerWidget:OnDraggableWidgetInfoChanged("Pos", self, NewPosition)
  end
end

function M:ModifyWidgetScale(ScaleValue)
  local WidgetNode = self.ParentLayoutNode or self.DraggableWidget
  if not IsValid(WidgetNode) then
    DebugPrint("DraggableWidgetComponent== Error: ModifyWidgetScale failed, ParentLayoutNode is invalid!")
    return
  end
  WidgetNode:SetRenderScale(FVector2D(ScaleValue, ScaleValue))
  if self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetInfoChanged) == "function" then
    self.OwnerWidget:OnDraggableWidgetInfoChanged("Scale", self, ScaleValue)
  end
end

function M:RegisterDraggableComponent(OwnerWidget, DraggableWidget, ParentLayoutNode, InnerActiveSlateName, MaskNodeName)
  self.OwnerWidget = OwnerWidget
  self.DraggableWidget = DraggableWidget
  self.ParentLayoutNode = ParentLayoutNode
  self.InnerActiveSlateName = InnerActiveSlateName
  self.MaskNodeName = MaskNodeName
  self.bIsDragging = false
  self.StartPosition = FVector2D(0, 0)
  self.CurrnetPositionInScreen = FVector2D(0, 0)
  self.DragOffset = FVector2D(0, 0)
  self.TouchPointLocalOffset = nil
  self:InitializeVariable()
end

function M:UnRegisterDraggableComponent()
  self:SetDraggable(false)
  DebugPrint("DraggableWidgetComponent== DraggableWidget destroyed")
end

function M:InitializeVariable()
  if not self.DraggableWidget then
    self.DraggableWidget = self
  end
  self:SetDraggable(true)
  DebugPrint("DraggableWidgetComponent== Initialized Successfully!")
end

function M:SetDraggable(bEnabled)
  if IsValid(self.DraggableWidget) then
    if bEnabled then
      self.DraggableWidget:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.DraggableWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
  if type(self.InnerActiveSlateName) == "table" then
    for index, WidgetName in ipairs(self.InnerActiveSlateName) do
      local FindWidget
      if type(WidgetName) == "table" then
        local PathLength = #WidgetName
        FindWidget = self.DraggableWidget[WidgetName[1]]
        for i = 2, PathLength do
          FindWidget = FindWidget[WidgetName[i]]
        end
      else
        FindWidget = self.DraggableWidget[WidgetName]
      end
      if nil ~= FindWidget and IsValid(FindWidget) then
        if bEnabled then
          FindWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
          FindWidget:SetVisibility(UE4.ESlateVisibility.Visible)
        end
      end
    end
  else
    local TargetWidget = self.DraggableWidget[self.InnerActiveSlateName]
    if IsValid(TargetWidget) then
      if bEnabled then
        TargetWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      else
        TargetWidget:SetVisibility(UE4.ESlateVisibility.Visible)
      end
    end
  end
  self.bDraggable = bEnabled
end

function M:OnTouchStarted(MyGeometry, InGestureEvent)
  if not self.bDraggable then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  self.bIsDragging = true
  self:SelectWidget()
  local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
  self.StartPosition = ScreenSpacePosition
  local LayoutWidgetGeometry = self.ParentLayoutNode:GetCachedGeometry()
  self.TouchPointLocalOffset = UE4.USlateBlueprintLibrary.AbsoluteToLocal(LayoutWidgetGeometry, ScreenSpacePosition)
  DebugPrint("DraggableWidgetComponent== Start dragging, Position in Screen Space is :", ScreenSpacePosition, ", TouchPoint LocalOffset is :", self.TouchPointLocalOffset)
  local Handled = UE4.UWidgetBlueprintLibrary.Handled()
  return UE4.UWidgetBlueprintLibrary.CaptureMouse(Handled, self.DraggableWidget)
end

function M:OnTouchMoved(MyGeometry, InGestureEvent)
  if not self.bIsDragging then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
  ScreenSpacePosition = self:ClampPositionToViewport(ScreenSpacePosition, MyGeometry)
  local FinalPosition = UIUtils.GetRelativePositionInParent(self.ParentLayoutNode, ScreenSpacePosition, self.TouchPointLocalOffset)
  self.DragOffset = ScreenSpacePosition - self.StartPosition
  self.CurrnetPositionInScreen = ScreenSpacePosition
  self:SetWidgetPosition(FinalPosition)
  if self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetInfoChanged) == "function" then
    self.OwnerWidget:OnDraggableWidgetInfoChanged("Pos", self, FinalPosition)
  end
  DebugPrint("DraggableWidgetComponent== Dragging OnTouchMoved to:  ", FinalPosition)
  return UIUtils.Handled
end

function M:OnTouchEnded(MyGeometry, MouseEvent)
  if not self.bDraggable then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  self.bIsDragging = false
  self.DragOffset = FVector2D(0, 0)
  self.TouchPointLocalOffset = nil
  DebugPrint("DraggableWidgetComponent== Stop dragging")
  if self.DraggableWidget:HasMouseCapture() then
    local Handled = UE4.UWidgetBlueprintLibrary.Handled()
    return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(Handled)
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

function M:SetWidgetPosition(Position)
  if self.ParentLayoutNode then
    local Slot = self.ParentLayoutNode.Slot
    if Slot then
      Slot:SetPosition(Position)
    else
      self.DraggableWidget:SetPositionInViewport(Position)
    end
  else
    self.DraggableWidget:SetPositionInViewport(Position)
  end
end

function M:GetWidgetPosition()
  if self.ParentLayoutNode then
    local Slot = self.ParentLayoutNode.Slot
    if Slot then
      return Slot:GetPosition()
    else
      return FVector2D(0, 0)
    end
  else
    return FVector2D(0, 0)
  end
end

function M:ClampPositionToViewport(Position, MyGeometry)
  local ViewportSize = UIManager(self):GetViewportSize()
  if 0 == ViewportSize.X or 0 == ViewportSize.Y then
    return Position
  end
  local ParentGeometry = self.OwnerWidget:GetCachedGeometry()
  local LocalTopLeftPosition = UE4.USlateBlueprintLibrary.LocalToAbsolute(ParentGeometry, UE4.USlateBlueprintLibrary.GetLocalTopLeft(ParentGeometry))
  local RenderLocalScale = self.ParentLayoutNode and self.ParentLayoutNode.RenderTransform.Scale.X or 1.0
  local WidgetSize = UE4.USlateBlueprintLibrary.GetLocalSize(MyGeometry) * RenderLocalScale
  local ClampedX = UE.UKismetMathLibrary.FClamp(Position.X, LocalTopLeftPosition.X + WidgetSize.X * 0.5, LocalTopLeftPosition.X + ViewportSize.X - WidgetSize.X * 0.5)
  local ClampedY = UE.UKismetMathLibrary.FClamp(Position.Y, LocalTopLeftPosition.Y + WidgetSize.Y * 0.5, LocalTopLeftPosition.Y + ViewportSize.Y - WidgetSize.Y * 0.5)
  return FVector2D(ClampedX, ClampedY)
end

function M:IsDragging()
  return self.bIsDragging
end

return M
