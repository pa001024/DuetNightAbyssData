require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_UIState_C")
local NORMAL_STYLE_INDEX = 0
local HIGHLIGHT_STYLE_INDEX = 1
local ENTER_ANIMATION_TIMER = "SkinCollectTaskPopupItemEnterAnimation"
local DETAIL_LAYOUT_REFRESH_TIMER = "SkinCollectTaskPopupItemDetailLayoutRefresh"
local SUB_TASK_MOUSE_WHEEL_SCROLL_STEP = 1

local function StopUINavigation(Widget)
  if not Widget or not Widget.SetNavigationRuleBase then
    return
  end
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
end

local function GetScrollOffset(Widget)
  if Widget and Widget.GetScrollOffset then
    return Widget:GetScrollOffset()
  end
  return nil
end

local function GetScrollEndOffset(Widget)
  if Widget and Widget.GetScrollOffsetOfEnd then
    return Widget:GetScrollOffsetOfEnd()
  end
  return nil
end

local function SetScrollOffset(Widget, Offset)
  if not Widget or type(Offset) ~= "number" then
    return false
  end
  if Widget.SetScrollOffset then
    Widget:SetScrollOffset(Offset)
    return true
  end
  if Widget.SetCurrentScrollOffset then
    Widget:SetCurrentScrollOffset(Offset)
    return true
  end
  if Offset <= 0 and Widget.ScrollToTop then
    Widget:ScrollToTop()
    return true
  end
  return false
end

local function GetSubTaskStableId(SubTaskInfo)
  return SubTaskInfo and (SubTaskInfo.Id or SubTaskInfo.SubTaskId or SubTaskInfo.ItemId)
end

local function IsWidgetUnderMouse(Widget, MouseEvent)
  if not Widget or not MouseEvent then
    return false
  end
  if Widget.IsHovered and Widget:IsHovered() then
    return true
  end
  if Widget.GetCachedGeometry and UE4.USlateBlueprintLibrary and UE4.USlateBlueprintLibrary.IsUnderLocation then
    local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
    return UE4.USlateBlueprintLibrary.IsUnderLocation(Widget:GetCachedGeometry(), MousePos)
  end
  return false
end

function M:Init(Content)
  self.Content = Content
  self:StopNativeUINavigation()
  self:RefreshView()
  local OwnerPopup = self.Content and self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.bTaskTypeEnterBatchActive and OwnerPopup.RequestTaskTypeItemEnterAnimation then
    self:PrepareEnterAnimation()
    OwnerPopup:RequestTaskTypeItemEnterAnimation(self)
  end
end

function M:OnListItemObjectSet(Content)
  self:Init(Content)
end

function M:BP_OnEntryReleased()
  self:RemoveTimer(ENTER_ANIMATION_TIMER)
  self:RemoveTimer(DETAIL_LAYOUT_REFRESH_TIMER)
  self:UnBindClickEvent()
  self:SetGamepadFocused(false)
  if self.Content and self.Content.OwnerPopup and self.Content.OwnerPopup.OnTaskTypeEntryReleased then
    self.Content.OwnerPopup:OnTaskTypeEntryReleased(self)
  end
  self.Content = nil
  self:SetDetailExpanded(false, true)
  if self.List_SubItem then
    self.List_SubItem:ClearListItems()
  end
end

function M:PrepareEnterAnimation()
  self:RemoveTimer(ENTER_ANIMATION_TIMER)
  if self.In then
    self:StopAnimation(self.In)
    self:SetRenderOpacity(0)
    return
  end
  self:SetRenderOpacity(1)
end

function M:RequestEnterAnimation(Delay)
  self:RemoveTimer(ENTER_ANIMATION_TIMER)
  if not self.In then
    self:SetRenderOpacity(1)
    return
  end
  local RealDelay = type(Delay) == "number" and Delay or 0
  if RealDelay > 0 then
    self:AddTimer(RealDelay, self.PlayPreparedEnterAnimation, false, 0, ENTER_ANIMATION_TIMER, true)
    return
  end
  self:PlayPreparedEnterAnimation()
end

function M:EnsureEnterAnimationVisible()
  self:RemoveTimer(ENTER_ANIMATION_TIMER)
  self:SetRenderOpacity(1)
end

function M:PlayPreparedEnterAnimation()
  self:RemoveTimer(ENTER_ANIMATION_TIMER)
  self:SetRenderOpacity(1)
  self:PlayEnterAnimation()
end

function M:OnInAnimationFinished()
  M.Super.OnInAnimationFinished(self)
  if self.IsDetailExpanded ~= true then
    self:SetDetailExpanded(false, true)
  end
end

function M:RefreshView()
  if not self.Content then
    return
  end
  self:StopNativeUINavigation()
  local IsHighlight = self.Content.Highlight == true
  local ActiveWidgetIndex = IsHighlight and HIGHLIGHT_STYLE_INDEX or NORMAL_STYLE_INDEX
  if self.WS_Item then
    self.WS_Item:SetActiveWidgetIndex(ActiveWidgetIndex)
  end
  local DisplayWidget = self:GetActiveTypeItem()
  if not DisplayWidget then
    return
  end
  if DisplayWidget.RefreshView then
    DisplayWidget:RefreshView(self.Content)
  end
  if DisplayWidget.SetOwnerPopupItem then
    DisplayWidget:SetOwnerPopupItem(self)
  end
  self:BindClickEvent()
  self:SetDetailExpanded(false, true)
  self:RefreshSubTaskList()
end

function M:RefreshViewKeepState()
  local bWasExpanded = self.IsDetailExpanded == true
  if not bWasExpanded then
    self:RefreshView()
    return
  end
  local SubTaskScrollOffset = self:GetSubTaskScrollOffset()
  if not self.Content then
    return
  end
  self:StopNativeUINavigation()
  local IsHighlight = true == self.Content.Highlight
  local ActiveWidgetIndex = IsHighlight and HIGHLIGHT_STYLE_INDEX or NORMAL_STYLE_INDEX
  if self.WS_Item then
    self.WS_Item:SetActiveWidgetIndex(ActiveWidgetIndex)
  end
  local DisplayWidget = self:GetActiveTypeItem()
  if DisplayWidget and DisplayWidget.RefreshView then
    DisplayWidget:RefreshView(self.Content)
  end
  if DisplayWidget and DisplayWidget.SetOwnerPopupItem then
    DisplayWidget:SetOwnerPopupItem(self)
  end
  self:BindClickEvent()
  self.IsDetailExpanded = true
  self:RefreshTypeItemSelectedState()
  self:RefreshSubTaskList()
  if type(SubTaskScrollOffset) == "number" then
    self:SetSubTaskScrollOffset(SubTaskScrollOffset)
  end
end

function M:GetActiveTypeItem()
  if self.Content and self.Content.Highlight == true then
    return self.TaskTypeItem_Highlight
  end
  return self.TaskTypeItem_Normal
end

function M:StopNativeUINavigation()
  StopUINavigation(self)
  StopUINavigation(self.List_SubItem)
  if self.TaskTypeItem_Normal and self.TaskTypeItem_Normal.StopNativeUINavigation then
    self.TaskTypeItem_Normal:StopNativeUINavigation()
  else
    StopUINavigation(self.TaskTypeItem_Normal)
  end
  if self.TaskTypeItem_Highlight and self.TaskTypeItem_Highlight.StopNativeUINavigation then
    self.TaskTypeItem_Highlight:StopNativeUINavigation()
  else
    StopUINavigation(self.TaskTypeItem_Highlight)
  end
end

function M:BindClickEvent()
  self:UnBindClickEvent()
  if self.TaskTypeItem_Normal and self.TaskTypeItem_Normal.SetClickCallback then
    if self.TaskTypeItem_Normal.SetOwnerPopupItem then
      self.TaskTypeItem_Normal:SetOwnerPopupItem(self)
    end
    self.TaskTypeItem_Normal:SetClickCallback(self, self.OnPopupItemClicked)
  end
  if self.TaskTypeItem_Highlight and self.TaskTypeItem_Highlight.SetClickCallback then
    if self.TaskTypeItem_Highlight.SetOwnerPopupItem then
      self.TaskTypeItem_Highlight:SetOwnerPopupItem(self)
    end
    self.TaskTypeItem_Highlight:SetClickCallback(self, self.OnPopupItemClicked)
  end
end

function M:UnBindClickEvent()
  if self.TaskTypeItem_Normal and self.TaskTypeItem_Normal.ClearClickCallback then
    self.TaskTypeItem_Normal:ClearClickCallback()
  end
  if self.TaskTypeItem_Highlight and self.TaskTypeItem_Highlight.ClearClickCallback then
    self.TaskTypeItem_Highlight:ClearClickCallback()
  end
end

function M:SetDetailExpanded(IsExpanded, IsJumpToEnd)
  self.IsDetailExpanded = true == IsExpanded
  local LayoutRefreshDelay = self:PlayDetailStateAnimation(self.IsDetailExpanded, IsJumpToEnd)
  self:RefreshTypeItemSelectedState()
  if not IsJumpToEnd then
    self:RequestOwnerTaskTypeLayoutRefresh(LayoutRefreshDelay)
  end
end

function M:PlayEnterAnimation(IsJumpToEnd)
  if self.View then
    self:StopAnimation(self.View)
  end
  if self.IsDetailExpanded and self.Hide then
    self:StopAnimation(self.Hide)
  end
  if not self.In then
    return
  end
  if IsJumpToEnd and self.In.GetEndTime then
    self:PlayAnimation(self.In, self.In:GetEndTime())
    return
  end
  self:PlayAnimation(self.In)
end

function M:PlayDetailStateAnimation(IsExpanded, IsJumpToEnd)
  local Animation = IsExpanded and self.View or self.Hide
  local OppositeAnimation = IsExpanded and self.Hide or self.View
  if OppositeAnimation then
    self:StopAnimation(OppositeAnimation)
  end
  if not IsExpanded then
    self:ResetSubTaskListScrollOffset()
  end
  if not Animation then
    return 0
  end
  if IsJumpToEnd and Animation.GetEndTime then
    self:PlayAnimation(Animation, Animation:GetEndTime())
    return 0
  end
  self:PlayAnimation(Animation)
  if Animation.GetEndTime then
    return Animation:GetEndTime()
  end
  return 0
end

function M:RequestOwnerTaskTypeLayoutRefresh(Delay)
  self:RemoveTimer(DETAIL_LAYOUT_REFRESH_TIMER)
  local RealDelay = type(Delay) == "number" and Delay or 0
  if RealDelay > 0 then
    self:AddTimer(RealDelay, self.NotifyOwnerTaskTypeLayoutChanged, false, 0, DETAIL_LAYOUT_REFRESH_TIMER, true)
    return
  end
  self:NotifyOwnerTaskTypeLayoutChanged()
end

function M:NotifyOwnerTaskTypeLayoutChanged()
  self:RemoveTimer(DETAIL_LAYOUT_REFRESH_TIMER)
  local OwnerPopup = self.Content and self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.OnTaskTypeItemLayoutChanged then
    OwnerPopup:OnTaskTypeItemLayoutChanged(self)
  end
end

function M:ResetSubTaskListScrollOffset()
  self:SetSubTaskScrollOffset(0)
end

function M:RefreshTypeItemSelectedState(bKeepCurrentState)
  local ActiveTypeItem = self:GetActiveTypeItem()
  local bNormalSelected = self.IsDetailExpanded and ActiveTypeItem == self.TaskTypeItem_Normal
  local bHighlightSelected = self.IsDetailExpanded and ActiveTypeItem == self.TaskTypeItem_Highlight
  if self.TaskTypeItem_Normal and self.TaskTypeItem_Normal.SetSelected then
    self.TaskTypeItem_Normal:SetSelected(bNormalSelected, true == bKeepCurrentState and bNormalSelected)
  end
  if self.TaskTypeItem_Highlight and self.TaskTypeItem_Highlight.SetSelected then
    self.TaskTypeItem_Highlight:SetSelected(bHighlightSelected, true == bKeepCurrentState and bHighlightSelected)
  end
end

function M:GetTaskTypeIndex()
  return self.Content and self.Content.TaskTypeIndex
end

function M:GetGamepadFocusWidget()
  return self:GetActiveTypeItem() or self
end

function M:SetGamepadFocused(IsFocused, bKeepCurrentState)
  local bShouldKeepCurrentState = bKeepCurrentState
  if nil == bShouldKeepCurrentState then
    bShouldKeepCurrentState = self.IsGamepadFocused == (true == IsFocused)
  end
  self.IsGamepadFocused = true == IsFocused
  local ActiveTypeItem = self:GetActiveTypeItem()
  if ActiveTypeItem and ActiveTypeItem.SetGamepadFocused then
    ActiveTypeItem:SetGamepadFocused(self.IsGamepadFocused, bShouldKeepCurrentState)
  end
end

function M:OnTypeItemFocusReceived()
  local OwnerPopup = self.Content and self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.OnTaskTypeItemGamepadFocusReceived then
    OwnerPopup:OnTaskTypeItemGamepadFocusReceived(self)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local OwnerPopup = self.Content and self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.IsGamepadFocusingSubTaskForTaskType and OwnerPopup:IsGamepadFocusingSubTaskForTaskType(self:GetTaskTypeIndex()) then
    return UIUtils.Handled
  end
  local FocusWidget = self:GetGamepadFocusWidget()
  if UIUtils.IsGamepadInput() and FocusWidget and FocusWidget ~= self and FocusWidget.SetFocus then
    FocusWidget:SetFocus()
  end
  self:OnTypeItemFocusReceived()
  return UIUtils.Handled
end

function M:IsSubTaskListUnderMouse(MouseEvent)
  if self.IsDetailExpanded ~= true or not self.List_SubItem then
    return false
  end
  return IsWidgetUnderMouse(self.List_SubItem, MouseEvent)
end

function M:ScrollSubTaskListByMouseWheel(MouseEvent)
  local WheelDelta = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(MouseEvent)
  local CurrentOffset = GetScrollOffset(self.List_SubItem)
  local EndOffset = GetScrollEndOffset(self.List_SubItem)
  if type(WheelDelta) == "number" and 0 ~= WheelDelta and type(CurrentOffset) == "number" and type(EndOffset) == "number" and EndOffset > 0 then
    local NextOffset = math.clamp(CurrentOffset - WheelDelta * SUB_TASK_MOUSE_WHEEL_SCROLL_STEP, 0, EndOffset)
    SetScrollOffset(self.List_SubItem, NextOffset)
  end
  return UIUtils.Handled
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  if self:IsSubTaskListUnderMouse(MouseEvent) then
    return self:ScrollSubTaskListByMouseWheel(MouseEvent)
  end
  return UIUtils.Unhandled
end

function M:OnPopupItemClicked()
  if self.Content and self.Content.OwnerPopup and self.Content.OwnerPopup.OnTaskTypeItemClicked then
    self.Content.OwnerPopup:OnTaskTypeItemClicked(self)
    return
  end
  self:SetDetailExpanded(not self.IsDetailExpanded)
end

function M:GetSubTaskCount()
  local SubTaskList = self.Content and self.Content.SubTaskList
  if type(SubTaskList) == "table" then
    return #SubTaskList
  end
  if self.List_SubItem and self.List_SubItem.GetListItems then
    local ListItems = self.List_SubItem:GetListItems()
    if ListItems and ListItems.ToTable then
      return #ListItems:ToTable()
    end
  end
  return 0
end

function M:GetSubTaskEntryByIndex(SubTaskIndex)
  if not self.List_SubItem then
    return nil
  end
  if self.List_SubItem.GetDisplayedEntryWidgets then
    local EntryWidgets = self.List_SubItem:GetDisplayedEntryWidgets()
    local EntryList = EntryWidgets and EntryWidgets.ToTable and EntryWidgets:ToTable() or {}
    for _, SubTaskItem in ipairs(EntryList) do
      if IsValid(SubTaskItem) and SubTaskItem.Content and SubTaskItem.Content.SubTaskIndex == SubTaskIndex then
        return SubTaskItem
      end
    end
  end
  if self.List_SubItem.GetListItems then
    local ListItems = self.List_SubItem:GetListItems()
    local ContentList = ListItems and ListItems.ToTable and ListItems:ToTable() or {}
    for _, Content in ipairs(ContentList) do
      if Content and Content.SubTaskIndex == SubTaskIndex and IsValid(Content.SelfWidget) then
        return Content.SelfWidget
      end
    end
  end
  return nil
end

function M:ScrollSubTaskIntoView(SubTaskIndex, SubTaskItem)
  if not self.List_SubItem then
    return
  end
  local ListIndex = math.max((SubTaskIndex or 1) - 1, 0)
  if self.List_SubItem.ScrollIndexIntoView then
    self.List_SubItem:ScrollIndexIntoView(ListIndex)
  elseif self.List_SubItem.NavigateToIndex then
    self.List_SubItem:NavigateToIndex(ListIndex)
  end
  if SubTaskItem and self.List_SubItem.ScrollWidgetIntoView then
    if UE4.EDescendantScrollDestination then
      self.List_SubItem:ScrollWidgetIntoView(SubTaskItem, true, UE4.EDescendantScrollDestination.IntoView)
    else
      self.List_SubItem:ScrollWidgetIntoView(SubTaskItem, true)
    end
  end
end

function M:FocusSubTaskList(SubTaskIndex, bSkipScroll)
  if not self.List_SubItem then
    return false, nil
  end
  self:StopNativeUINavigation()
  local ListIndex = math.max((SubTaskIndex or 1) - 1, 0)
  self.List_SubItem.bIsFocusable = true
  if true ~= bSkipScroll then
    local TargetContent = self.List_SubItem.GetItemAt and self.List_SubItem:GetItemAt(ListIndex) or nil
    if TargetContent and self.List_SubItem.BP_NavigateToItem then
      self.List_SubItem:BP_NavigateToItem(TargetContent)
    elseif self.List_SubItem.NavigateToIndex then
      self.List_SubItem:NavigateToIndex(ListIndex)
    elseif self.List_SubItem.ScrollIndexIntoView then
      self.List_SubItem:ScrollIndexIntoView(ListIndex)
    end
    if TargetContent and self.List_SubItem.BP_SetItemSelection then
      self.List_SubItem:BP_SetItemSelection(TargetContent, true)
    elseif TargetContent and self.List_SubItem.BP_SetSelectedItem then
      self.List_SubItem:BP_SetSelectedItem(TargetContent)
    elseif self.List_SubItem.SetSelectedIndex then
      self.List_SubItem:SetSelectedIndex(ListIndex)
    elseif self.List_SubItem.SetSelectItemIndex then
      self.List_SubItem:SetSelectItemIndex(ListIndex)
    end
  end
  local TargetSubTaskItem = self:GetSubTaskEntryByIndex(SubTaskIndex)
  if IsValid(TargetSubTaskItem) then
    if TargetSubTaskItem.SetFocus then
      TargetSubTaskItem:SetFocus()
    end
    return true, TargetSubTaskItem
  end
  return false, nil
end

function M:GetSubTaskScrollOffset()
  return GetScrollOffset(self.List_SubItem)
end

function M:SetSubTaskScrollOffset(Offset)
  return SetScrollOffset(self.List_SubItem, Offset)
end

function M:FindSubTaskIndexById(SubTaskId)
  if nil == SubTaskId then
    return nil
  end
  local TargetId = tostring(SubTaskId)
  local SubTaskList = self.Content and self.Content.SubTaskList
  if type(SubTaskList) ~= "table" then
    return nil
  end
  for Index, SubTaskInfo in ipairs(SubTaskList) do
    local StableId = GetSubTaskStableId(SubTaskInfo)
    if nil ~= StableId and tostring(StableId) == TargetId then
      return Index
    end
  end
  return nil
end

function M:RefreshSubTaskList()
  if not self.List_SubItem then
    return
  end
  self:StopNativeUINavigation()
  self.List_SubItem:ClearListItems()
  self.List_SubItem:SetControlScrollbarInside(true)
  local SubTaskList = self.Content and self.Content.SubTaskList
  if type(SubTaskList) ~= "table" then
    return
  end
  for SubTaskIndex, SubTaskInfo in ipairs(SubTaskList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ItemName = SubTaskInfo.ItemName
    Content.SubTaskId = SubTaskInfo.Id or SubTaskInfo.SubTaskId
    Content.Id = SubTaskInfo.ItemId or SubTaskInfo.Id
    Content.ItemId = SubTaskInfo.ItemId or SubTaskInfo.Id
    Content.ItemType = SubTaskInfo.ItemType
    Content.ItemIdList = SubTaskInfo.ItemIdList
    Content.Icon = SubTaskInfo.Icon
    Content.Rarity = SubTaskInfo.Rarity
    Content.IsShowDetails = SubTaskInfo.IsShowDetails
    Content.ScoreValue = SubTaskInfo.ScoreValue
    Content.ScoreIcon = not SubTaskInfo.ScoreIcon and self.Content and self.Content.ScoreIcon
    Content.ButtonState = SubTaskInfo.ButtonState
    Content.CanJump = SubTaskInfo.CanJump
    Content.IsGot = SubTaskInfo.IsGot
    Content.JumpLink = SubTaskInfo.JumpLink
    Content.OwnerUIName = self.Content and self.Content.OwnerPopup and self.Content.OwnerPopup.UIName
    Content.OwnerPopup = self.Content and self.Content.OwnerPopup
    Content.OwnerPopupItem = self
    Content.OwnerTaskTypeIndex = self.Content and self.Content.TaskTypeIndex
    Content.SubTaskIndex = SubTaskIndex
    Content.ActionText = SubTaskInfo.ActionText
    Content.GetText = SubTaskInfo.GetText
    Content.NotDoneText = SubTaskInfo.NotDoneText
    Content.GotText = SubTaskInfo.GotText
    self.List_SubItem:AddItem(Content)
  end
end

return M
