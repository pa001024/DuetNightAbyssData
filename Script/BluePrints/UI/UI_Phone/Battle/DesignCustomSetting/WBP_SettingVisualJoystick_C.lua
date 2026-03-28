require("UnLua")
local BattleHUDCommonConst = require("BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Initialize(Initializer)
  self.RelativeNodeWidgetName = nil
  self.RelativeNodeWidgetInfo = nil
  self.TouchAreaWidget = nil
  self.LayoutLocalSize = nil
  self.CurAreaRangeXPercent = BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeXPercent
end

function M:InitRelativeNodeSaveData(RelativeWidget, SaveData, Params)
  self.bHasLocalChanges = false
  self.RelativeNodeWidgetInfo = {Widget = RelativeWidget, Data = SaveData}
  self.RelativeNodeWidgetName = Params.RelativeName
  self.TouchAreaWidget = Params.TouchAreaWidget
  self.TouchAreaWidget:InitData(self, self.OnModifyPropertyWithMoving)
end

function M:IsHasLocalChanges()
  return self.bHasLocalChanges
end

function M:GetRelativeNodeSaveData()
  return self.RelativeNodeWidgetInfo
end

function M:GetAreaRangeXPercent()
  return self.CurAreaRangeXPercent
end

function M:GetAreaRangeYPercent()
  return self.CurAreaRangeYPercent
end

function M:ResetRelativeNodeToDefault()
  self.CurAreaRangeXPercent = BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeXPercent
  self:ResetToDefaultValue(BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent)
end

function M:UpdateRelativeNodeWhenSelected()
  local RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
  if not RelativeNodeWidget then
    DebugPrint("SettingVisualJoystick== UpdateRelativeNodeWhenSelected: RelativeNodeWidget is nil")
    return
  end
  RelativeNodeWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.bHasLocalChanges then
    DebugPrint("SettingVisualJoystick== UpdateRelativeNodeWhenSelected: Has Local Changes, Skip Update")
    return
  end
  if not self.RelativeNodeWidgetInfo then
    DebugPrint("SettingVisualJoystick== UpdateRelativeNodeWhenSelected: RelativeNodeWidgetInfo is nil")
    return
  end
  local RelativeNodeSaveData = self.RelativeNodeWidgetInfo.Data or {}
  local RelativeNodeSlot = RelativeNodeWidget.Slot
  if RelativeNodeSlot then
    local LayoutWidgetGeometry = self.OwnerWidget:GetCachedGeometry()
    local WidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
    self.LayoutLocalSize = WidgetLocalSize
    DebugPrint("SettingVisualJoystick== UpdateRelativeNodeWhenSelected: Update MoveRangePos RelativeNodeSaveData is ", RelativeNodeSaveData.AreaRangeSizeY, RelativeNodeSaveData.AreaRangeSizeYPercent, WidgetLocalSize.Y)
    if RelativeNodeSaveData.AreaRangeSizeY then
      RelativeNodeSlot:SetSize(FVector2D(0, RelativeNodeSaveData.AreaRangeSizeY))
      self.CurAreaRangeYPercent = RelativeNodeSaveData.AreaRangeSizeY / WidgetLocalSize.Y
    else
      RelativeNodeSlot:SetSize(FVector2D(0, WidgetLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent))
      self.CurAreaRangeYPercent = BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent
    end
  end
end

function M:OnModifyPropertyWithMoving(LastPosition, CurPosition)
  if not self.LayoutLocalSize then
    local LayoutWidgetGeometry = self.OwnerWidget:GetCachedGeometry()
    self.LayoutLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
  end
  local RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
  local RelativeNodeSlot = RelativeNodeWidget.Slot
  if RelativeNodeSlot then
    self.bHasLocalChanges = true
    local DeltaValueY = LastPosition.Y - CurPosition.Y
    local DesireRelativeSizeY = UE.UKismetMathLibrary.FClamp(RelativeNodeSlot:GetSize().Y + DeltaValueY, self.LayoutLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin, self.LayoutLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMax)
    RelativeNodeSlot:SetSize(FVector2D(0, DesireRelativeSizeY))
    self.CurAreaRangeYPercent = DesireRelativeSizeY / self.LayoutLocalSize.Y
    self:CallOwnerRefreshForRelativeNodeChange()
    self:AdjustPositioByRelativeWidgetChange(self.ParentLayoutNode or self.DraggableWidget)
    DebugPrint("SettingVisualJoystick== OnModifyPropertyWithMoving: Update MoveRangePos DesireRelativeSizeY is ", DesireRelativeSizeY, ", The Percent is ", self.CurAreaRangeYPercent)
  end
end

function M:OnModifyPropertyWithSlideChange(NewValue)
  if not self.LayoutLocalSize then
    local LayoutWidgetGeometry = self.OwnerWidget:GetCachedGeometry()
    self.LayoutLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
  end
  local RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
  local RelativeNodeSlot = RelativeNodeWidget.Slot
  if RelativeNodeSlot then
    self.bHasLocalChanges = true
    local DesireRelativeSizeY = UE.UKismetMathLibrary.FClamp(self.LayoutLocalSize.Y * NewValue, self.LayoutLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin, self.LayoutLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMax)
    RelativeNodeSlot:SetSize(FVector2D(0, DesireRelativeSizeY))
    self.CurAreaRangeYPercent = DesireRelativeSizeY / self.LayoutLocalSize.Y
    self:AdjustPositioByRelativeWidgetChange(self.ParentLayoutNode or self.DraggableWidget)
    DebugPrint("SettingVisualJoystick== OnModifyPropertyWithSlideChange: Update MoveRangePos DesireRelativeSizeY is ", DesireRelativeSizeY, ", The Percent is ", self.CurAreaRangeYPercent)
  end
end

function M:ResetToDefaultValue(DefaultValue)
  if not self.LayoutLocalSize then
    local LayoutWidgetGeometry = self.OwnerWidget:GetCachedGeometry()
    self.LayoutLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
  end
  local RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
  local RelativeNodeSlot = RelativeNodeWidget.Slot
  if RelativeNodeSlot then
    self.bHasLocalChanges = true
    local DesireRelativeSizeY = self.LayoutLocalSize.Y * DefaultValue
    RelativeNodeSlot:SetSize(FVector2D(0, DesireRelativeSizeY))
    self.CurAreaRangeYPercent = DefaultValue
    self:CallOwnerRefreshForRelativeNodeChange()
    DebugPrint("SettingVisualJoystick== ResetToDefaultValue: Update MoveRangePos DesireRelativeSizeY is ", DesireRelativeSizeY, ", The Percent is ", self.CurAreaRangeYPercent)
  end
end

function M:CallOwnerRefreshForRelativeNodeChange()
  if self.OwnerWidget and type(self.OwnerWidget.UpdateSliderValue) == "function" then
    self.OwnerWidget:UpdateSliderValue("Stretch", self.CurAreaRangeYPercent)
  end
end

function M:HideRelativeNodeWhenUnSelected(bHide)
  local RelativeNodeWidget
  if self.RelativeNodeWidgetInfo then
    RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
  elseif self.RelativeNodeName then
    RelativeNodeWidget = self.OwnerWidget[self.RelativeNodeName]
  end
  if RelativeNodeWidget then
    RelativeNodeWidget:SetVisibility(bHide and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

AssembleComponents(M)
return M
