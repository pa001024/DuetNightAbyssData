require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local M = {}

function M:PlayFadeIn()
  self:PlayAnimation(self.In)
  local TitleWidget = self.Group_TitleAnchor:GetChildAt(0)
  if TitleWidget.In ~= nil then
    TitleWidget:PlayAnimationForward(TitleWidget.In)
  end
end

function M:PlayFadeOut(IsRemoveFromParent)
  self:PlayAnimation(self.Out)
  if IsRemoveFromParent then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.RemoveFromParent
    })
  end
end

function M:HidePage(IsNeedPlayOutAnim)
  if IsNeedPlayOutAnim then
    self:PlayFadeOut()
  end
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ShowPage(IsNeedPlayInAnim)
  if IsNeedPlayInAnim then
    self:PlayFadeIn()
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:IsPageInVisible()
  return self:IsVisible()
end

function M:RefreshPageStaticView(ActivityConfigData, PageConfigData, InfoClickFunction, JumpClickFunction, ClaimClickFunction)
  self.Text_Time:SetText(GText(PageConfigData.EventDes))
  self.Text_ActivityDesc:SetText(GText(ActivityConfigData.EventDes))
  self.Text_ActivityDesc_White:SetText(GText(ActivityConfigData.EventDes))
  local PlayerAvatar = GWorld:GetAvatar()
  local TitleWidget = UIManager(self):CreateWidget(ActivityConfigData.EventNameBPPath)
  self:UpdateEventTitleInfo(ActivityConfigData, TitleWidget, PlayerAvatar)
  self.Group_TitleAnchor:ClearChildren()
  self.Group_TitleAnchor:AddChildToOverlay(TitleWidget)
  self.Group_TitleAnchor:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local NeedPoints = {0}
  for k, _ in pairs(PageConfigData.ScoreRankReward) do
    table.insert(NeedPoints, k)
  end
  table.sort(NeedPoints)
  self.SortedPoints = NeedPoints
  self.ActivityData = PlayerAvatar and PlayerAvatar.AccumulateRecharge and PlayerAvatar.AccumulateRecharge[self.CurActivityId]
  self.List_Reward:ClearListItems()
  self.RewardContentList = {}
  for i = 2, #NeedPoints - 1 do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = i - 1
    Content.EventId = self.CurActivityId
    Content.RewardId = PageConfigData.ScoreRankReward[NeedPoints[i]]
    Content.PrevPoint = NeedPoints[i - 1]
    Content.CurrPoint = NeedPoints[i]
    Content.NextPoint = NeedPoints[i + 1]
    Content.ParentWidget = self
    self.List_Reward:AddItem(Content)
    table.insert(self.RewardContentList, Content)
  end
  local GrandRewardData = {}
  GrandRewardData.Index = #NeedPoints - 1
  GrandRewardData.EventId = self.CurActivityId
  GrandRewardData.RewardId = PageConfigData.ScoreRankReward[NeedPoints[#NeedPoints]]
  GrandRewardData.PrevPoint = NeedPoints[#NeedPoints - 1]
  GrandRewardData.CurrPoint = NeedPoints[#NeedPoints]
  GrandRewardData.ParentWidget = self
  self.Reward_Btn:FillWithData(GrandRewardData)
  local GrandPrizeData = {}
  GrandPrizeData.NeedPoint = NeedPoints[#NeedPoints]
  GrandPrizeData.LastRewardTypeId = PageConfigData.LastRewardTypeId
  GrandPrizeData.LastRewardId = PageConfigData.LastRewardId
  GrandPrizeData.ParentWidget = self
  self.GrandPrize:FillWithData(GrandPrizeData)
  local BtnQaConfigData = {}
  BtnQaConfigData.ClickCallback = InfoClickFunction
  BtnQaConfigData.OwnerWidget = self
  self.Btn_Qa:Init(BtnQaConfigData)
  self.Num_Money:SetText(tostring(0))
  self.Btn_Confirm:SetText(GText("UI_Event_CumulativeTopUpEvent_Jump"))
  self.Btn_Reward:SetText(GText("UI_Event_CumulativeTopUpEvent_ClaimAll"))
  self.Btn_Reward:SetDefaultGamePadImg("Y")
  self.Btn_Reward:SetGamePadIconVisible(true)
  self:BindAllClickFunction(JumpClickFunction, ClaimClickFunction)
  if self.Com_Key_Qa then
    self.Com_Key_Qa:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "View"}
      }
    })
  end
end

function M:AdjustWidgetByPlatform()
  local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
  local SuffixStr = "Mobile" == PlatformName and "M" or "P"
end

function M:RefreshPageDynamicView()
  self.FocusWidgetName = "CheckRewardView"
  local PlayerAvatar = GWorld:GetAvatar()
  local activityData = PlayerAvatar and PlayerAvatar.AccumulateRecharge and PlayerAvatar.AccumulateRecharge[self.CurActivityId]
  local score = activityData and activityData.Score or 0
  self.Num_Money:SetText(tostring(score))
  self.List_Reward:RegenerateAllEntries()
  self.Reward_Btn:RefreshDynamic()
  self:AddTimer(0.2, self.ScrollToRewardSmoothly, false, 0, "ScrollToRewardSmoothly", true)
  if self:GetPriorityFocusIndex() == nil then
    self.CanClaim = false
    self.Btn_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.CanClaim = true
    self.Btn_Reward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:UpdateEventTitleInfo(ActivityConfigData, TitleWidget, PlayerAvatar)
  if not TitleWidget then
    return
  end
  TitleWidget.Text_Title:SetText(GText(ActivityConfigData.EventName))
end

function M:BindAllClickFunction(JumpClickFunction, RewardClickFunction)
  self.Btn_Confirm:BindEventOnClicked(self, function()
    if JumpClickFunction then
      JumpClickFunction(self)
    end
  end)
  self.Btn_Reward:BindEventOnClicked(self, function()
    if RewardClickFunction and self.CanClaim then
      RewardClickFunction(self)
    end
  end)
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidgetWidget, bIsFocusToParent)
end

function M:PlayStarGoldenInAnim(Idx)
  local Len = self.AvatarName.HB_Star:GetChildrenCount()
  local Stars = self.AvatarName.HB_Star:GetAllChildren()
  if Idx <= Len then
    Stars[Idx]:BindToAnimationFinished(Stars[Idx].Golden_In, {
      Stars[Idx],
      function()
        Stars[Idx]:UnbindAllFromAnimationFinished(Stars[Idx].In)
        Stars[Idx]:PlayAnimation(Stars[Idx].Loop, 1, 0)
      end
    })
    Stars[Idx]:PlayAnimation(Stars[Idx].Golden_In)
  end
end

function M:RefreshItemStyleView(RewardIndex, RewardState)
  local TargetItem = self.SevenDayItems["LowItem_" .. RewardIndex] or self.SevenDayItems.HighItem
  if nil ~= TargetItem then
    TargetItem:RefreshRewardByState(RewardState)
  end
end

function M:GetTargetScrollIndex()
  local PlayerAvatar = GWorld:GetAvatar()
  local ActivityData = PlayerAvatar and PlayerAvatar.AccumulateRecharge and PlayerAvatar.AccumulateRecharge[self.CurActivityId]
  if not ActivityData then
    return 1
  end
  local curScore = ActivityData.Score or 0
  local rewardGot = ActivityData.RewardGot or {}
  local claimedMap = {}
  local maxClaimedIndex = 0
  for index, val in ipairs(rewardGot) do
    claimedMap[index] = true
    if index > maxClaimedIndex then
      maxClaimedIndex = index
    end
  end
  for i = 2, #self.SortedPoints - 1 do
    local scoreNeeded = self.SortedPoints[i]
    local index = i - 1
    local isReached = curScore >= scoreNeeded
    local isClaimed = claimedMap[index]
    if isReached and not isClaimed then
      return index
    end
  end
  if maxClaimedIndex > 0 then
    return maxClaimedIndex
  else
    return 1
  end
end

function M:ScrollToRewardSmoothly()
  local TargetIdx = self:GetTargetScrollIndex()
  local ItemObject = self.List_Reward:GetItemAt(TargetIdx - 1)
  if ItemObject then
    self.List_Reward:ScrollItemIntoViewWithAnim(ItemObject, true, UE.EDescendantScrollDestination.Center)
  end
end

function M:GetPriorityFocusIndex()
  local playerAvatar = GWorld:GetAvatar()
  local activityData = playerAvatar and playerAvatar.AccumulateRecharge[self.CurActivityId]
  local curScore = activityData and activityData.Score or 0
  local rewardGot = activityData and activityData.RewardGot or {}
  for i = 2, #self.SortedPoints do
    local scoreNeeded = self.SortedPoints[i]
    local index = i - 1
    local isReached = curScore >= scoreNeeded
    local isClaimed = false
    for gotIdx, _ in ipairs(rewardGot) do
      if gotIdx == index then
        isClaimed = true
        break
      end
    end
    if isReached and not isClaimed then
      return index
    end
  end
  return nil
end

return M
