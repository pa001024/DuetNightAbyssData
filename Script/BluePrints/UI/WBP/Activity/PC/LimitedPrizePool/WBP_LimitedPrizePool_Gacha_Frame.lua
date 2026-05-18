local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local DEFAULT_PROCESS_BP_P = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/WBP_LimitedPrizePool_Gacha_P.WBP_LimitedPrizePool_Gacha_P'"
local DEFAULT_PROCESS_BP_M = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/WBP_LimitedPrizePool_Gacha_M.WBP_LimitedPrizePool_Gacha_M'"

function M:GetProcessBPByEventId(EventId)
  local PoolData = EventId and DataMgr.LimitedPrizePool and DataMgr.LimitedPrizePool[EventId]
  local ProcessBPPath = PoolData and PoolData.ProcessBPPath
  local ProcessMobileBPPath = PoolData and PoolData.ProcessMobileBPPath
  ProcessBPPath = ProcessBPPath or DEFAULT_PROCESS_BP_P
  ProcessMobileBPPath = ProcessMobileBPPath or DEFAULT_PROCESS_BP_M
  if UIUtils.IsMobileInput() then
    return ProcessMobileBPPath
  end
  return ProcessBPPath
end

function M:GetChildRoot()
  return self.Pos_Node
end

function M:AddChildToRoot(ChildWidget)
  local Root = self:GetChildRoot()
  if not Root or not ChildWidget then
    return
  end
  Root:ClearChildren()
  local Slot = Root:AddChild(ChildWidget)
  local Anchors = FAnchors()
  Anchors.Minimum = FVector2D(0, 0)
  Anchors.Maximum = FVector2D(1, 1)
  Slot:SetAnchors(Anchors)
  Slot:SetOffsets(FMargin(0, 0, 0, 0))
  Slot:SetAlignment(FVector2D(0, 0))
end

function M:Init(...)
  local Params = {
    ...
  }
  local EventId = Params[8]
  local BPPath = self:GetProcessBPByEventId(EventId)
  self.InnerWidget = UIManager(self):CreateWidget(BPPath)
  if not self.InnerWidget then
    DebugPrint("WBP_LimitedPrizePool_Gacha_Frame:Init, create child failed, EventId =", EventId, "BPPath =", BPPath)
    return
  end
  self:AddChildToRoot(self.InnerWidget)
  self.InnerWidget.Parent = self
  self.InnerWidget:Init(table.unpack(Params))
end

return M
