require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Text_Designation:SetText(GText(Content.GoodsName))
  self.Text_Type:SetText(Content.Score)
  self.Text_Time:SetText(TimeUtils.TimeToYMDStr(Content.ScoreTime, nil, "/") .. " " .. TimeUtils.TimeToHMSStr(Content.ScoreTime, nil, ":"))
  self:SetBg(Content.Id)
end

function M:SetBg(Index)
  local num1, num2 = math.modf(Index / 2)
  if 0 == num2 then
    self.Image_ItemBG:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Image_ItemBG:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

return M
