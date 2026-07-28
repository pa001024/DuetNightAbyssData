require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:FindChildren()
end

function M:FindChildren()
  self.TextCostNum = self.TextBlock
  self.TextCostDesc = self.TextBlock_268
end

function M:InitContent()
  self:FindChildren()
end

function M:Refresh(RankLevel, RankScore)
  RankLevel = RankLevel or 1
  RankScore = RankScore or 0
  local RankInfo = DataMgr.AutoChessPoint[RankLevel]
  if not RankInfo then
    DebugPrint("WBP_Activity_AutoChess_RankNew: invalid RankLevel " .. tostring(RankLevel))
    return
  end
  if self.TextBlock_205 then
    self.TextBlock_205:SetText(GText(RankInfo.RankName))
  end
  if self.Icon_Rank and RankInfo.RankIcon then
    local RankIcon = LoadObject(RankInfo.RankIcon)
    if RankIcon then
      self.Icon_Rank:SetBrushFromTexture(RankIcon)
    end
  end
  if self.TextCostNum then
    self.TextCostNum:SetText(tostring(RankInfo.BattleCost or 0))
  end
  if self.TextCostDesc then
    self.TextCostDesc:SetText(GText("UI_AutoChess_CurrentCost"))
  end
end

return M
