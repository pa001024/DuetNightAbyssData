require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.UI_PC.Common.ScoreTierReward.ScoreTierRewardItemComponent"
})

function M:Construct()
  self:ScoreTierRewardItem_Construct()
end

function M:Destruct()
  self:ScoreTierRewardItem_Destruct()
end

function M:OnListItemObjectSet(Content)
  self:ScoreTierRewardItem_OnListItemObjectSet(Content)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return self:ScoreTierRewardItem_OnKeyDown(MyGeometry, InKeyEvent)
end

return M
