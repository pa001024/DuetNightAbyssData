local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.RewardSwitchTipWidget = nil
end

function M:Destruct()
  self.RewardSwitchTipWidget = nil
end

function M:Init(EventId, CurrentRoundNumber, MaxRoundNumber, OnClosed)
  local Widget = self:CreateRewardSwitchTipWidget(EventId)
  if not IsValid(Widget) then
    return false
  end
  self.RewardSwitchTipWidget = Widget
  self:AttachWidgetToPosNode(Widget)
  Widget:SetRoundInfo(CurrentRoundNumber, MaxRoundNumber)
  Widget:SetOnClosed({
    self,
    function()
      self:RemoveFromParent()
      if type(OnClosed) == "function" then
        OnClosed()
      elseif type(OnClosed) == "table" and OnClosed[1] and OnClosed[2] then
        OnClosed[2](OnClosed[1])
      end
    end
  })
  Widget:PlayRoundSwitchTip()
  return true
end

function M:CreateRewardSwitchTipWidget(EventId)
  local BPPath = self:GetBPPath(EventId)
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

function M:GetBPPath(EventId)
  if not DataMgr or not DataMgr.LimitedPrizePool then
    return nil
  end
  local PoolData = DataMgr.LimitedPrizePool[EventId]
  if not PoolData then
    return nil
  end
  return PoolData.RoundBPPath
end

return M
