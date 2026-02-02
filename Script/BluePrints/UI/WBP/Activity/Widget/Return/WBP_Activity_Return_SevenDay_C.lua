require("UnLua")
local ReturnUtils = require("BluePrints.UI.WBP.Activity.Widget.Return.ReturnUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent"
})

function M:Destruct()
  self:StopAllAnimations()
  self.InitParams = nil
  self.ParentWidget = nil
end

function M:Init(InitParams)
  self.InitParams = InitParams
  self.CurActivityId = InitParams.CurActivityId
  self.ParentWidget = InitParams.OwnerPanel
  InitParams.PageConfigData.bComeBackEvent = true
  self.SevenDayItems:InitRewardInfo(InitParams.PageConfigData, self)
  self:RefreshRewardByState()
  self.AllValidIndex = ReturnUtils.GetSevenDayRewardValidIndex()
  self:PlayAnimation(self.In)
end

function M:OnSubTabNavigationRight()
  self.SevenDayItems:SetFocus()
end

function M:RefreshRewardByState()
  local RealLoginData = ReturnUtils.GetSevenDayRewardRealLoginData()
  local AllSignDay = #RealLoginData
  for i = 1, AllSignDay do
    local RewardWidget = self.SevenDayItems["LowItem_" .. i] or self.SevenDayItems.HighItem
    RewardWidget:RefreshRewardByState(RealLoginData[i])
  end
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidgetWidget, bIsFocusToParent)
end

return M
