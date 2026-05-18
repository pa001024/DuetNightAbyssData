require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
local PageJumpUtils = require("Utils.PageJumpUtils")
local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local RewardUtils = require("Utils.RewardUtils")
local UIUtils = require("Utils.UIUtils")
local ShopUtils = require("Utils.ShopUtils")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
local BaseName = "BluePrints.UI.WBP.Activity.PC.SkinCollect.WBP_Activity_SkinCollect_Base_C"
local SKIN_COLLECT_ITEM_BP_PATH = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/SkinCollect/CollectItem/WBP_Activity_SkinCollect_Item.WBP_Activity_SkinCollect_Item'"
local REWARD_LIST_FOCUS_TIMER = "SkinCollectRewardListFocus"
local REWARD_LIST_REFRESH_TIMER = "SkinCollectRewardListRefresh"

local function GetWidgetRectInTargetSpace(Widget, TargetWidget)
  if not (Widget and TargetWidget and Widget.GetCachedGeometry) or not TargetWidget.GetCachedGeometry then
    return nil
  end
  local widgetGeometry = Widget:GetCachedGeometry()
  local targetGeometry = TargetWidget:GetCachedGeometry()
  if not widgetGeometry or not targetGeometry then
    return nil
  end
  local localSize = UE4.USlateBlueprintLibrary.GetLocalSize(widgetGeometry)
  if not localSize or localSize.X <= 0 or localSize.Y <= 0 then
    return nil
  end
  local widgetAbsPos = UE4.USlateBlueprintLibrary.LocalToAbsolute(widgetGeometry, FVector2D(0, 0))
  local localPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(targetGeometry, widgetAbsPos)
  return {
    Left = localPos.X,
    Right = localPos.X + localSize.X
  }
end

function M:Initialize(Initializer)
  self.CurActivityId = nil
  self.ParentTabId = nil
  self.AllActivityId = nil
  self.ParentWidget = nil
  self.ActivityConfigData = nil
  self.ActivityEndTime = nil
  self.RewardEndTime = nil
  self.RewardConfigData = nil
  self.IsUnlocked = false
  self.bSkinCollectResourceEventRegistered = false
  self.UnlockBtnLoopState = nil
  self.RewardListRefreshSerial = 0
  self.TitleWidget = nil
  self.BaseName = BaseName
end

function M:AdvanceRewardListRefreshSerial()
  self.RewardListRefreshSerial = (self.RewardListRefreshSerial or 0) + 1
  return self.RewardListRefreshSerial
end

function M:RemoveRewardListTimers()
  self:RemoveTimer(REWARD_LIST_FOCUS_TIMER)
  self:RemoveTimer(REWARD_LIST_REFRESH_TIMER)
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
  self.CurActivityId = ActivityId
  self.ParentTabId = ParentTabId
  self.AllActivityId = AllActivityId
  self.ParentWidget = ParentWidget
  self.ActivityConfigData = DataMgr.EventMain and DataMgr.EventMain[self.CurActivityId]
  if self.ActivityConfigData then
    self.ActivityEndTime = self.ActivityConfigData.EventEndTime
    self.RewardEndTime = self.ActivityConfigData.RewardEndTime
  end
  self.RewardConfigData = DataMgr.AppearanceCollectReward[self.CurActivityId]
  if not self.RewardConfigData then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.IsUnlocked = self:CheckIsUnlocked(Avatar)
  self:RegisterResourceChangedEvent()
  self:InitCommonUI()
  self:InitTimeInfo()
  self:RefreshScoreDisplay(Avatar, true)
  self:RefreshItemList(Avatar)
  self:RefreshUnlockBtnState(Avatar)
  self:RefreshClaimAllBtnState(Avatar)
  self:SyncClaimableReddot(Avatar)
  self:BindButtons()
  self:NotifyGamepadActionHintsChanged()
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:PlayFadeIn()
end

function M:PlayFadeIn()
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:InitCommonUI()
  if not self.TitleWidget and self.Title and self.ActivityConfigData then
    local titleBPPath = self.ActivityConfigData.EventNameBPPath
    if titleBPPath then
      local titleWidget = UIManager(self):CreateWidget(titleBPPath)
      if titleWidget then
        self.Title:ClearChildren()
        self.Title:AddChildToOverlay(titleWidget)
        self.TitleWidget = titleWidget
      end
    end
  end
  if self.TitleWidget and self.ActivityConfigData then
    if self.TitleWidget.Text_Title then
      self.TitleWidget.Text_Title:SetText(GText(self.ActivityConfigData.EventName or ""))
    end
    if self.TitleWidget.In then
      self.TitleWidget:PlayAnimation(self.TitleWidget.In)
    end
  end
  local descText = self.ActivityConfigData and self.ActivityConfigData.EventDes and GText(self.ActivityConfigData.EventDes) or ""
  if self.Text_Desc then
    self.Text_Desc:SetText(descText)
  end
  if self.Text_Desc_White then
    self.Text_Desc_White:SetText(descText)
  end
  if self.Com_BtnExplanation then
    self.Com_BtnExplanation:Init({
      ClickCallback = self.ViewInfoBtnClick,
      OwnerWidget = self,
      Desc = "UI_Common_Rule",
      SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
      end
    })
  end
  if self.Group_ActivityQa then
    local isShowRule = self.ActivityConfigData and self.ActivityConfigData.EventRule
    self.Group_ActivityQa:SetVisibility(isShowRule and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitTimeInfo()
  local timeView = self.Activity_Time
  if not timeView then
    return
  end
  local comTime = timeView.Com_Time
  if (self.ActivityEndTime ~= nil or nil ~= self.RewardEndTime) and comTime then
    ActivityUtils.RefreshLeftTime(self, comTime)
    self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, comTime)
  else
    ActivityUtils.SetLeftTimeView(comTime, true)
  end
end

function M:GetPageConfigData()
  return {
    ActivityId = self.CurActivityId
  }
end

function M:UpdatePage(OperateSrc)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.IsUnlocked = self:CheckIsUnlocked(Avatar)
  self:RefreshScoreDisplay(Avatar)
  self:RefreshItemList(Avatar)
  self:RefreshUnlockBtnState(Avatar)
  self:RefreshClaimAllBtnState(Avatar)
  self:SyncClaimableReddot(Avatar)
end

function M:ShowPage(IsNeedPlayInAnim)
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if IsNeedPlayInAnim then
    self:PlayFadeIn()
  end
  self:InitTimeInfo()
end

function M:PlayFadeOut(IsRemoveFromParent)
  if self.Out then
    self:PlayAnimation(self.Out)
    if IsRemoveFromParent then
      self:BindToAnimationFinished(self.Out, {
        self,
        self.RemoveFromParent
      })
    end
  elseif IsRemoveFromParent then
    self:RemoveFromParent()
  end
end

function M:HidePage(IsNeedPlayOutAnim)
  if IsNeedPlayOutAnim then
    self:PlayFadeOut()
  else
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:GetRewardListContainer()
  local listWidget = self.WBP_Activity_SkinCollect_ListItem
  local candidates = {}
  if listWidget then
    table.insert(candidates, listWidget.ListItem)
    table.insert(candidates, listWidget.ScrollList)
    table.insert(candidates, listWidget)
  end
  table.insert(candidates, self.ListItem)
  table.insert(candidates, self.ScrollList)
  for _, widget in ipairs(candidates) do
    if widget and IsValid(widget) then
      if widget.AddItem and widget.ClearListItems then
        return "ListView", widget
      end
      if widget.AddChild and widget.ClearChildren and widget.ScrollWidgetIntoView then
        return "ScrollBox", widget
      end
    end
  end
  return nil, nil
end

function M:GetFocusedRewardIndex()
  if self.RewardItemContents and self.RewardItemWidgets then
    for index, _ in ipairs(self.RewardItemContents) do
      local widget = self.RewardItemWidgets[index]
      if widget and IsValid(widget) then
        local hasFocus = false
        if widget.HasAnyUserFocus and widget:HasAnyUserFocus() then
          hasFocus = true
        elseif widget.HasFocusedDescendants and widget:HasFocusedDescendants() then
          hasFocus = true
        end
        if hasFocus then
          self.LastFocusedRewardIndex = index
          return index
        end
      end
    end
  end
  if self.LastFocusedRewardIndex and self.RewardItemContents and self.RewardItemContents[self.LastFocusedRewardIndex] then
    return self.LastFocusedRewardIndex
  end
  return self.DefaultRewardIndex or 1
end

function M:GetCurrentRewardSelectedContent()
  local containerType, listContainer = self:GetRewardListContainer()
  if "ListView" == containerType then
    if listContainer and listContainer.GetSelectedItem then
      local selectedContent = listContainer:GetSelectedItem()
      if selectedContent then
        self.LastFocusedRewardIndex = selectedContent.Index
        return selectedContent
      end
    end
    if self.LastFocusedRewardIndex and self.RewardItemContents then
      return self.RewardItemContents[self.LastFocusedRewardIndex]
    end
    return nil
  end
  if not self.RewardItemContents or 0 == #self.RewardItemContents then
    return nil
  end
  local focusedIndex = self:GetFocusedRewardIndex()
  return self.RewardItemContents[focusedIndex]
end

function M:GetCurrentRewardSelectedWidget()
  local containerType, listContainer = self:GetRewardListContainer()
  if "ListView" == containerType and listContainer then
    local focusedIndex = self:GetFocusedRewardIndex()
    if UE4.URuntimeCommonFunctionLibrary and UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem then
      return UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(listContainer, focusedIndex - 1)
    end
    return nil
  end
  if not self.RewardItemWidgets then
    return nil
  end
  local focusedIndex = self:GetFocusedRewardIndex()
  return self.RewardItemWidgets[focusedIndex]
end

function M:GetFirstVisibleRewardIndex()
  local containerType, listContainer = self:GetRewardListContainer()
  if not ("ScrollBox" == containerType and listContainer) or not self.RewardItemWidgets then
    return nil
  end
  local containerGeometry = listContainer.GetCachedGeometry and listContainer:GetCachedGeometry()
  if not containerGeometry then
    return nil
  end
  local containerSize = UE4.USlateBlueprintLibrary.GetLocalSize(containerGeometry)
  if not containerSize or containerSize.X <= 0 then
    return nil
  end
  local bestIndex
  local bestLeft = math.huge
  for index, widget in ipairs(self.RewardItemWidgets) do
    local rect = GetWidgetRectInTargetSpace(widget, listContainer)
    if rect and rect.Right > 0 and rect.Left < containerSize.X and bestLeft > rect.Left then
      bestLeft = rect.Left
      bestIndex = index
    end
  end
  return bestIndex
end

local function GetRewardItemFocusTarget(rewardWidget)
  if not rewardWidget or not IsValid(rewardWidget) then
    return nil
  end
  if rewardWidget.BP_GetDesiredFocusTarget then
    local focusTarget = rewardWidget:BP_GetDesiredFocusTarget()
    if focusTarget and IsValid(focusTarget) then
      return focusTarget
    end
  end
  if rewardWidget.GetListFocusTargetWidget then
    local focusTarget = rewardWidget:GetListFocusTargetWidget()
    if focusTarget and IsValid(focusTarget) then
      return focusTarget
    end
  end
  return rewardWidget
end

local function ScrollRewardWidgetIntoSafeView(scrollBox, targetWidget)
  if not (scrollBox and targetWidget and IsValid(scrollBox)) or not IsValid(targetWidget) then
    return false
  end
  if not (scrollBox.GetCachedGeometry and scrollBox.GetScrollOffset) or not scrollBox.SetScrollOffset then
    return false
  end
  local containerGeometry = scrollBox:GetCachedGeometry()
  if not containerGeometry then
    return false
  end
  local containerSize = UE4.USlateBlueprintLibrary.GetLocalSize(containerGeometry)
  if not containerSize or containerSize.X <= 0 then
    return false
  end
  local rect = GetWidgetRectInTargetSpace(targetWidget, scrollBox)
  if not rect then
    return false
  end
  local currentOffset = scrollBox:GetScrollOffset() or 0
  local safePadding = math.min(24, math.max(containerSize.X * 0.08, 0))
  local safeLeft = safePadding
  local safeRight = containerSize.X - safePadding
  if safeLeft >= safeRight then
    safeLeft = 0
    safeRight = containerSize.X
  end
  local targetOffset = currentOffset
  if safeLeft > rect.Left then
    targetOffset = currentOffset - (safeLeft - rect.Left)
  elseif safeRight < rect.Right then
    targetOffset = currentOffset + (rect.Right - safeRight)
  else
    return true
  end
  if scrollBox.GetScrollOffsetOfEnd then
    local endOffset = scrollBox:GetScrollOffsetOfEnd() or 0
    targetOffset = math.max(math.min(targetOffset, endOffset), 0)
  else
    targetOffset = math.max(targetOffset, 0)
  end
  scrollBox:SetScrollOffset(targetOffset)
  return true
end

function M:FocusRewardItemByIndex(rewardIndex)
  if not rewardIndex or rewardIndex <= 0 then
    return false
  end
  local containerType, listContainer = self:GetRewardListContainer()
  if not (containerType and listContainer) or not IsValid(listContainer) then
    return false
  end
  self.LastFocusedRewardIndex = rewardIndex
  self:RemoveTimer(REWARD_LIST_REFRESH_TIMER)
  if "ListView" == containerType then
    local targetIndex = rewardIndex - 1
    local targetContent = self.RewardItemContents and self.RewardItemContents[rewardIndex]
    local refreshSerial = self.RewardListRefreshSerial
    if listContainer.ScrollIndexIntoView then
      listContainer:ScrollIndexIntoView(targetIndex)
    end
    if listContainer.NavigateToIndex then
      listContainer:NavigateToIndex(targetIndex)
    end
    if listContainer.SetSelectedIndex then
      listContainer:SetSelectedIndex(targetIndex)
    end
    if listContainer.SetFocus then
      listContainer:SetFocus()
    end
    if self.GameInputModeSubsystem and UE4.URuntimeCommonFunctionLibrary and UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem then
      self:RemoveTimer(REWARD_LIST_FOCUS_TIMER)
      self:AddTimer(0.01, function()
        if refreshSerial ~= self.RewardListRefreshSerial then
          return
        end
        local curContainerType, curContainer = self:GetRewardListContainer()
        if "ListView" ~= curContainerType or curContainer ~= listContainer or not IsValid(curContainer) then
          return
        end
        if targetContent and self.RewardItemContents and self.RewardItemContents[rewardIndex] ~= targetContent then
          return
        end
        local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(listContainer, targetIndex)
        if entryWidget and IsValid(entryWidget) then
          if entryWidget.SetListFocusGamepadHintVisible then
            entryWidget:SetListFocusGamepadHintVisible(self.IsInListFocus == true and true ~= self.IsRewardTipsOpen)
          end
          local focusTarget = GetRewardItemFocusTarget(entryWidget)
          if focusTarget then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(focusTarget)
            if focusTarget.SetFocus then
              focusTarget:SetFocus()
            end
          end
        elseif listContainer.SetFocus then
          listContainer:SetFocus()
        end
      end, false, 0, REWARD_LIST_FOCUS_TIMER, true)
    elseif listContainer.SetFocus then
      listContainer:SetFocus()
    end
    return true
  end
  local targetWidget = self.RewardItemWidgets and self.RewardItemWidgets[rewardIndex]
  if not targetWidget or not IsValid(targetWidget) then
    return false
  end
  if targetWidget.SetListFocusGamepadHintVisible then
    targetWidget:SetListFocusGamepadHintVisible(self.IsInListFocus == true and true ~= self.IsRewardTipsOpen)
  end
  if not ScrollRewardWidgetIntoSafeView(listContainer, targetWidget) and listContainer.ScrollWidgetIntoView then
    if EDescendantScrollDestination then
      listContainer:ScrollWidgetIntoView(targetWidget, true, EDescendantScrollDestination.Center)
    else
      listContainer:ScrollWidgetIntoView(targetWidget, true)
    end
  end
  local focusTarget = GetRewardItemFocusTarget(targetWidget)
  if focusTarget and focusTarget.SetFocus then
    focusTarget:SetFocus()
  end
  return true
end

function M:OnRewardItemFocused(rewardIndex, rewardWidget)
  if rewardIndex and rewardIndex > 0 then
    self.LastFocusedRewardIndex = rewardIndex
  end
  if rewardWidget and rewardWidget.SetListFocusGamepadHintVisible then
    rewardWidget:SetListFocusGamepadHintVisible(self.IsInListFocus == true and true ~= self.IsRewardTipsOpen)
  end
  if type(self.RefreshParentActivityKeyTips) == "function" then
    self:RefreshParentActivityKeyTips()
  end
end

function M:OnRewardTipsOpenChanged(bIsOpen, rewardWidget)
  self.IsRewardTipsOpen = true == bIsOpen
  if type(self.RefreshResourceBarGamepadKey) == "function" then
    self:RefreshResourceBarGamepadKey(self.IsRewardTipsOpen)
  end
  if rewardWidget and rewardWidget.SetListFocusGamepadHintVisible then
    rewardWidget:SetListFocusGamepadHintVisible(true == self.IsInListFocus and self.IsRewardTipsOpen ~= true)
  end
  if "function" == type(self.RefreshParentActivityKeyTips) then
    self:RefreshParentActivityKeyTips()
  elseif self.ParentWidget and self.ParentWidget.UpdateActivityKeyTips then
    if self.IsRewardTipsOpen then
      self.ParentWidget:UpdateActivityKeyTips("EmptyView", rewardWidget or self:GetCurrentRewardSelectedWidget())
    else
      self.ParentWidget:UpdateActivityKeyTips()
    end
  end
  self:NotifyGamepadActionHintsChanged()
  if not self.IsRewardTipsOpen and rewardWidget and IsValid(rewardWidget) then
    local focusTarget = GetRewardItemFocusTarget(rewardWidget)
    if focusTarget and focusTarget.SetFocus then
      focusTarget:SetFocus()
    end
  end
end

function M:OpenCurrentRewardTips()
  local selectedWidget = self:GetCurrentRewardSelectedWidget()
  if selectedWidget and selectedWidget.OpenRewardTips then
    return selectedWidget:OpenRewardTips()
  end
  return false
end

function M:RefreshItemList(Avatar, bPlayUnlockAnim)
  if not self.RewardConfigData then
    return
  end
  local pointsTarget = self.RewardConfigData.PointsTarget
  local pointsReward = self.RewardConfigData.PointsReward
  local highlightReward = self.RewardConfigData.HighlightReward
  if not pointsTarget or not pointsReward then
    return
  end
  local containerType, listContainer = self:GetRewardListContainer()
  if not (containerType and listContainer) or not IsValid(listContainer) then
    return
  end
  self:RemoveRewardListTimers()
  local refreshSerial = self:AdvanceRewardListRefreshSerial()
  local currentScore = self:GetPlayerCurrentScore(Avatar)
  local closestIndex = 1
  local closestDist = math.huge
  self.RewardItemContents = {}
  self.RewardItemWidgets = {}
  if "ListView" == containerType then
    listContainer:ClearListItems()
  else
    listContainer:ClearChildren()
  end
  for i, target in ipairs(pointsTarget) do
    local rewardIds = self:GetRewardIdsForIndex(pointsReward, i)
    local prevRewardIds = i > 1 and self:GetRewardIdsForIndex(pointsReward, i - 1) or nil
    local prevTargetScore = i > 1 and (pointsTarget[i - 1] or 0) or 0
    local state = self:GetRewardItemState(Avatar, i, currentScore, target, rewardIds)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = i
    Content.TargetScore = target
    Content.PrevTargetScore = prevTargetScore
    Content.CurrentScore = currentScore
    Content.RewardIds = rewardIds
    Content.PrevRewardIds = prevRewardIds
    Content.bHighlight = highlightReward and (true == highlightReward[i] or 1 == highlightReward[i]) or false
    Content.bHasGot = "Completed" == state
    Content.bCanGet = "Claimable" == state
    Content.bPlayUnlockAnim = true == bPlayUnlockAnim
    Content.ParentWidget = self
    self.RewardItemContents[i] = Content
    if "ListView" == containerType then
      listContainer:AddItem(Content)
    else
      local itemWidget = UIManager(self):CreateWidget(SKIN_COLLECT_ITEM_BP_PATH)
      if itemWidget then
        Content.SelfWidget = itemWidget
        listContainer:AddChild(itemWidget)
        if itemWidget.OnListItemObjectSet then
          itemWidget:OnListItemObjectSet(Content)
        end
        self.RewardItemWidgets[i] = itemWidget
      end
    end
    local dist = math.abs(currentScore - target)
    if closestDist > dist then
      closestDist = dist
      closestIndex = i
    end
  end
  self.DefaultRewardIndex = closestIndex
  self.LastFocusedRewardIndex = closestIndex
  local targetContent = self.RewardItemContents and self.RewardItemContents[closestIndex]
  self:AddTimer(0, function()
    if not self or refreshSerial ~= self.RewardListRefreshSerial then
      return
    end
    local curContainerType, curContainer = self:GetRewardListContainer()
    if not (curContainerType and curContainer) or not IsValid(curContainer) then
      return
    end
    if "ListView" == curContainerType then
      if targetContent and self.RewardItemContents and self.RewardItemContents[closestIndex] ~= targetContent then
        return
      end
      local scrollToIndex = math.max((closestIndex or 1) - 1, 0)
      if curContainer.ScrollIndexIntoView then
        curContainer:ScrollIndexIntoView(scrollToIndex)
      end
      if curContainer.SetSelectedIndex then
        curContainer:SetSelectedIndex(scrollToIndex)
      end
      return
    end
    if targetContent and self.RewardItemContents and self.RewardItemContents[closestIndex] ~= targetContent then
      return
    end
    local targetWidget = self.RewardItemWidgets and self.RewardItemWidgets[closestIndex]
    if targetWidget and IsValid(targetWidget) and curContainer.ScrollWidgetIntoView then
      if EDescendantScrollDestination then
        curContainer:ScrollWidgetIntoView(targetWidget, true, EDescendantScrollDestination.Center)
      else
        curContainer:ScrollWidgetIntoView(targetWidget, true)
      end
    end
  end, false, 0, REWARD_LIST_REFRESH_TIMER, true)
end

function M:GetRewardIdsForIndex(pointsReward, index)
  local reward = pointsReward[index]
  if not reward then
    return {}
  end
  if type(reward) == "table" then
    return reward
  end
  return {reward}
end

function M:BuildRewardPopupDataByIndex(Avatar, rewardIndex)
  if not Avatar or not self.RewardConfigData then
    return nil
  end
  local pointsReward = self.RewardConfigData.PointsReward
  local rewardIds = self:GetRewardIdsForIndex(pointsReward, rewardIndex)
  if not rewardIds or 0 == #rewardIds then
    return nil
  end
  local rewards = RewardUtils:GetRewards(rewardIds, Avatar)
  if self:IsRewardPopupDataEmpty(rewards) then
    return nil
  end
  return rewards
end

function M:IsRewardPopupDataEmpty(rewards)
  if not rewards then
    return true
  end
  if rewards.IsEmpty then
    return rewards:IsEmpty()
  end
  return next(rewards) == nil
end

function M:ShowClaimRewardPopup(Avatar, rewardIndex)
  local rewards = self:BuildRewardPopupDataByIndex(Avatar, rewardIndex)
  if self:IsRewardPopupDataEmpty(rewards) then
    return
  end
  UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, rewards, false, function()
    self:OnGetItemPageClosed()
  end, self, false)
end

function M:BuildClaimAllRewardPopupData(Avatar, rewardIndexes)
  if not (Avatar and rewardIndexes) or 0 == #rewardIndexes then
    return nil
  end
  local allRewards = RewardBox:New()
  for _, rewardIndex in ipairs(rewardIndexes) do
    local rewards = self:BuildRewardPopupDataByIndex(Avatar, rewardIndex)
    if rewards then
      allRewards:Merge(rewards)
    end
  end
  if allRewards:IsEmpty() then
    return nil
  end
  return allRewards
end

function M:ShowClaimAllRewardPopup(Avatar, rewardIndexes, rewards)
  local popupRewards = rewards
  if self:IsRewardPopupDataEmpty(popupRewards) then
    popupRewards = self:BuildClaimAllRewardPopupData(Avatar, rewardIndexes)
  end
  if self:IsRewardPopupDataEmpty(popupRewards) then
    return
  end
  UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, popupRewards, false, function()
    self:OnGetItemPageClosed()
  end, self, false)
end

function M:OnGetItemPageClosed()
end

function M:RegisterResourceChangedEvent()
  if self.bSkinCollectResourceEventRegistered then
    return
  end
  EventManager:AddEvent(EventID.OnResourcesChanged, self, self.OnResourcesChanged)
  self.bSkinCollectResourceEventRegistered = true
end

function M:UnregisterResourceChangedEvent()
  if not self.bSkinCollectResourceEventRegistered then
    return
  end
  EventManager:RemoveEvent(EventID.OnResourcesChanged, self)
  self.bSkinCollectResourceEventRegistered = false
end

function M:Destruct()
  self:RemoveRewardListTimers()
  self:RemoveTimer("RefreshLeftTime")
  self:UnregisterResourceChangedEvent()
end

function M:CleanSelf(bIsRemoveSelf)
  self:RemoveRewardListTimers()
  self:RemoveTimer("RefreshLeftTime")
  self:UnregisterResourceChangedEvent()
  if bIsRemoveSelf then
    self:RemoveFromParent()
  end
end

function M:CheckIsUnlocked(Avatar)
  local collectData = Avatar.AppearanceCollectEvent:GetApperanceCollectEvent(self.CurActivityId)
  if not collectData then
    return false
  end
  return collectData.IsUnlockReward == true
end

function M:GetPlayerCurrentScore(Avatar)
  local collectData = Avatar.AppearanceCollectEvent:GetApperanceCollectEvent(self.CurActivityId)
  if not collectData then
    return 0
  end
  return collectData.Score or 0
end

function M:RefreshScoreDisplay(Avatar, bIsInit)
  local currentScore = self:GetPlayerCurrentScore(Avatar)
  local subTitle = self.WBP_Activity_SkinCollect_SubTitle
  if not IsValid(subTitle) then
    return
  end
  if subTitle.Text_ScoreNum then
    subTitle.Text_ScoreNum:SetText(tostring(currentScore or 0))
  end
  if bIsInit then
    if subTitle.Text_SubTitle then
      subTitle.Text_SubTitle:SetText(GText("UI_AppearanceCollect_CurrentScore"))
    end
    if subTitle.Text_Desc then
      subTitle.Text_Desc:SetText(GText("UI_AppearanceCollect_GetScoreByCompleteTask"))
    end
  end
end

function M:GetRewardItemState(Avatar, index, currentScore, target, rewardIds)
  local collectData = Avatar.AppearanceCollectEvent:GetApperanceCollectEvent(self.CurActivityId)
  local bHasGotReward = collectData and collectData.GotRewardId and collectData.GotRewardId:HasElement(index)
  if not bHasGotReward and collectData and collectData.GotRewardId and rewardIds then
    for _, rewardId in ipairs(rewardIds) do
      if collectData.GotRewardId:HasElement(rewardId) then
        bHasGotReward = true
        break
      end
    end
  end
  if bHasGotReward then
    return "Completed"
  end
  if self.IsUnlocked and target <= currentScore then
    return "Claimable"
  end
  return "Locked"
end

function M:HasClaimableReward(Avatar)
  if not (self.IsUnlocked and self.RewardConfigData) or not Avatar then
    return false
  end
  local currentScore = self:GetPlayerCurrentScore(Avatar)
  local pointsTarget = self.RewardConfigData.PointsTarget
  if not pointsTarget then
    return false
  end
  for i, target in ipairs(pointsTarget) do
    local pointsReward = self.RewardConfigData.PointsReward
    local rewardIds = pointsReward and self:GetRewardIdsForIndex(pointsReward, i) or nil
    if self:GetRewardItemState(Avatar, i, currentScore, target, rewardIds) == "Claimable" then
      return true
    end
  end
  return false
end

function M:SyncClaimableReddot(Avatar)
  if not self.CurActivityId then
    return
  end
  local eventMain = DataMgr.EventMain and DataMgr.EventMain[self.CurActivityId]
  if not eventMain or not eventMain.ReddotNode then
    return
  end
  local hasClaimable = self:HasClaimableReward(Avatar)
  local hasRed = 1 == ActivityUtils.GetReddotCachInfoByKey("Red", self.CurActivityId)
  if hasClaimable then
    if not hasRed then
      ActivityUtils.TryAddActivityReddotCommon("Red", self.CurActivityId)
    end
  elseif hasRed then
    ActivityUtils.TrySubActivityReddotCommon("Red", self.CurActivityId)
  end
end

function M:SetUnlockBtnVisibility(isVisible)
  local visibilityOp = isVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if self.WBP_Activity_SkinCollect_PayBtn then
    self.WBP_Activity_SkinCollect_PayBtn:SetVisibility(visibilityOp)
  end
  if self.Btn_Unlock then
    self.Btn_Unlock:SetVisibility(visibilityOp)
  end
  self:NotifyGamepadActionHintsChanged()
end

function M:RefreshUnlockBtnLoopAnimation(bShouldLoop)
  local payBtn = self.WBP_Activity_SkinCollect_PayBtn
  if not payBtn then
    return
  end
  local loopState = true == bShouldLoop and "Loop" or "UnLoop"
  if self.UnlockBtnLoopState == loopState then
    return
  end
  self.UnlockBtnLoopState = loopState
  local stopAnim = bShouldLoop and payBtn.UnLoop or payBtn.Loop
  if stopAnim then
    payBtn:StopAnimation(stopAnim)
  end
  local playAnim = bShouldLoop and payBtn.Loop or payBtn.UnLoop
  if playAnim then
    payBtn:PlayAnimation(playAnim, 0, 0)
  end
end

function M:StopUnlockBtnLoopAnimation()
  local payBtn = self.WBP_Activity_SkinCollect_PayBtn
  if not payBtn then
    return
  end
  if payBtn.Loop then
    payBtn:StopAnimation(payBtn.Loop)
  end
  if payBtn.UnLoop then
    payBtn:StopAnimation(payBtn.UnLoop)
  end
  self.UnlockBtnLoopState = nil
end

function M:GetClaimAllBtn()
  return self.Btn_Reward or self.Btn_ClaimAll
end

function M:SetClaimAllBtnVisibility(isVisible)
  local visibilityOp = isVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if self.Group_Get then
    self.Group_Get:SetVisibility(visibilityOp)
  end
  local claimAllBtn = self:GetClaimAllBtn()
  if claimAllBtn then
    claimAllBtn:SetVisibility(visibilityOp)
  end
  self:NotifyGamepadActionHintsChanged()
end

function M:RefreshUnlockBtnState(Avatar)
  if self.IsUnlocked then
    self:StopUnlockBtnLoopAnimation()
    self:SetUnlockBtnVisibility(false)
    return
  end
  self:SetUnlockBtnVisibility(true)
  if not self.RewardConfigData then
    return
  end
  local unlockCost = self.RewardConfigData.UnlockItemCount or 0
  local currentScore = self:GetPlayerCurrentScore(Avatar)
  local currentMoonStone = self:GetPlayerResourceCount(Avatar)
  local unlockResourceId = self:GetUnlockResourceId()
  self:SetUnlockBtnPrice(unlockCost, unlockResourceId, currentMoonStone)
  local triggerScore = self.RewardConfigData.PointsTarget and self.RewardConfigData.PointsTarget[1]
  local bCanPlayLoop = triggerScore and currentScore >= triggerScore and unlockCost <= currentMoonStone
  self:RefreshUnlockBtnLoopAnimation(bCanPlayLoop)
end

function M:RefreshClaimAllBtnState(Avatar)
  if not self.IsUnlocked then
    self:SetClaimAllBtnVisibility(false)
    self:OnClaimAllBtnVisibilityChanged(false)
    return
  end
  local hasClaimable = self:HasClaimableReward(Avatar)
  self:SetClaimAllBtnVisibility(hasClaimable)
  self:OnClaimAllBtnVisibilityChanged(hasClaimable)
end

function M:OnClaimAllBtnVisibilityChanged(isVisible)
end

function M:NotifyGamepadActionHintsChanged()
  if type(self.RefreshGamepadActionButtonHints) == "function" then
    self:RefreshGamepadActionButtonHints()
  end
end

function M:ViewInfoBtnClick()
  if not self.ActivityConfigData or not self.ActivityConfigData.EventRule then
    return
  end
  UIManager(self):ShowCommonPopupUI(100192, {
    LongText = GText(self.ActivityConfigData.EventRule),
    ShowBKeyClose = true
  }, self)
end

function M:BindButtons()
  if self.WBP_Activity_SkinCollect_PayBtn and self.WBP_Activity_SkinCollect_PayBtn.Button_Area then
    self.WBP_Activity_SkinCollect_PayBtn.Button_Area.OnClicked:Clear()
    self.WBP_Activity_SkinCollect_PayBtn.Button_Area.OnClicked:Add(self, self.OnClickUnlock)
  end
  local claimAllBtn = self:GetClaimAllBtn()
  if claimAllBtn then
    if claimAllBtn.Text_Button then
      claimAllBtn.Text_Button:SetText(GText("UI_GameEvent_ClaimAll"))
    end
    if claimAllBtn.UnBindEventOnClicked and claimAllBtn.BindEventOnClicked then
      claimAllBtn:UnBindEventOnClicked(self, self.OnClickClaimAll)
      claimAllBtn:BindEventOnClicked(self, self.OnClickClaimAll)
    elseif claimAllBtn.Button_Area and claimAllBtn.Button_Area.OnClicked then
      claimAllBtn.Button_Area.OnClicked:Clear()
      claimAllBtn.Button_Area.OnClicked:Add(self, self.OnClickClaimAll)
    elseif claimAllBtn.OnClicked then
      claimAllBtn.OnClicked:Clear()
      claimAllBtn.OnClicked:Add(self, self.OnClickClaimAll)
    end
  end
  if self.Btn_Confirm.Button_Area then
    self.Btn_Confirm.Button_Area.OnClicked:Clear()
    self.Btn_Confirm.Button_Area.OnClicked:Add(self, self.OnClickSkinTask)
    if self.Btn_Confirm.Text_Button then
      self.Btn_Confirm.Text_Button:SetText(GText("UI_AppearanceCollect_AppearanceCollectTask"))
    end
  end
  if self.Btn_SkinTask then
    self.Btn_SkinTask.OnClicked:Clear()
    self.Btn_SkinTask.OnClicked:Add(self, self.OnClickSkinTask)
  end
end

function M:GetUnlockResourceId()
  if self.RewardConfigData and self.RewardConfigData.UnlockItemType then
    return self.RewardConfigData.UnlockItemType
  end
  return CommonConst.Coins.Coin1
end

function M:GetUnlockShopItemData()
  local unlockResId = self:GetUnlockResourceId()
  return ShopUtils:GetShopItemDataById(unlockResId, CommonConst.DataType.Resource, true)
end

function M:SetUnlockBtnPrice(costNum, resourceId, currentAmount)
  if not self.WBP_Activity_SkinCollect_PayBtn then
    return
  end
  local payBtn = self.WBP_Activity_SkinCollect_PayBtn
  if payBtn.WS_Detail then
    payBtn.WS_Detail:SetActiveWidgetIndex(1)
  end
  if payBtn.Text_BtnBuy then
    payBtn.Text_BtnBuy:SetText(GText("UI_AppearanceCollect_UnlockReward"))
  end
  if payBtn.Group_More then
    payBtn.Group_More:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if payBtn.Text_Undiscounted_Price then
    payBtn.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if payBtn.Panel_Discount then
    payBtn.Panel_Discount:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local IconPath = ItemUtils.GetItemIconPath(resourceId, "Resource")
  if IconPath and payBtn.Icon_Currency then
    payBtn.Icon_Currency.Icon = IconPath
    payBtn.Icon_Currency:SetIcon()
  end
  if payBtn.Text_Price then
    payBtn.Text_Price:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    payBtn.Text_Price:SetText(tostring(costNum or 0))
    local isInsufficient = (currentAmount or 0) < (costNum or 0)
    if isInsufficient then
      payBtn.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DA2A4A"))
    else
      payBtn.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFF"))
    end
  end
end

function M:OnClickUnlock()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not self.RewardConfigData then
    return
  end
  local unlockResId = self:GetUnlockResourceId()
  local unlockCost = self.RewardConfigData.UnlockItemCount or 0
  local currentUnlockCount = self:GetPlayerResourceCount(Avatar)
  if unlockCost <= currentUnlockCount then
    self:ShowUnlockConfirmDialog()
  else
    local needBuy = unlockCost - currentUnlockCount
    if unlockResId == CommonConst.Coins.Coin1 then
      local moonStoneGemCount = self:GetPlayerMoonStoneGemCount(Avatar)
      if needBuy <= moonStoneGemCount then
        self:ShowBuyMoonStoneDialog(unlockCost, currentUnlockCount)
      else
        self:OpenMoonStoneRecharge(unlockCost, currentUnlockCount)
      end
    else
      self:OpenMoonStoneRecharge(unlockCost, currentUnlockCount)
    end
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:ShowUnlockConfirmDialog()
  UIManager(self):ShowCommonPopupUI(100378, {
    RightCallbackFunction = function()
      self:ReqUnlockReward()
    end
  }, self)
end

function M:ShowBuyMoonStoneDialog(unlockCost, currentMoonStone)
  local needBuy = math.max((unlockCost or 0) - (currentMoonStone or 0), 0)
  if needBuy <= 0 then
    self:ShowUnlockConfirmDialog()
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local unlockResId = self:GetUnlockResourceId()
  local coin4Id = CommonConst.Coins.Coin4
  local coin4OwnedCount = Avatar:GetResourceNum(coin4Id) or 0
  local popUpId = 100136
  local popoverText = GText(DataMgr.CommonPopupUIContext[popUpId].PopoverText)
  local unlockResData = DataMgr.Resource[unlockResId]
  local coin4ResData = DataMgr.Resource[coin4Id]
  local unlockResName = unlockResData and GText(unlockResData.ResourceName) or ""
  local coin4ResName = coin4ResData and GText(coin4ResData.ResourceName) or ""
  if string.find(popoverText, "&ResourceName&") then
    popoverText = string.gsub(popoverText, "&ResourceName&", unlockResName)
  end
  if string.find(popoverText, "&ResourceName1&") then
    popoverText = string.gsub(popoverText, "&ResourceName1&", coin4ResName)
  end
  if string.find(popoverText, "&ResourceName2&") then
    popoverText = string.gsub(popoverText, "&ResourceName2&", unlockResName)
  end
  if string.find(popoverText, "&Num1&") then
    popoverText = string.gsub(popoverText, "&Num1&", needBuy)
  end
  if string.find(popoverText, "&Num2&") then
    popoverText = string.gsub(popoverText, "&Num2&", needBuy)
  end
  local ItemList = {
    {
      ItemId = coin4Id,
      ItemType = CommonConst.ItemType.Resource,
      ItemNum = coin4OwnedCount,
      ItemNeed = needBuy
    }
  }
  UIManager(self):ShowCommonPopupUI(popUpId, {
    RightCallbackFunction = function()
      self:ReqBuyMoonStone(needBuy, function()
        self:ShowUnlockConfirmDialog()
      end)
    end,
    ItemList = ItemList,
    ShortText = popoverText
  }, self)
end

function M:OpenMoonStoneRecharge(unlockCost, currentMoonStone)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local unlockResId = self:GetUnlockResourceId()
  local needBuy = math.max((unlockCost or 0) - (currentMoonStone or 0), 1)
  local needCostType = CommonConst.Coins.Coin4
  local needCost = needBuy
  if unlockResId == CommonConst.Coins.Coin1 then
    needCost = needBuy
  elseif unlockResId == CommonConst.Coins.Coin4 then
    needCost = needBuy
  else
    local _, shopItemData = self:GetUnlockShopItemData()
    if shopItemData and shopItemData.PriceType then
      local typeNum = shopItemData.TypeNum or 1
      local needShopCount = math.ceil(needBuy / typeNum)
      local unitPrice = ShopUtils:GetShopItemPrice(shopItemData.ItemId) or shopItemData.Price or 0
      needCostType = shopItemData.PriceType
      needCost = math.max(needShopCount * unitPrice, 1)
    end
  end
  UIManager(self):LoadUINew("ShopTargetPay", {
    CostType = needCostType,
    CostNum = needCost,
    RightCallbackObj = self,
    CallbackInfo = {
      Func = self.OnRechargeCallback,
      Obj = self
    }
  }, self)
end

function M:OnRechargeCallback()
  self:RefreshUnlockBtnStateWithCurrentAvatar()
end

function M:OnClickClaimAll()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not self:HasClaimableReward(Avatar) then
    self:SyncClaimableReddot(Avatar)
    return
  end
  self:ReqClaimAllReward()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:OnClickSkinTask()
  local PageConfigData = DataMgr.EventPortal and DataMgr.EventPortal[self.CurActivityId]
  if not PageConfigData or not PageConfigData.JumpUIId then
    return
  end
  PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpUIId, self.CurActivityId)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:GetPlayerResourceCount(Avatar)
  if not Avatar then
    return 0
  end
  local unlockResId = self:GetUnlockResourceId()
  return Avatar:GetResourceNum(unlockResId) or 0
end

function M:GetPlayerMoonStoneGemCount(Avatar)
  if not Avatar then
    return 0
  end
  return Avatar:GetResourceNum(CommonConst.Coins.Coin4) or 0
end

function M:RefreshUnlockBtnStateWithCurrentAvatar()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self:RefreshUnlockBtnState(Avatar)
end

function M:OnResourcesChanged(ResourceId)
  if self.IsUnlocked then
    return
  end
  local unlockResId = self:GetUnlockResourceId()
  if not ResourceId or ResourceId == unlockResId or ResourceId == CommonConst.Coins.Coin4 then
    self:RefreshUnlockBtnStateWithCurrentAvatar()
    return
  end
  local _, shopItemData = self:GetUnlockShopItemData()
  if shopItemData and shopItemData.PriceType == ResourceId then
    self:RefreshUnlockBtnStateWithCurrentAvatar()
  end
end

function M:ReqUnlockReward()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function OnUnlockCallback(RetCode)
    if 0 == RetCode then
      self:OnUnlockSuccess()
    else
      UIManager(self):ShowError(RetCode, 1.0, "CommonToastMain")
    end
  end
  
  Avatar:AppearanceCollectEventUnlockReward(OnUnlockCallback, self.CurActivityId)
end

function M:ReqBuyMoonStone(count, callback)
  if not count or count <= 0 then
    if callback then
      callback()
    end
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local unlockResId = self:GetUnlockResourceId()
  if unlockResId == CommonConst.Coins.Coin1 then
    local moonStoneGemCount = self:GetPlayerMoonStoneGemCount(Avatar)
    if count > moonStoneGemCount then
      self:OpenMoonStoneRecharge(self.RewardConfigData and self.RewardConfigData.UnlockItemCount or count, self:GetPlayerResourceCount(Avatar))
      return
    end
    Avatar:TransformCoin4ToCoin1(count, function()
      local curAvatar = GWorld:GetAvatar()
      self:RefreshUnlockBtnState(curAvatar)
      if callback then
        callback()
      end
    end)
    return
  end
  local shopItemId, shopItemData = self:GetUnlockShopItemData()
  if not shopItemId or not shopItemData then
    UIManager(self):ShowUITip("CommonToastMain", GText("Unknown_Error"), 1.0)
    return
  end
  local typeNum = shopItemData.TypeNum or 1
  local needShopCount = math.ceil(count / typeNum)
  Avatar:PurchaseShopItem(shopItemId, needShopCount, true, function(Ret)
    local isSuccess = 0 == Ret or ErrorCode and Ret == ErrorCode.RET_SUCCESS
    if isSuccess then
      local curAvatar = GWorld:GetAvatar()
      self:RefreshUnlockBtnState(curAvatar)
      if callback then
        callback()
      end
    else
      UIManager(self):ShowError(Ret, 1.0, "CommonToastMain")
    end
  end)
end

function M:ReqClaimAllReward()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not self.RewardConfigData then
    return
  end
  local currentScore = self:GetPlayerCurrentScore(Avatar)
  local pointsTarget = self.RewardConfigData.PointsTarget
  if not pointsTarget then
    return
  end
  local claimableRewardIndexes = {}
  for i, target in ipairs(pointsTarget) do
    local rewardIds = self:GetRewardIdsForIndex(self.RewardConfigData.PointsReward, i)
    if self:GetRewardItemState(Avatar, i, currentScore, target, rewardIds) == "Claimable" then
      table.insert(claimableRewardIndexes, i)
    end
  end
  if 0 == #claimableRewardIndexes then
    return
  end
  Avatar:AppearanceCollectEventGetReward(function(RetCode, Rewards)
    if 0 ~= RetCode then
      UIManager(self):ShowError(RetCode, 1.0, "CommonToastMain")
      return
    end
    local curAvatar = GWorld:GetAvatar()
    if not curAvatar then
      return
    end
    self.IsUnlocked = self:CheckIsUnlocked(curAvatar)
    self:RefreshScoreDisplay(curAvatar)
    self:RefreshItemList(curAvatar)
    self:RefreshUnlockBtnState(curAvatar)
    self:RefreshClaimAllBtnState(curAvatar)
    self:SyncClaimableReddot(curAvatar)
    self:ShowClaimAllRewardPopup(curAvatar, claimableRewardIndexes, Rewards)
  end, self.CurActivityId, -1)
end

function M:TryClaimRewardByIndex(rewardIndex)
  if not rewardIndex or rewardIndex <= 0 then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not self.RewardConfigData then
    return false
  end
  local pointsTarget = self.RewardConfigData.PointsTarget
  local target = pointsTarget and pointsTarget[rewardIndex]
  if not target then
    return false
  end
  local currentScore = self:GetPlayerCurrentScore(Avatar)
  local rewardIds = self:GetRewardIdsForIndex(self.RewardConfigData.PointsReward, rewardIndex)
  if self:GetRewardItemState(Avatar, rewardIndex, currentScore, target, rewardIds) ~= "Claimable" then
    return false
  end
  Avatar:AppearanceCollectEventGetReward(function(RetCode)
    if 0 ~= RetCode then
      UIManager(self):ShowError(RetCode, 1.0, "CommonToastMain")
      return
    end
    local curAvatar = GWorld:GetAvatar()
    if not curAvatar then
      return
    end
    self.IsUnlocked = self:CheckIsUnlocked(curAvatar)
    self:RefreshScoreDisplay(curAvatar)
    self:RefreshItemList(curAvatar)
    self:RefreshUnlockBtnState(curAvatar)
    self:RefreshClaimAllBtnState(curAvatar)
    self:SyncClaimableReddot(curAvatar)
    self:ShowClaimRewardPopup(curAvatar, rewardIndex)
  end, self.CurActivityId, rewardIndex)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  return true
end

function M:OnUnlockSuccess()
  self.IsUnlocked = true
  self:SetUnlockBtnVisibility(false)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    self:RefreshClaimAllBtnState(nil)
    return
  end
  self:RefreshItemList(Avatar, true)
  self:RefreshUnlockBtnState(Avatar)
  self:RefreshClaimAllBtnState(Avatar)
  self:SyncClaimableReddot(Avatar)
end

return M
