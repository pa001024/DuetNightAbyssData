local M = {}

function M:InitAllDraggableWidgetInfo(OwnerWidget, WidgetInfo)
  local ParentLayoutNode = OwnerWidget[WidgetInfo.ParentNodeName]
  local DraggableWidget = OwnerWidget[WidgetInfo.WidgetName]
  self:RegisterDraggableComponent(OwnerWidget, DraggableWidget, ParentLayoutNode, WidgetInfo)
end

function M:LeaveDesignState()
  self:UnSelectWidget()
  self:UnRegisterDraggableComponent()
end

function M:SelectWidget()
  local TargetMaskWidget = self:GetSelectWidgetMaskWidget()
  if nil ~= TargetMaskWidget then
    TargetMaskWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.RelativeNodeName then
    self:UpdateRelativeNodeWhenSelected()
  end
  if self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetSelected) == "function" then
    self.OwnerWidget:OnDraggableWidgetSelected(self)
  end
end

function M:UnSelectWidget()
  local TargetMaskWidget = self:GetSelectWidgetMaskWidget()
  if nil ~= TargetMaskWidget then
    TargetMaskWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.RelativeNodeName then
    self:HideRelativeNodeWhenUnSelected(true)
  end
end

function M:GetSelectWidgetMaskWidget()
  local TargetMaskWidget
  if type(self.MaskNodeName) == "table" then
    local MappedPlanIndex = self:_GetMappedPlanIndex(self.CurEditPlanIndex)
    local TargetMaskWidgetName = self.MaskNodeName[MappedPlanIndex]
    if nil ~= TargetMaskWidgetName then
      TargetMaskWidget = self.OwnerWidget[TargetMaskWidgetName]
    end
  else
    TargetMaskWidget = self.OwnerWidget[self.MaskNodeName]
  end
  return TargetMaskWidget
end

function M:_GetMappedPlanIndex(EditPlanIndex)
  if nil == EditPlanIndex then
    return 1
  end
  return (EditPlanIndex - 1) % 2 + 1
end

function M:GetSelectWidgetTextMapContent()
  return self.TextMapContent
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
  self:AdjustPositionByScaleValueChange(WidgetNode)
  if self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetInfoChanged) == "function" then
    self.OwnerWidget:OnDraggableWidgetInfoChanged("Scale", self, ScaleValue)
  end
end

function M:RegisterDraggableComponent(OwnerWidget, DraggableWidget, ParentLayoutNode, WidgetInfo)
  self.OwnerWidget = OwnerWidget
  self.DraggableWidget = DraggableWidget
  self.ParentLayoutNode = ParentLayoutNode
  self.WidgetNodeName = WidgetInfo.WidgetName
  self.TextMapContent = WidgetInfo.TextMapContent
  self.InnerActiveSlateName = WidgetInfo.InnerActiveSlateName
  self.MaskNodeName = WidgetInfo.MaskNodeName
  self.bHasExtraLimitArea = WidgetInfo.bHasExtraLimitArea
  self.bIsNeedManualAdd = WidgetInfo.bIsNeedManualAdd
  self.RelativeNodeName = WidgetInfo.RelativeNodeName
  self.bIsDragging = false
  self.StartPosition = FVector2D(0, 0)
  self.CurrentPositionInScreen = FVector2D(0, 0)
  self.DragOffset = FVector2D(0, 0)
  self.TouchPointLocalOffset = nil
  self.LimitDraggableArea = nil
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

function M:SetManualAddInSetting(bAddInSetting)
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
  self:SetDraggableArea(LayoutWidgetGeometry)
  DebugPrint("DraggableWidgetComponent== Start dragging, Position in Screen Space is :", ScreenSpacePosition, ", TouchPoint LocalOffset is :", self.TouchPointLocalOffset)
  local Handled = UE4.UWidgetBlueprintLibrary.Handled()
  return UE4.UWidgetBlueprintLibrary.CaptureMouse(Handled, self.DraggableWidget)
end

function M:OnTouchMoved(MyGeometry, InGestureEvent)
  if not self.bIsDragging then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
  ScreenSpacePosition = self:ClampPositionToViewport(ScreenSpacePosition)
  local FinalPosition = UIUtils.GetRelativePositionInParent(self.ParentLayoutNode, ScreenSpacePosition, self.TouchPointLocalOffset)
  self.DragOffset = ScreenSpacePosition - self.StartPosition
  self.CurrentPositionInScreen = ScreenSpacePosition
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

function M:ClampPositionToViewport(Position)
  if self.LimitDraggableArea == nil then
    return Position
  end
  local StartClampedX = self.LimitDraggableArea.MinX
  local EndClampedX = self.LimitDraggableArea.MaxX
  local StartClampedY = self.LimitDraggableArea.MinY
  local EndClampedY = self.LimitDraggableArea.MaxY
  local ClampedX = UE.UKismetMathLibrary.FClamp(Position.X, StartClampedX, EndClampedX)
  local ClampedY = UE.UKismetMathLibrary.FClamp(Position.Y, StartClampedY, EndClampedY)
  return FVector2D(ClampedX, ClampedY)
end

function M:SetDraggableArea(DraggableWidgetGeometry)
  local ParentGeometry
  if self.OwnerWidget.SafeZone then
    local SafeZoneChildContent = self.OwnerWidget.SafeZone:GetContent()
    if SafeZoneChildContent then
      ParentGeometry = SafeZoneChildContent:GetCachedGeometry()
    else
      ParentGeometry = self.OwnerWidget:GetCachedGeometry()
    end
  else
    ParentGeometry = self.OwnerWidget:GetCachedGeometry()
  end
  if nil == ParentGeometry then
    self.LimitDraggableArea = nil
    return
  end
  local AbsoluteTopLeftPosition = UE4.USlateBlueprintLibrary.LocalToAbsolute(self.OwnerWidget:GetCachedGeometry(), UE4.USlateBlueprintLibrary.GetLocalTopLeft(ParentGeometry))
  local AbsoluteParentSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(ParentGeometry)
  local WidgetAbsoluteSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(DraggableWidgetGeometry)
  local WidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(DraggableWidgetGeometry)
  local StartClampedX = AbsoluteTopLeftPosition.X + WidgetAbsoluteSize.X * (self.TouchPointLocalOffset.X / WidgetLocalSize.X)
  local EndClampedX = AbsoluteTopLeftPosition.X + AbsoluteParentSize.X - WidgetAbsoluteSize.X * (1 - self.TouchPointLocalOffset.X / WidgetLocalSize.X)
  local StartClampedY = AbsoluteTopLeftPosition.Y + WidgetAbsoluteSize.Y * (self.TouchPointLocalOffset.Y / WidgetLocalSize.Y)
  local EndClampedY = AbsoluteTopLeftPosition.Y + AbsoluteParentSize.Y - WidgetAbsoluteSize.Y * (1 - self.TouchPointLocalOffset.Y / WidgetLocalSize.Y)
  if self.bHasExtraLimitArea then
    self:UpdateLimitDraggableAreaFromDesign(StartClampedX, EndClampedX, StartClampedY, EndClampedY, AbsoluteParentSize)
  else
    self.LimitDraggableArea = {
      MinX = StartClampedX,
      MaxX = EndClampedX,
      MinY = StartClampedY,
      MaxY = EndClampedY
    }
  end
end

function M:UpdateLimitDraggableAreaFromDesign(StartClampedX, EndClampedX, StartClampedY, EndClampedY, AbsoluteParentSize)
  if self.WidgetNodeName == "Move" then
    local CurAreaRangeXPercent = self.CurAreaRangeXPercent
    local CurAreaRangeYPercent = self.CurAreaRangeYPercent
    local NewEndClampedX = EndClampedX - AbsoluteParentSize.X * CurAreaRangeXPercent
    local NewStartClampedY = StartClampedY + AbsoluteParentSize.Y * (1.0 - CurAreaRangeYPercent)
    self.LimitDraggableArea = {
      MinX = StartClampedX,
      MaxX = NewEndClampedX,
      MinY = NewStartClampedY,
      MaxY = EndClampedY
    }
  else
    self.LimitDraggableArea = {
      MinX = StartClampedX,
      MaxX = EndClampedX,
      MinY = StartClampedY,
      MaxY = EndClampedY
    }
  end
end

function M:AdjustPositionByScaleValueChange(AdjustWidget)
  local DraggableWidgetGeometry = AdjustWidget:GetCachedGeometry()
  local AdjustWidgetAbsolutePos = UIManager(self.OwnerWidget):GetWorldPosition(AdjustWidget)
  local AdjustWidgetAbsoluteSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(DraggableWidgetGeometry)
  local AdjustWidgetAbsoluteCenterPos = FVector2D(AdjustWidgetAbsolutePos.X + AdjustWidgetAbsoluteSize.X / 2, AdjustWidgetAbsolutePos.Y + AdjustWidgetAbsoluteSize.Y / 2)
  local AdjustWidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(DraggableWidgetGeometry)
  self.TouchPointLocalOffset = FVector2D(AdjustWidgetLocalSize.X / 2, AdjustWidgetLocalSize.Y / 2)
  self:SetDraggableArea(DraggableWidgetGeometry)
  local FinalAbsolutePosition = self:ClampPositionToViewport(AdjustWidgetAbsoluteCenterPos)
  local FinalPosition = UIUtils.GetRelativePositionInParent(AdjustWidget, FinalAbsolutePosition, self.TouchPointLocalOffset)
  self:SetWidgetPosition(FinalPosition)
end

function M:AdjustPositioByRelativeWidgetChange(AdjustWidget)
  self:AdjustPositionByScaleValueChange(AdjustWidget)
end

function M:IsDragging()
  return self.bIsDragging
end

return M
