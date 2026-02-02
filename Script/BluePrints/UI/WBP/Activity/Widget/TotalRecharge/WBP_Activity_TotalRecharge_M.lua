require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})
M._components = {
  "BluePrints.UI.WBP.Activity.Widget.TotalRecharge.View.ActivityTotalRechargeView"
}

function M:Initialize(Initializer)
  self.OwnerPlayer = nil
  self.CurActivityId = nil
  self.ParentTabId = nil
  self.ParentWidget = nil
  self.AllSignInfo = {}
end

function M:OnRechargeFinished(Result, GoodsId, ShopItems)
  if Result == ErrorCode.RET_SUCCESS and DataMgr.PayGoods[GoodsId] then
    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    local PageConfigData = DataMgr.CumulativeTopUpEvent[self.CurActivityId]
    self:RefreshPageStaticView(ActivityConfigData, PageConfigData, self.ViewInfoBtnClick, self.JumpBtnClick, self.ClaimAllBtnClick)
    self:RefreshPageDynamicView(PageConfigData, self.AllSignInfo)
    self:InitTimeInfo()
    self:InitNavigation()
  end
end

function M:GetPageName()
  return DataMgr.EventTab[self.ParentTabId].EventTabName
end

function M:GetActivityId()
  return self.CurActivityId
end

function M:GetParentTabId()
  return self.ParentTabId
end

function M:ResetVariable()
  self.FocusWidgetName = nil
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
  self.CurActivityId = ActivityId
  self.ParentTabId = ParentTabId
  self.ParentWidget = ParentWidget
  local PlayerAvatar = GWorld:GetAvatar()
  if nil == PlayerAvatar then
    return
  end
  local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
  self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
  self.RewardEndTime = ActivityConfigData.RewardEndTime
  local PageConfigData = DataMgr.CumulativeTopUpEvent[self.CurActivityId]
  self:RefreshPageStaticView(ActivityConfigData, PageConfigData, self.ViewInfoBtnClick, self.JumpBtnClick, self.ClaimAllBtnClick)
  self:RefreshPageDynamicView(PageConfigData, self.AllSignInfo)
  self:InitTimeInfo()
  self:InitNavigation()
end

function M:InitTimeInfo()
  if (self.ActivityEndTime ~= nil or nil ~= self.RewardEndTime) and self.Activity_Time then
    local bCheckNextDayFiveStamp = true
    ActivityUtils.RefreshLeftTime(self, self.Activity_Time, bCheckNextDayFiveStamp)
    self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_Time, bCheckNextDayFiveStamp)
  else
    ActivityUtils.SetLeftTimeView(self.Activity_Time, true)
  end
end

function M:UpdatePage(OperateSrc)
  local IsReBindClickFunction = false
  local IsRefreshCacheServerData = OperateSrc == ActivityCommon.AllUpdateTag.ActivityTab
  self:ResetVariable()
  self:RefreshPageDynamicView()
end

function M:InitNavigation()
  self.List_Reward:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    function()
      return self.Reward_Btn
    end
  })
  self.Reward_Btn:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function()
      return self.List_Reward
    end
  })
end

function M:GetPageConfigData()
  return DataMgr.CumulativeTopUpEvent[self.CurActivityId]
end

function M:CleanSelf(bIsRemoveSelf)
  self:RemoveTimer("RefreshLeftTime")
  if bIsRemoveSelf then
    self:RemoveFromParent()
  end
end

function M:GetCurFocusWidgetInfo()
  return self.FocusWidgetName, self.FocusWidgetWidget
end

function M:IsCanChangeToGamePadViewMode()
  return false
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad, bIsWithButton)
  IsUseGamePad = IsUseGamePad and self:IsCanChangeToGamePadViewMode()
end

function M:EnterStuffViewMode()
  local Index = self:GetPriorityFocusIndex() or 1
  if Index < #self.SortedPoints - 1 then
    self.List_Reward:NavigateToIndex(Index - 1)
    local NewFocusItem = self.List_Reward:GetItemAt(Index - 1)
    self.List_Reward:SetSelectedIndex(Index - 1)
    self:AddTimer(0.01, function()
      self.List_Reward:SetFocus()
      self.FocusWidgetWidget = self.List_Reward
    end)
    if self.ParentWidget then
      self.ParentWidget:UpdateActivityKeyTips("CheckRewardDetailView", self.List_Reward)
    end
  else
    self.List_Reward:SetSelectedIndex(Index - 2)
    self.Reward_Btn:SetFocus()
    self.FocusWidgetWidget = self.Reward_Btn
    if self.ParentWidget then
      self.ParentWidget:UpdateActivityKeyTips("CheckRewardDetailView", self.Reward_Btn)
    end
  end
  self.FocusWidgetName = "CheckRewardDetailView"
  self.IsInStuffViewMode = true
  return true
end

function M:LeaveStuffViewMode()
  if self.FocusWidgetName == nil then
    return false
  end
  self.FocusWidgetName = nil
  self.FocusWidgetWidget = nil
  if self.ParentWidget then
    self.ParentWidget:UpdateActivityKeyTips("CheckRewardView", nil)
    self.ParentWidget:SetFocus()
  end
  self.IsInStuffViewMode = false
  return true
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidgetWidget, bIsFocusToParent)
  self.FocusWidgetName = FocusWidgetName
  self.FocusWidgetWidget = FocusWidgetWidget
  if self.ParentWidget then
    self.ParentWidget:UpdateActivityKeyTips(FocusWidgetName, FocusWidgetWidget)
    if bIsFocusToParent then
      self.ParentWidget:SetFocus()
    end
  end
end

function M:GetDefaultBottomTips()
  local ResultKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_CTL_Select")
    },
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      Desc = GText("UI_Tips_Close")
    }
  }
  return ResultKeyInfo
end

function M:ViewInfoBtnClick()
  local Params = {}
  Params.Parent = self
  local Tabs = {}
  Tabs[1] = {
    Text = GText("UI_Event_CumulativeTopUpEvent_RuleDesTab"),
    TabId = 1
  }
  Tabs[2] = {
    Text = GText("UI_Event_CumulativeTopUpEvent_CreditHistoryTab"),
    TabId = 2
  }
  Params.TabConfigData = {
    PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self),
    LeftKey = "A",
    RightKey = "D",
    Tabs = Tabs,
    SoundFunc = function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
    end
  }
  Params.EventId = self.CurActivityId
  self.DetailPopupUI = UIManager(self):ShowCommonPopupUI(100306, Params, self)
end

function M:JumpBtnClick()
  local PageConfigData = DataMgr.CumulativeTopUpEvent[self.CurActivityId]
  PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpId)
end

function M:ClaimAllBtnClick()
  local PlayerAvatar = GWorld:GetAvatar()
  if not PlayerAvatar then
    return
  end
  PlayerAvatar:GetCumulativeRechargeReward(function(Ret, Rewards)
    if not ErrorCode:Check(Ret) then
      return
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, Rewards.IsSpPopup)
    self:RefreshPageDynamicView()
    ActivityUtils.TrySubActivityReddotCommon("Red", self.CurActivityId)
  end, self.CurActivityId, 0)
end

AssembleComponents(M)
return M
