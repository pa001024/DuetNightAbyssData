local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.SelectPrizeWidget = nil
  self.bHasRequestedActivityEntryVideoRefresh = false
end

function M:Destruct()
  self:NotifyActivityEntryVideoRefresh()
  self.SelectPrizeWidget = nil
end

function M:Init(PoolId, Prizes, OnConfirmSelection, OnClosed)
  local Widget = self:CreateSelectPrizeWidget(PoolId)
  if not IsValid(Widget) then
    return false
  end
  self.SelectPrizeWidget = Widget
  self:AttachWidgetToPosNode(Widget)
  Widget:Init(PoolId, Prizes, OnConfirmSelection, {
    self,
    function()
      self:RemoveFromParent()
      if type(OnClosed) == "function" then
        OnClosed()
      elseif type(OnClosed) == "table" and OnClosed[1] and OnClosed[2] then
        OnClosed[2](OnClosed[1])
      end
      self:NotifyActivityEntryVideoRefresh()
    end
  })
  return true
end

function M:Close()
  if self.SelectPrizeWidget and self.SelectPrizeWidget.Close then
    self.SelectPrizeWidget:Close()
  else
    self:RemoveFromParent()
    self:NotifyActivityEntryVideoRefresh()
  end
end

function M:NotifyActivityEntryVideoRefresh()
  if self.bHasRequestedActivityEntryVideoRefresh then
    return
  end
  self.bHasRequestedActivityEntryVideoRefresh = true
  EventManager:FireEvent(ActivityCommon.EventId.RefreshActivityEntryVideo)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.SelectPrizeWidget and self.SelectPrizeWidget.OnKeyDown then
    return self.SelectPrizeWidget:OnKeyDown(MyGeometry, InKeyEvent)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if self.SelectPrizeWidget and self.SelectPrizeWidget.OnAnalogValueChanged then
    return self.SelectPrizeWidget:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:CreateSelectPrizeWidget(PoolId)
  local BPPath = self:GetBPPath(PoolId)
  if not BPPath then
    return nil
  end
  return UIManager(self):CreateWidget(BPPath)
end

function M:AttachWidgetToPosNode(Widget)
  self.Pos_Node:ClearChildren()
  self.Pos_Node:AddChild(Widget)
  self:SetWidgetFullscreenInCanvas(Widget)
end

function M:SetWidgetFullscreenInCanvas(Widget)
  local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Widget)
  if not IsValid(CanvasSlot) then
    return
  end
  local Anchors = CanvasSlot:GetAnchors()
  Anchors.Minimum = FVector2D(0, 0)
  Anchors.Maximum = FVector2D(1, 1)
  CanvasSlot:SetAnchors(Anchors)
  CanvasSlot:SetOffsets(FMargin(0, 0, 0, 0))
end

function M:GetBPPath(PoolId)
  local PoolData = self:GetPoolData(PoolId)
  if not PoolData then
    return nil
  end
  if self:IsMobilePlatform() then
    return PoolData.BigPrizeMobileBPPath
  else
    return PoolData.BigPrizeBPPath
  end
end

function M:GetPoolData(PoolId)
  if not DataMgr or not DataMgr.LimitedPrizePool then
    return nil
  end
  if PoolId and DataMgr.LimitedPrizePool[PoolId] then
    return DataMgr.LimitedPrizePool[PoolId]
  end
  return nil
end

function M:IsMobilePlatform()
  return CommonUtils and CommonUtils.GetDeviceTypeByPlatformName and CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
end

return M
