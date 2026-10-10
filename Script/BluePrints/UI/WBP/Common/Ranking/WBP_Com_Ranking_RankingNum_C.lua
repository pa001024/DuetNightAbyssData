require("UnLua")
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.RankIconTextures = {}
  for _, Path in ipairs(ComRankingUtils.RankIconPath) do
    table.insert(self.RankIconTextures, LoadObject(Path))
  end
end

function M:Init(Data)
  Data = Data or {}
  local RankNum = Data.RankNum
  local RankNumText = Data.RankNumText
  if nil == RankNumText and (nil == RankNum or RankNum <= 0) then
    if self.WS_Type then
      self.WS_Type:SetActiveWidgetIndex(1)
    end
    return
  end
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(0)
  end
  if RankNumText then
    if self.Text_Ranking then
      self.Text_Ranking:SetText(GText(RankNumText))
    end
    if self.Image_RankIcon then
      self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    return
  end
  if RankNum >= 1 and RankNum <= 3 then
    if self.Image_RankIcon then
      self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Visible)
      local IconTexture = self.RankIconTextures[RankNum] or LoadObject(ComRankingUtils.RankIconPath[RankNum])
      self.Image_RankIcon:SetBrushFromTexture(IconTexture)
    end
  elseif self.Image_RankIcon then
    self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Text_Ranking then
    self.Text_Ranking:SetText(RankNum)
  end
end

return M
