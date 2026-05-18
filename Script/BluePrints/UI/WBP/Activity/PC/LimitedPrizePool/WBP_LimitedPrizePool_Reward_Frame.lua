local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local DEFAULT_RESULT_BP_P = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/WBP_LimitedPrizePool_GetReward_P.WBP_LimitedPrizePool_GetReward_P'"
local DEFAULT_RESULT_BP_M = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/WBP_LimitedPrizePool_GetReward_M.WBP_LimitedPrizePool_GetReward_M'"

function M:GetResultBPByEventId(EventId)
  local PoolData = EventId and DataMgr.LimitedPrizePool and DataMgr.LimitedPrizePool[EventId]
  local ResultBPPath = PoolData and PoolData.ResultBPPath
  local ResultMobileBPPath = PoolData and PoolData.ResultMobileBPPath
  ResultBPPath = ResultBPPath or DEFAULT_RESULT_BP_P
  ResultMobileBPPath = ResultMobileBPPath or DEFAULT_RESULT_BP_M
  if UIUtils.IsMobileInput() then
    return ResultMobileBPPath
  end
  return ResultBPPath
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

function M:OnLoaded(...)
  local Params = {
    ...
  }
  local EventId = Params[6]
  local BPPath = self:GetResultBPByEventId(EventId)
  self.InnerWidget = UIManager(self):CreateWidget(BPPath)
  if not self.InnerWidget then
    DebugPrint("WBP_LimitedPrizePool_Reward_Frame:OnLoaded, create child failed, EventId =", EventId, "BPPath =", BPPath)
    return
  end
  self:AddChildToRoot(self.InnerWidget)
  self.InnerWidget.Parent = self
  self.InnerWidget:Init(table.unpack(Params))
end

return M
