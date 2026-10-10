require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.WBP.Activity.Widget.ConditionRewardActivity.ConditionRewardActiviyBase",
  "BluePrints.Common.DelayFrameComponent"
})
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")

function M:Construct()
  self.Group_Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.List_Item:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    self.LeaveRewardViewMode
  })
end

function M:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:InitUI()
  self:ResetGamePadState()
  self.List_Item:ClearListItems()
  for Index, RewardState in ipairs(self.RewardStateList or {}) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.RewardId = RewardState.RewardId
    Content.Index = Index
    Content.ParentWidget = self
    Content.RewardClaimDes = RewardState.RewardClaimDes
    Content.IsGetReward = RewardState.IsGetReward
    Content.CanClaim = RewardState.CanClaim
    self.List_Item:AddItem(Content)
  end
  self.List_Item:DisableScroll(true)
  self.Activity_TimeView = self.Activity_Time
  self.Text_ActivityDescView = self.Text_ActivityDesc_White
  self:InitCommonUI()
  local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
  if ActivityConfigData and ActivityConfigData.EventNameBPPath then
    if not self.TitleWidget then
      self.Group_TitleAnchor:ClearChildren()
      self.TitleWidget = UIManager(self):CreateWidget(ActivityConfigData.EventNameBPPath)
      if self.TitleWidget then
        self.Group_TitleAnchor:AddChildToOverlay(self.TitleWidget)
      end
    end
    if self.TitleWidget then
      self.TitleWidget.Text_Title:SetText(GText(ActivityConfigData.EventName))
      self.TitleWidget.Text_SubTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Group_TitleAnchor:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.TitleWidget:PlayAnimation(self.TitleWidget.In)
    end
  end
  self:UpdateUIByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
  ActivityUtils.SetUpJustifyOfJap(self.Text_ActivityDesc_White)
end

function M:UpdatePage(OperateSrc)
  self:UpdateActivityConditionAndRewardState()
  self:InitUI()
  self.bNeedFocusActivityTabAfterJump = "BackToPageWithJump" == OperateSrc
end

function M:ReceiveEnterStateSelf(StackAction)
  if 1 ~= StackAction or not self.bNeedFocusActivityTabAfterJump then
    return
  end
  self.bNeedFocusActivityTabAfterJump = false
  self:AddDelayFrameFunc(function()
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
      return
    end
    local ParentWidget = self.ParentWidget
    if not (ParentWidget and ParentWidget.AllCurrentActivityPage) or ParentWidget.AllCurrentActivityPage[ParentWidget.CurTabId] ~= self then
      return
    end
    self:UpdateParentActivityKeyTips("SelectView", nil, true)
  end, 1, "AnniversaryFocusActivityTabAfterJump")
end

function M:UpdateUIByInputDevice(CurInputDeviceType)
  if CurInputDeviceType == ECommonInputType.Gamepad then
    local SelectedContent = self.List_Item:BP_GetSelectedItem()
    local SelectedTaskItem = SelectedContent and SelectedContent.SelfWidget
    local bIsTaskListFocused = self.List_Item:HasAnyUserFocus() or self.List_Item:HasFocusedDescendants()
    if SelectedTaskItem and (bIsTaskListFocused or SelectedTaskItem.IsFocusRewardItem) then
      self:SyncTaskItemGamepadState(SelectedTaskItem)
    end
  end
  self:RefreshTaskItemGamepadStyle()
end

function M:SyncTaskItemGamepadState(TaskItem)
  if not TaskItem then
    return
  end
  local bWasInRewardItemView = self.IsEnterRewardItemViewMode
  self.IsEnterRewardViewMode = true
  self.IsEnterRewardItemViewMode = true == TaskItem.IsFocusRewardItem
  self.IsRewardTipsOpen = self.IsEnterRewardItemViewMode and true == TaskItem.IsRewardTipsOpen
  self.CurFocusedTaskItem = TaskItem
  if self.IsRewardTipsOpen then
    self:UpdateParentActivityKeyTips("EmptyView", TaskItem)
  elseif self.IsEnterRewardItemViewMode then
    self:UpdateParentActivityKeyTips("CheckRewardDetailView", TaskItem)
  else
    self:UpdateParentActivityKeyTips("DefaultWidget", self.List_Item)
  end
  if self.IsEnterRewardItemViewMode then
    self:EnterActivityForbiddenState()
  elseif bWasInRewardItemView then
    self:LeaveActivityForbiddenState()
  end
end

function M:RefreshTaskItemGamepadStyle()
  local ItemWidgets = self.List_Item:GetDisplayedEntryWidgets()
  for Index = 1, ItemWidgets:Length() do
    local ItemWidget = ItemWidgets:GetRef(Index)
    if ItemWidget and ItemWidget.SetGamepadIconVisibility then
      local bShow = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self.IsEnterRewardViewMode and not self.IsEnterRewardItemViewMode and ItemWidget == self.CurFocusedTaskItem
      ItemWidget:SetGamepadIconVisibility(bShow)
    end
  end
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return false
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  return self:OnGamePadButtonDown(InKeyName)
end

function M:OnGamePadButtonDown(InKeyName)
  local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.IsRewardTipsOpen then
      return false
    end
    if self.IsEnterRewardItemViewMode and self.CurFocusedTaskItem then
      return self.CurFocusedTaskItem:LeaveRewardItemViewMode()
    end
    if self.IsEnterRewardViewMode then
      return self:LeaveRewardViewMode()
    end
    return false
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if not self.IsEnterRewardViewMode then
      return self:EnterRewardViewMode()
    end
  elseif InKeyName == UIConst.GamePadKey.LeftStickRight and not self.IsEnterRewardViewMode then
    return self:EnterRewardViewMode()
  end
  return false
end

function M:GetCurFocusWidgetInfo()
  return self.FocusWidgetName, self.FocusWidgetWidget
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

function M:ResetGamePadState()
  if self.IsEnterRewardItemViewMode then
    self:LeaveActivityForbiddenState()
  end
  local TaskItem = self.CurFocusedTaskItem
  if TaskItem then
    TaskItem.IsFocusRewardItem = false
    TaskItem.IsRewardTipsOpen = false
    TaskItem:SetGamepadIconVisibility(false)
  end
  self.FocusWidgetName = "SelectView"
  self.FocusWidgetWidget = nil
  self.IsEnterRewardViewMode = false
  self.IsEnterRewardItemViewMode = false
  self.IsRewardTipsOpen = false
  self.CurFocusedTaskItem = nil
  self:RefreshTaskItemGamepadStyle()
end

function M:FocusTaskItem(Index)
  Index = Index or 1
  local Content = self.List_Item:GetItemAt(Index - 1)
  if not Content then
    return false
  end
  self.List_Item:SetSelectedIndex(Index - 1)
  self.List_Item:BP_NavigateToItem(Content)
  local ItemWidget = Content.SelfWidget
  if ItemWidget then
    ItemWidget:SetFocus()
    self.CurFocusedTaskItem = ItemWidget
  else
    self.List_Item:SetFocus()
  end
  return true
end

function M:EnterRewardViewMode()
  if self.IsEnterRewardViewMode then
    return false
  end
  self.IsEnterRewardViewMode = true
  self.IsEnterRewardItemViewMode = false
  self.IsRewardTipsOpen = false
  self:UpdateParentActivityKeyTips("DefaultWidget", self.List_Item)
  local bFocused = self:FocusTaskItem(1)
  if not bFocused then
    self.IsEnterRewardViewMode = false
    self:UpdateParentActivityKeyTips("SelectView", nil)
  end
  self:RefreshTaskItemGamepadStyle()
  return bFocused
end

function M:LeaveRewardViewMode()
  if not self.IsEnterRewardViewMode then
    return false
  end
  self:ResetGamePadState()
  self:UpdateParentActivityKeyTips("SelectView", nil, true)
  return true
end

function M:OnTaskItemFocused(TaskItem)
  self:SyncTaskItemGamepadState(TaskItem)
  self:RefreshTaskItemGamepadStyle()
end

function M:OnEnterRewardItemView(TaskItem)
  if not self.IsEnterRewardViewMode then
    return false
  end
  self.CurFocusedTaskItem = TaskItem
  self.IsEnterRewardItemViewMode = true
  self.IsRewardTipsOpen = false
  self:UpdateParentActivityKeyTips("CheckRewardDetailView", TaskItem)
  self:RefreshTaskItemGamepadStyle()
  self:EnterActivityForbiddenState()
  return true
end

function M:OnLeaveRewardItemView(TaskItem)
  self.CurFocusedTaskItem = TaskItem or self.CurFocusedTaskItem
  self.IsEnterRewardItemViewMode = false
  self.IsRewardTipsOpen = false
  self:UpdateParentActivityKeyTips("DefaultWidget", self.List_Item)
  self:RefreshTaskItemGamepadStyle()
  self:LeaveActivityForbiddenState()
end

function M:EnterActivityForbiddenState()
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  if ActivityMain then
    ActivityMain:UpdateCommonWidgetsStyleInPlatform(false)
    ActivityMain:EnterForbiddenState()
  end
end

function M:LeaveActivityForbiddenState()
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  if ActivityMain then
    ActivityMain:UpdateCommonWidgetsStyleInPlatform(true)
    ActivityMain:LeaveForbiddenState()
  end
end

function M:OnRewardTipsOpenChanged(bIsOpen)
  if not self.IsEnterRewardItemViewMode then
    return
  end
  self.IsRewardTipsOpen = bIsOpen
  if bIsOpen then
    self:UpdateParentActivityKeyTips("EmptyView", self.CurFocusedTaskItem)
  else
    self:UpdateParentActivityKeyTips("CheckRewardDetailView", self.CurFocusedTaskItem)
  end
end

function M:OnSubTabNavigationRight()
  self:EnterRewardViewMode()
end

return M
