local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:Construct()
  self.DetailHistoryContentWidget = nil
end

function M:Destruct()
  self.DetailHistoryContentWidget = nil
end

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  local Widget = self:CreateDetailHistoryContentWidget(Params and Params.PoolId)
  if not IsValid(Widget) then
    return false
  end
  self.DetailHistoryContentWidget = Widget
  self:AttachWidgetToPosNode(Widget)
  Widget:ApplyInitContent(Params)
  return true
end

function M:InitGamepadView()
  if self.DetailHistoryContentWidget and self.DetailHistoryContentWidget.ApplyGamepadView then
    self.DetailHistoryContentWidget:ApplyGamepadView()
  end
end

function M:InitKeyboardView()
  if self.DetailHistoryContentWidget and self.DetailHistoryContentWidget.ApplyKeyboardView then
    self.DetailHistoryContentWidget:ApplyKeyboardView()
  end
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  if self.DetailHistoryContentWidget and self.DetailHistoryContentWidget.HandleContentKeyDown then
    return self.DetailHistoryContentWidget:HandleContentKeyDown(MyGeometry, InKeyEvent)
  end
  return false
end

function M:CreateDetailHistoryContentWidget(PoolId)
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
  if not (PoolId and DataMgr) or not DataMgr.LimitedPrizePool then
    return nil
  end
  local PoolData = DataMgr.LimitedPrizePool[PoolId]
  if not PoolData then
    return nil
  end
  return PoolData.HistoryBPPath
end

return M
