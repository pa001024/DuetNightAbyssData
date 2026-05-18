require("UnLua")
local UIUtils = require("Utils.UIUtils")
local SkinCollectTaskPopupModel = require("BluePrints.UI.WBP.Activity.Widget.SkinCollect.SkinCollectTaskPopupModel")
local M = Class("BluePrints.UI.BP_UIState_C")
local TASK_TYPE_SCROLL_ARROW_TIMER = "SkinCollectTaskTypeScrollArrow"
local TASK_TYPE_SCROLL_ARROW_DELAY = 0.2
local TASK_TYPE_SCROLL_ARROW_RETRY_MAX = 3
local POPUP_SET_FOCUS_TIMER = "SkinCollectTaskPopupSetFocus"
local TASK_TYPE_ENTER_INITIAL_DELAY = 0.02
local TASK_TYPE_ENTER_STEP_DELAY = 0.05
local TASK_TYPE_SCROLL_ENTER_DELAY = 0.02
local TASK_TYPE_ENTER_BATCH_TIMER = "SkinCollectTaskTypeEnterBatch"
local TASK_TYPE_VISIBLE_ENTER_TIMER = "SkinCollectTaskTypeVisibleEnter"
local TASK_TYPE_VISIBLE_ENTER_DELAY = 0.03
local TASK_TYPE_SCROLL_OFFSET_EPSILON = 0.1
local TASK_POPUP_RESTORE_VIEW_STATE_TIMER = "SkinCollectTaskPopupRestoreViewState"
local TASK_POPUP_RESTORE_VIEW_STATE_DELAY = 0.05
local TASK_POPUP_RESTORE_VIEW_STATE_RETRY_MAX = 10
local GAMEPAD_APPLY_FOCUS_TIMER = "SkinCollectTaskGamepadApplyFocus"
local GAMEPAD_INIT_FOCUS_TIMER = "SkinCollectTaskGamepadInitFocus"
local GAMEPAD_FOCUS_TASK_TYPE = "TaskType"
local GAMEPAD_FOCUS_SUB_TASK = "SubTask"
local GAMEPAD_APPLY_FOCUS_DELAY = 0.05
local GAMEPAD_APPLY_FOCUS_RETRY_MAX = 12
local GAMEPAD_ANALOG_DEAD_ZONE = 0.5
local GAMEPAD_ANALOG_DIRECTION_EPSILON = 0.16
local GAMEPAD_ANALOG_AXIS_DOMINANCE_MARGIN = 0.18
local GAMEPAD_ANALOG_REPEAT_TIME = 0.25
local GAMEPAD_ANALOG_NATIVE_FOCUS_SUPPRESS_DELAY = 0.25

local function GetCloseButton(Widget)
  if Widget and Widget.Btn_Close and Widget.Btn_Close.OnClicked then
    return Widget.Btn_Close
  end
  if Widget and Widget.Btn_Close and Widget.Btn_Close.btn_close and Widget.Btn_Close.btn_close.OnClicked then
    return Widget.Btn_Close.btn_close
  end
end

local function StopUINavigation(Widget)
  if not Widget or not Widget.SetNavigationRuleBase then
    return
  end
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
end

local function BuildCloseKeyTipsInfo(OwnerWidget)
  return {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = OwnerWidget.OnCloseClicked,
          Owner = OwnerWidget
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = OwnerWidget.OnCloseClicked,
          Owner = OwnerWidget
        }
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
end

local function BuildTaskTypeKeyTipsInfo(OwnerWidget)
  return {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Enter",
          ClickCallback = OwnerWidget.OnGamepadConfirm,
          Owner = OwnerWidget
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          ClickCallback = OwnerWidget.OnGamepadConfirm,
          Owner = OwnerWidget
        }
      },
      Desc = GText("UI_Tips_Ensure"),
      bLongPress = false
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = OwnerWidget.OnCloseClicked,
          Owner = OwnerWidget
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = OwnerWidget.OnCloseClicked,
          Owner = OwnerWidget
        }
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
end

local function BuildSubTaskKeyTipsInfo(OwnerWidget)
  return {
    {
      KeyInfoList = {},
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.LeftThumb,
          ClickCallback = OwnerWidget.HandleGamepadItemTips,
          Owner = OwnerWidget
        }
      },
      Desc = GText("UI_Controller_CheckDetails"),
      bLongPress = false
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = OwnerWidget.OnCloseClicked,
          Owner = OwnerWidget
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = OwnerWidget.OnCloseClicked,
          Owner = OwnerWidget
        }
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
end

local function NormalizeKeyTipsInfo(KeyTipsInfo)
  local Result = {}
  local bUseGamepadInfo = UIUtils.IsGamepadInput()
  for _, KeyInfo in ipairs(KeyTipsInfo or {}) do
    local KeyInfoList = bUseGamepadInfo and KeyInfo.GamePadInfoList or KeyInfo.KeyInfoList
    if (not KeyInfoList or #KeyInfoList <= 0) and KeyInfo.KeyInfoList and #KeyInfo.KeyInfoList > 0 then
      KeyInfoList = KeyInfo.KeyInfoList
    end
    if KeyInfoList and #KeyInfoList > 0 then
      Result[#Result + 1] = {
        KeyInfoList = KeyInfoList,
        Desc = KeyInfo.Desc,
        Type = KeyInfo.Type,
        bLongPress = KeyInfo.bLongPress
      }
    end
  end
  return Result
end

local function IsLeftStickDigitalKey(InKeyName)
  return InKeyName == UIConst.GamePadKey.LeftStickRight or InKeyName == UIConst.GamePadKey.LeftStickLeft or InKeyName == UIConst.GamePadKey.LeftStickDown or InKeyName == UIConst.GamePadKey.LeftStickUp
end

local function IsDPadKey(InKeyName)
  return InKeyName == UIConst.GamePadKey.DPadRight or InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.DPadUp
end

local function GetAnalogDirection(AnalogValue)
  if AnalogValue > GAMEPAD_ANALOG_DIRECTION_EPSILON then
    return 1
  elseif AnalogValue < -GAMEPAD_ANALOG_DIRECTION_EPSILON then
    return -1
  end
  return 0
end

local function GetGamepadAnalogTime(Widget)
  return UE4.UGameplayStatics.GetRealTimeSeconds(Widget)
end

local function NormalizeEventId(EventId)
  if nil == EventId then
    return nil
  end
  return tonumber(EventId) or EventId
end

local function ApplyFillSlot(Slot)
  if not Slot then
    return
  end
  if Slot.SetHorizontalAlignment then
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  end
  if Slot.SetVerticalAlignment then
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  end
end

local function AddWidgetToAnchor(Anchor, Widget)
  if not Anchor or not Widget then
    return nil
  end
  if Anchor.AddChildToOverlay then
    return Anchor:AddChildToOverlay(Widget)
  end
  if Anchor.AddChild then
    Anchor:AddChild(Widget)
    return Widget.Slot
  end
  return nil
end

local function GetFontBGAnchor(Widget)
  return Widget and (Widget.FontBGAnchor or Widget.FrontBGAnchor) or nil
end

function M:RefreshTitle()
  local PopupTitle = self.WBP_Activity_SkinCollect_Task_PopupTitle
  if PopupTitle and PopupTitle.Text_Title then
    PopupTitle.Text_Title:SetText(GText("UI_AppearanceCollect_AppearanceCollectTask"))
  end
end

function M:RefreshUIBGByActivityId(EventId)
  local ActivityId = NormalizeEventId(EventId)
  if nil == ActivityId then
    return
  end
  local ActivityConfigData = DataMgr.EventMain and DataMgr.EventMain[ActivityId]
  local BgPath = ActivityConfigData and ActivityConfigData.EventBgBPPathPC
  self:RefreshAnchorWidgetByPath(self.BGAnchor, BgPath, "CurrentSkinCollectBgWidget", "CurrentSkinCollectBgPath", ActivityConfigData, ActivityId)
end

function M:RefreshFontBGByActivityId(EventId)
  local ActivityId = NormalizeEventId(EventId)
  if nil == ActivityId then
    return
  end
  local RewardConfigData = DataMgr.AppearanceCollectReward and DataMgr.AppearanceCollectReward[ActivityId]
  local BgPath = RewardConfigData and RewardConfigData.BGPath
  self:RefreshAnchorWidgetByPath(GetFontBGAnchor(self), BgPath, "CurrentSkinCollectFontBgWidget", "CurrentSkinCollectFontBgPath", RewardConfigData, ActivityId)
end

function M:RefreshAnchorWidgetByPath(Anchor, BgPath, WidgetCacheKey, PathCacheKey, InitConfigData, ActivityId)
  if nil == BgPath or "" == BgPath then
    self:ClearAnchorWidget(Anchor, WidgetCacheKey, PathCacheKey)
    return
  end
  if self[PathCacheKey] == BgPath and self[WidgetCacheKey] and IsValid(self[WidgetCacheKey]) then
    return
  end
  if not Anchor then
    return
  end
  local BgWidget = UIManager(self):CreateWidget(BgPath)
  if not BgWidget then
    return
  end
  if Anchor.ClearChildren then
    Anchor:ClearChildren()
  end
  local Slot = AddWidgetToAnchor(Anchor, BgWidget)
  ApplyFillSlot(Slot)
  self[WidgetCacheKey] = BgWidget
  self[PathCacheKey] = BgPath
  if Anchor.SetVisibility then
    Anchor:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if BgWidget.InitUI then
    BgWidget:InitUI(InitConfigData, {ActivityId = ActivityId, EventId = ActivityId}, nil, self)
  end
  if BgWidget.Loop then
    BgWidget:PlayAnimation(BgWidget.Loop, 0, 0)
  end
  local bPlayedBgIn = "CurrentSkinCollectBgWidget" == WidgetCacheKey and self:PlaySkinCollectBgAnimation("Bg_In")
  if not bPlayedBgIn and BgWidget.In then
    BgWidget:PlayAnimation(BgWidget.In)
  end
end

function M:ClearAnchorWidget(Anchor, WidgetCacheKey, PathCacheKey)
  if self[WidgetCacheKey] and Anchor and Anchor.ClearChildren then
    Anchor:ClearChildren()
  end
  self[WidgetCacheKey] = nil
  self[PathCacheKey] = nil
end

function M:PlaySkinCollectBgAnimation(AnimationName)
  local BgWidget = self.CurrentSkinCollectBgWidget
  if not (BgWidget and IsValid(BgWidget)) or not BgWidget.PlayAnimation then
    return false
  end
  local Animation = BgWidget[AnimationName]
  if not Animation then
    return false
  end
  BgWidget:PlayAnimation(Animation)
  return true
end

function M:NotifyReturnToActivityEntryIfNeeded()
  local UiMgr = UIManager(self)
  local PreviousUI = UiMgr and UiMgr.GetUnderState and UiMgr:GetUnderState()
  if not (PreviousUI and PreviousUI.GetName) or PreviousUI:GetName() ~= "ActivityMain" then
    return
  end
  EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
end

local function ClearTaskTypeContainer(Container)
  if not Container or not Container.ClearListItems then
    return
  end
  Container:ClearListItems()
end

local function AddTaskTypeItem(OwnerWidget, Container, Content)
  if not (OwnerWidget and Container) or not Container.AddItem then
    return nil
  end
  Container:AddItem(Content)
  return nil
end

local function ApplyTaskTypeInfoToContent(Content, TaskTypeInfo, TaskTypeIndex, OwnerWidget)
  if not Content or not TaskTypeInfo then
    return
  end
  Content.Id = TaskTypeInfo.Id
  Content.TaskId = TaskTypeInfo.Id
  Content.TaskTypeIndex = TaskTypeIndex
  Content.Title = TaskTypeInfo.Title
  Content.IconPath = TaskTypeInfo.IconPath
  Content.ScoreIcon = TaskTypeInfo.ScoreIcon
  Content.CurrentScore = TaskTypeInfo.CurrentScore
  Content.TotalScore = TaskTypeInfo.TotalScore
  Content.Highlight = TaskTypeInfo.Highlight
  Content.SubTaskList = TaskTypeInfo.SubTaskList or {}
  Content.OwnerPopup = OwnerWidget
end

local function ResetTaskTypeScrollOffset(PopupItemList)
  local ScrollPopItem = PopupItemList and PopupItemList.ScrollPopItem
  if ScrollPopItem then
    if ScrollPopItem.ScrollToStart then
      ScrollPopItem:ScrollToStart()
    elseif ScrollPopItem.SetScrollOffset then
      ScrollPopItem:SetScrollOffset(0)
    end
  end
  local ListPopItem = PopupItemList and PopupItemList.List_PopItem
  if not ListPopItem then
    return
  end
  if ListPopItem.ScrollIndexIntoView then
    ListPopItem:ScrollIndexIntoView(0)
    return
  end
  if ListPopItem.NavigateToIndex then
    ListPopItem:NavigateToIndex(0)
  end
end

local function CanBindUserScrolled(Widget)
  return Widget and Widget.OnUserScrolled and Widget.OnUserScrolled.Add and Widget.OnUserScrolled.Remove
end

local function CanBindEntryLifecycle(Widget)
  return Widget and Widget.BP_OnEntryGenerated and Widget.BP_OnEntryGenerated.Add and Widget.BP_OnEntryGenerated.Remove and Widget.BP_OnEntryReleased and Widget.BP_OnEntryReleased.Add and Widget.BP_OnEntryReleased.Remove
end

local function GetTaskTypeArrowScrollWidget(PopupItemList)
  local ScrollPopItem = PopupItemList and PopupItemList.ScrollPopItem
  if ScrollPopItem and ScrollPopItem.GetScrollOffset and ScrollPopItem.GetScrollOffsetOfEnd then
    return ScrollPopItem
  end
  return nil
end

local function GetTaskTypeScrollOffsetInfo(PopupItemList)
  local ScrollWidget = GetTaskTypeArrowScrollWidget(PopupItemList)
  if not ScrollWidget or not ScrollWidget.GetScrollOffset then
    return nil, nil, nil
  end
  local CurrentOffset = ScrollWidget:GetScrollOffset()
  local EndOffset = ScrollWidget.GetScrollOffsetOfEnd and ScrollWidget:GetScrollOffsetOfEnd() or nil
  return ScrollWidget, CurrentOffset, EndOffset
end

local function SetWidgetScrollOffset(Widget, Offset)
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
  if Offset <= TASK_TYPE_SCROLL_OFFSET_EPSILON and Widget.ScrollToStart then
    Widget:ScrollToStart()
    return true
  end
  return false
end

local function SetArrowVisible(ArrowWidget, bVisible)
  if ArrowWidget then
    ArrowWidget:SetVisibility(bVisible and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
  end
end

local function GetTaskTypeStableId(Content)
  return Content and (Content.Id or Content.TaskId)
end

local function GetSubTaskStableId(Content)
  return Content and (Content.SubTaskId or Content.Id or Content.ItemId)
end

local function GetWidgetCount(WidgetArray)
  if not WidgetArray then
    return 0
  end
  if WidgetArray.ToTable then
    return #WidgetArray:ToTable()
  end
  if type(WidgetArray) == "table" then
    return #WidgetArray
  end
  return 0
end

local function GetWidgetArrayTable(WidgetArray)
  if not WidgetArray then
    return {}
  end
  if WidgetArray.ToTable then
    return WidgetArray:ToTable()
  end
  if type(WidgetArray) == "table" then
    return WidgetArray
  end
  return {}
end

local function GetWidgetAbsoluteRect(Widget)
  if not Widget or not Widget.GetCachedGeometry then
    return nil
  end
  local Geometry = Widget:GetCachedGeometry()
  local Position = UE4.USlateBlueprintLibrary.LocalToAbsolute(Geometry, FVector2D(0, 0))
  local Size = UE4.USlateBlueprintLibrary.GetAbsoluteSize(Geometry)
  if not (Position and Size) or Size.X <= 0 or Size.Y <= 0 then
    return nil
  end
  return {
    Left = Position.X,
    Right = Position.X + Size.X,
    Top = Position.Y,
    Bottom = Position.Y + Size.Y
  }
end

local function IsHorizontalRectIntersected(RectA, RectB)
  if not RectA or not RectB then
    return false
  end
  return RectA.Right > RectB.Left and RectA.Left < RectB.Right
end

function M:OnLoaded(EventId)
  self.bIsFocusable = true
  self.CurActivityId = NormalizeEventId(EventId)
  self:StopNativeUINavigation()
  self:AddDispatcher(EventID.OnAppearanceCollectEventChanged, self, self.OnAppearanceCollectEventChanged)
  self:BindBtnEvent()
  self:BindTaskTypeScrollEvent()
  self:RefreshTitle()
  self:RefreshUIBGByActivityId(EventId)
  self:RefreshFontBGByActivityId(EventId)
  self:RefreshTaskTypeList(EventId)
  if self.In then
    self:StopAnimation(self.In)
    self:PlayAnimationForward(self.In)
  end
  self:AddTimer(0.1, self.ApplyDefaultFocus, false, 0, POPUP_SET_FOCUS_TIMER, true)
  self:QueueApplyDefaultFocus(0.12)
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if 1 ~= StackAction then
    return
  end
  local RestoreViewState = self.PendingTaskPopupViewState or self:CaptureTaskPopupViewState()
  local bRefreshedInPlace = self:TickRefreshTaskTypeList(self.CurActivityId)
  if not bRefreshedInPlace then
    self:RefreshTaskTypeList(self.CurActivityId, true)
  end
  if RestoreViewState then
    self:QueueRestoreTaskPopupViewState(RestoreViewState, TASK_POPUP_RESTORE_VIEW_STATE_DELAY)
  else
    self:QueueApplyDefaultFocus(0.12)
  end
end

function M:StopNativeUINavigation()
  StopUINavigation(self)
  StopUINavigation(GetCloseButton(self))
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  if not PopupItemList then
    return
  end
  StopUINavigation(PopupItemList)
  StopUINavigation(PopupItemList.List_PopItem)
  StopUINavigation(PopupItemList.ScrollPopItem)
end

function M:OnInAnimationFinished()
  M.Super.OnInAnimationFinished(self)
  self:ApplyDefaultFocus()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if UIUtils.IsMobileInput() or CurInputType == ECommonInputType.Touch then
    if self.Com_KeyTips then
      self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:ClearGamepadFocus()
    return
  end
  if CurInputType == ECommonInputType.Gamepad then
    self:InitDefaultGamepadFocus(true)
  else
    self:ClearGamepadFocus()
  end
  self:RefreshBottomKeyTips()
end

function M:OnDestroyed()
  self:RemoveTimer(POPUP_SET_FOCUS_TIMER)
  self:RemoveTimer(GAMEPAD_INIT_FOCUS_TIMER)
  self:RemoveTimer(TASK_TYPE_ENTER_BATCH_TIMER)
  self:RemoveTimer(TASK_TYPE_VISIBLE_ENTER_TIMER)
  self:RemoveTimer(GAMEPAD_APPLY_FOCUS_TIMER)
  self:RemoveTimer(TASK_POPUP_RESTORE_VIEW_STATE_TIMER)
  self:ClearAnchorWidget(self.BGAnchor, "CurrentSkinCollectBgWidget", "CurrentSkinCollectBgPath")
  self:ClearAnchorWidget(GetFontBGAnchor(self), "CurrentSkinCollectFontBgWidget", "CurrentSkinCollectFontBgPath")
  self:ClearGamepadFocus()
  self:ReleaseTaskTypeList()
  self:UnBindTaskTypeScrollEvent()
  self:UnBindBtnEvent()
  self:RemoveDispatcher(EventID.OnAppearanceCollectEventChanged)
  M.Super.OnDestroyed(self)
end

function M:IsCurrentTopState()
  local UiMgr = UIManager(self)
  if UiMgr and UiMgr.GetCurrentState then
    return UiMgr:GetCurrentState() == self
  end
  return true
end

function M:OnAppearanceCollectEventChanged()
  if self.CurActivityId == nil then
    return
  end
  local RestoreViewState = self.PendingTaskPopupViewState or self:CaptureTaskPopupViewState()
  local bRefreshedInPlace = self:TickRefreshTaskTypeList(self.CurActivityId)
  if not bRefreshedInPlace then
    self:RefreshTaskTypeList(self.CurActivityId, true)
  end
  if RestoreViewState then
    if self:IsCurrentTopState() then
      self:QueueRestoreTaskPopupViewState(RestoreViewState, TASK_POPUP_RESTORE_VIEW_STATE_DELAY)
    else
      self.PendingTaskPopupViewState = RestoreViewState
    end
  end
end

function M:BindBtnEvent()
  local CloseButton = GetCloseButton(self)
  if not CloseButton then
    return
  end
  CloseButton.OnClicked:Remove(self, self.OnCloseClicked)
  CloseButton.OnClicked:Add(self, self.OnCloseClicked)
end

function M:UnBindBtnEvent()
  local CloseButton = GetCloseButton(self)
  if not CloseButton then
    return
  end
  CloseButton.OnClicked:Remove(self, self.OnCloseClicked)
end

function M:OnCloseClicked()
  self:Close()
end

function M:Close()
  if self.bClosingWithOutAnim then
    return
  end
  self:PlaySkinCollectBgAnimation("Bg_Out")
  self:NotifyReturnToActivityEntryIfNeeded()
  if self.Out then
    self.bClosingWithOutAnim = true
    self.Auto_Out = self.Out
  end
  self.Super.Close(self)
end

function M:GetTaskTypeListView()
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  return PopupItemList and PopupItemList.List_PopItem
end

function M:GetTaskTypeScrollBox()
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  return PopupItemList and PopupItemList.ScrollPopItem
end

function M:GetTaskTypeCount()
  local ListPopItem = self:GetTaskTypeListView()
  if not ListPopItem or not ListPopItem.GetListItems then
    return 0
  end
  return GetWidgetCount(ListPopItem:GetListItems())
end

function M:GetTaskTypeListContent(Index)
  local ListPopItem = self:GetTaskTypeListView()
  if not ListPopItem or not ListPopItem.GetListItems then
    return nil
  end
  local ListItems = GetWidgetArrayTable(ListPopItem:GetListItems())
  return ListItems[Index]
end

function M:FindTaskTypeIndexById(TaskTypeId)
  if nil == TaskTypeId then
    return nil
  end
  local TargetId = tostring(TaskTypeId)
  for Index = 1, self:GetTaskTypeCount() do
    local Content = self:GetTaskTypeListContent(Index)
    local ContentId = GetTaskTypeStableId(Content)
    if nil ~= ContentId and tostring(ContentId) == TargetId then
      return Index
    end
  end
  return nil
end

function M:GetTaskTypeIndexFromState(TaskTypeId, FallbackIndex)
  local TaskTypeIndex = self:FindTaskTypeIndexById(TaskTypeId)
  if TaskTypeIndex then
    return TaskTypeIndex
  end
  local TaskTypeCount = self:GetTaskTypeCount()
  if type(FallbackIndex) == "number" and TaskTypeCount > 0 then
    return math.clamp(FallbackIndex, 1, TaskTypeCount)
  end
  return nil
end

function M:ApplyTaskTypeScrollOffset(Offset)
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  local ScrollWidget = GetTaskTypeArrowScrollWidget(PopupItemList) or self:GetTaskTypeScrollBox()
  if SetWidgetScrollOffset(ScrollWidget, Offset) then
    self.LastTaskTypeScrollOffset = Offset
    return true
  end
  return false
end

function M:CaptureTaskPopupViewState(FocusSubTaskItem)
  local State = {}
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  local _, TaskTypeScrollOffset = GetTaskTypeScrollOffsetInfo(PopupItemList)
  State.TaskTypeScrollOffset = TaskTypeScrollOffset
  local ExpandedItem = self.CurrentExpandedTaskTypeItem
  local FocusSubTaskContent = IsValid(FocusSubTaskItem) and FocusSubTaskItem.Content or nil
  if IsValid(ExpandedItem) and ExpandedItem.IsDetailExpanded == true and ExpandedItem.Content then
    State.ExpandedTaskTypeId = GetTaskTypeStableId(ExpandedItem.Content)
    State.ExpandedTaskTypeIndex = ExpandedItem.Content.TaskTypeIndex
    if ExpandedItem.GetSubTaskScrollOffset then
      State.ExpandedSubTaskScrollOffset = ExpandedItem:GetSubTaskScrollOffset()
    end
  end
  if FocusSubTaskContent then
    State.GamepadFocusArea = GAMEPAD_FOCUS_SUB_TASK
    State.GamepadFocusTaskTypeIndex = FocusSubTaskContent.OwnerTaskTypeIndex
    State.GamepadFocusSubTaskIndex = FocusSubTaskContent.SubTaskIndex
  else
    State.GamepadFocusArea = self.GamepadFocusArea
    State.GamepadFocusTaskTypeIndex = self.GamepadFocusTaskTypeIndex
    State.GamepadFocusSubTaskIndex = self.GamepadFocusSubTaskIndex
  end
  local FocusTaskContent = self:GetTaskTypeListContent(self.GamepadFocusTaskTypeIndex or 0)
  if FocusSubTaskContent then
    FocusTaskContent = self:GetTaskTypeListContent(State.GamepadFocusTaskTypeIndex or 0)
  end
  State.GamepadFocusTaskTypeId = GetTaskTypeStableId(FocusTaskContent)
  if State.GamepadFocusTaskTypeId == nil and IsValid(self.FocusedTaskTypeItem) and self.FocusedTaskTypeItem.Content then
    State.GamepadFocusTaskTypeId = GetTaskTypeStableId(self.FocusedTaskTypeItem.Content)
  end
  if FocusSubTaskContent then
    State.GamepadFocusSubTaskId = GetSubTaskStableId(FocusSubTaskContent)
  elseif IsValid(self.FocusedSubTaskItem) and self.FocusedSubTaskItem.Content then
    State.GamepadFocusSubTaskId = GetSubTaskStableId(self.FocusedSubTaskItem.Content)
  elseif IsValid(ExpandedItem) and ExpandedItem.Content and type(ExpandedItem.Content.SubTaskList) == "table" then
    local SubTaskInfo = ExpandedItem.Content.SubTaskList[self.GamepadFocusSubTaskIndex or 0]
    State.GamepadFocusSubTaskId = GetSubTaskStableId(SubTaskInfo)
  end
  self.PendingTaskPopupViewState = State
  return State
end

function M:ClearPendingTaskPopupViewState()
  self:RemoveTimer(TASK_POPUP_RESTORE_VIEW_STATE_TIMER)
  self.PendingTaskPopupViewState = nil
  self.TaskPopupViewStateRestoreRetryCount = 0
end

function M:QueueRestoreTaskPopupViewState(ViewState, Delay, RetryCount)
  if ViewState then
    self.PendingTaskPopupViewState = ViewState
  end
  self.TaskPopupViewStateRestoreRetryCount = RetryCount or 0
  local RealDelay = type(Delay) == "number" and Delay or 0
  self:AddTimer(RealDelay, self.RestoreTaskPopupViewState, false, 0, TASK_POPUP_RESTORE_VIEW_STATE_TIMER, true)
end

function M:RetryRestoreTaskPopupViewState(ViewState, RetryCount)
  local NextRetryCount = (RetryCount or 0) + 1
  if NextRetryCount > TASK_POPUP_RESTORE_VIEW_STATE_RETRY_MAX then
    self:ClearPendingTaskPopupViewState()
    return
  end
  self:QueueRestoreTaskPopupViewState(ViewState, TASK_POPUP_RESTORE_VIEW_STATE_DELAY, NextRetryCount)
end

function M:RestoreGamepadFocusFromViewState(State, ExpandedItem)
  if not UIUtils.IsGamepadInput() then
    self:RefreshBottomKeyTips()
    return
  end
  local TaskTypeIndex = self:GetTaskTypeIndexFromState(State.GamepadFocusTaskTypeId, State.GamepadFocusTaskTypeIndex)
  if not TaskTypeIndex then
    self:RefreshBottomKeyTips()
    return
  end
  if State.GamepadFocusArea == GAMEPAD_FOCUS_SUB_TASK then
    local TaskTypeItem = ExpandedItem
    if not (IsValid(TaskTypeItem) and TaskTypeItem.Content) or TaskTypeItem.Content.TaskTypeIndex ~= TaskTypeIndex then
      TaskTypeItem = self:GetTaskTypeEntryByIndex(TaskTypeIndex)
    end
    local SubTaskIndex = State.GamepadFocusSubTaskIndex or 1
    SubTaskIndex = IsValid(TaskTypeItem) and State.GamepadFocusSubTaskId and TaskTypeItem.FindSubTaskIndexById and TaskTypeItem:FindSubTaskIndexById(State.GamepadFocusSubTaskId) or SubTaskIndex
    self:SetGamepadFocusSubTask(TaskTypeIndex, SubTaskIndex, nil, true)
    return
  end
  self:SetGamepadFocusTaskType(TaskTypeIndex, nil, true, false)
end

function M:RestoreTaskPopupViewState()
  self:RemoveTimer(TASK_POPUP_RESTORE_VIEW_STATE_TIMER)
  local State = self.PendingTaskPopupViewState
  if not State then
    return
  end
  local RetryCount = self.TaskPopupViewStateRestoreRetryCount or 0
  if self:GetTaskTypeCount() <= 0 then
    self:RetryRestoreTaskPopupViewState(State, RetryCount)
    return
  end
  self:ApplyTaskTypeScrollOffset(State.TaskTypeScrollOffset)
  local ExpandedItem
  local ExpandedTaskTypeIndex = self:GetTaskTypeIndexFromState(State.ExpandedTaskTypeId, State.ExpandedTaskTypeIndex)
  if ExpandedTaskTypeIndex then
    ExpandedItem = self:GetTaskTypeEntryByIndex(ExpandedTaskTypeIndex)
    if not IsValid(ExpandedItem) then
      if RetryCount >= 3 then
        self:ScrollTaskTypeIntoView(ExpandedTaskTypeIndex)
      end
      self:RetryRestoreTaskPopupViewState(State, RetryCount)
      return
    end
    self.CurrentExpandedTaskTypeItem = ExpandedItem
    if ExpandedItem.IsDetailExpanded ~= true then
      ExpandedItem:SetDetailExpanded(true, true)
    end
    if type(State.ExpandedSubTaskScrollOffset) == "number" and ExpandedItem.SetSubTaskScrollOffset then
      ExpandedItem:SetSubTaskScrollOffset(State.ExpandedSubTaskScrollOffset)
    end
  end
  self:RestoreGamepadFocusFromViewState(State, ExpandedItem)
  if IsValid(ExpandedItem) and type(State.ExpandedSubTaskScrollOffset) == "number" and ExpandedItem.SetSubTaskScrollOffset then
    ExpandedItem:SetSubTaskScrollOffset(State.ExpandedSubTaskScrollOffset)
  end
  self:ApplyTaskTypeScrollOffset(State.TaskTypeScrollOffset)
  self.PendingTaskPopupViewState = nil
  self.TaskPopupViewStateRestoreRetryCount = 0
  self:QueueUpdateTaskTypeScrollArrow(0)
  self:QueueUpdateTaskTypeVisibleEnterAnimation(true, TASK_TYPE_VISIBLE_ENTER_DELAY)
end

function M:GetTaskTypeEntryByIndex(Index)
  for _, TaskTypeItem in ipairs(self:GetDisplayedTaskTypeItems()) do
    if IsValid(TaskTypeItem) and TaskTypeItem.Content and TaskTypeItem.Content.TaskTypeIndex == Index then
      return TaskTypeItem
    end
  end
  return nil
end

function M:IsTaskTypeIndexExpanded(Index)
  local ExpandedItem = self.CurrentExpandedTaskTypeItem
  return IsValid(ExpandedItem) and ExpandedItem.IsDetailExpanded == true and ExpandedItem.Content and ExpandedItem.Content.TaskTypeIndex == Index
end

function M:GetTaskTypeSubTaskCount(Index)
  local TaskTypeItem = self:GetTaskTypeEntryByIndex(Index)
  if IsValid(TaskTypeItem) and TaskTypeItem.GetSubTaskCount then
    local SubTaskCount = TaskTypeItem:GetSubTaskCount()
    if SubTaskCount and SubTaskCount > 0 then
      return SubTaskCount
    end
  end
  local ExpandedItem = self.CurrentExpandedTaskTypeItem
  if IsValid(ExpandedItem) and ExpandedItem.Content and ExpandedItem.Content.TaskTypeIndex == Index and ExpandedItem.GetSubTaskCount then
    local SubTaskCount = ExpandedItem:GetSubTaskCount()
    if SubTaskCount and SubTaskCount > 0 then
      return SubTaskCount
    end
  end
  local Content = self:GetTaskTypeListContent(Index)
  local SubTaskList = Content and Content.SubTaskList
  if type(SubTaskList) == "table" then
    return #SubTaskList
  end
  return 0
end

function M:TaskTypeHasSubTask(Index)
  return self:GetTaskTypeSubTaskCount(Index) > 0
end

function M:GetTaskTypeFocusWidget(TaskTypeItem)
  if not TaskTypeItem then
    return nil
  end
  if TaskTypeItem.GetGamepadFocusWidget then
    return TaskTypeItem:GetGamepadFocusWidget()
  end
  if TaskTypeItem.GetActiveTypeItem then
    return TaskTypeItem:GetActiveTypeItem()
  end
  return TaskTypeItem
end

function M:ScrollTaskTypeIntoView(Index, TargetWidget)
  local ListPopItem = self:GetTaskTypeListView()
  if ListPopItem then
    local ListIndex = math.max((Index or 1) - 1, 0)
    if ListPopItem.ScrollIndexIntoView then
      ListPopItem:ScrollIndexIntoView(ListIndex)
    elseif ListPopItem.NavigateToIndex then
      ListPopItem:NavigateToIndex(ListIndex)
    end
  end
  local ScrollPopItem = self:GetTaskTypeScrollBox()
  local Widget = TargetWidget or self:GetTaskTypeEntryByIndex(Index)
  if not (ScrollPopItem and Widget) or not ScrollPopItem.ScrollWidgetIntoView then
    return
  end
  if UE4.EDescendantScrollDestination then
    ScrollPopItem:ScrollWidgetIntoView(Widget, true, UE4.EDescendantScrollDestination.Center)
  else
    ScrollPopItem:ScrollWidgetIntoView(Widget, true)
  end
end

function M:QueueApplyGamepadFocus(Area, TaskTypeIndex, SubTaskIndex, RetryCount)
  self.PendingGamepadFocus = {
    Area = Area,
    TaskTypeIndex = TaskTypeIndex,
    SubTaskIndex = SubTaskIndex,
    RetryCount = RetryCount or 0
  }
  self:AddTimer(GAMEPAD_APPLY_FOCUS_DELAY, self.ApplyPendingGamepadFocus, false, 0, GAMEPAD_APPLY_FOCUS_TIMER, true)
end

function M:ApplyPendingGamepadFocus()
  self:RemoveTimer(GAMEPAD_APPLY_FOCUS_TIMER)
  local PendingFocus = self.PendingGamepadFocus
  self.PendingGamepadFocus = nil
  if not PendingFocus or PendingFocus.RetryCount > GAMEPAD_APPLY_FOCUS_RETRY_MAX then
    return
  end
  if PendingFocus.Area == GAMEPAD_FOCUS_SUB_TASK then
    self:SetGamepadFocusSubTask(PendingFocus.TaskTypeIndex, PendingFocus.SubTaskIndex, PendingFocus.RetryCount + 1)
  else
    self:SetGamepadFocusTaskType(PendingFocus.TaskTypeIndex, PendingFocus.RetryCount + 1)
  end
end

function M:ClearFocusedTaskTypeItem()
  if self.FocusedTaskTypeItem and IsValid(self.FocusedTaskTypeItem) and self.FocusedTaskTypeItem.SetGamepadFocused then
    self.FocusedTaskTypeItem:SetGamepadFocused(false)
  end
  self.FocusedTaskTypeItem = nil
end

function M:ClearFocusedSubTaskItem()
  if self.FocusedSubTaskItem and IsValid(self.FocusedSubTaskItem) and self.FocusedSubTaskItem.SetGamepadFocused then
    self.FocusedSubTaskItem:SetGamepadFocused(false)
  end
  self.FocusedSubTaskItem = nil
end

function M:ClearGamepadFocus()
  self:RemoveTimer(GAMEPAD_APPLY_FOCUS_TIMER)
  self:RemoveTimer(GAMEPAD_INIT_FOCUS_TIMER)
  self.PendingGamepadFocus = nil
  self.GamepadAnalogState = nil
  self.GamepadAnalogVector = nil
  self.GamepadFocusArea = nil
  self.GamepadFocusTaskTypeIndex = nil
  self.GamepadFocusSubTaskIndex = nil
  self:ClearFocusedTaskTypeItem()
  self:ClearFocusedSubTaskItem()
end

function M:IsGamepadFocusingSubTaskForTaskType(TaskTypeIndex)
  return UIUtils.IsGamepadInput() and self.GamepadFocusArea == GAMEPAD_FOCUS_SUB_TASK and self.GamepadFocusTaskTypeIndex == TaskTypeIndex
end

function M:IsSuppressingNativeTaskTypeFocusSync()
  local AxisState = self.GamepadAnalogState
  if not AxisState or not AxisState.SuppressTaskTypeFocusSyncUntil then
    return false
  end
  return GetGamepadAnalogTime(self) < AxisState.SuppressTaskTypeFocusSyncUntil
end

function M:RefreshBottomKeyTips()
  if not self.Com_KeyTips then
    return
  end
  if UIUtils.IsMobileInput() then
    self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local KeyTipsInfo = BuildCloseKeyTipsInfo(self)
  if UIUtils.IsGamepadInput() then
    if self.GamepadFocusArea == GAMEPAD_FOCUS_SUB_TASK then
      KeyTipsInfo = BuildSubTaskKeyTipsInfo(self)
    else
      KeyTipsInfo = BuildTaskTypeKeyTipsInfo(self)
    end
  end
  local NormalizedKeyTipsInfo = NormalizeKeyTipsInfo(KeyTipsInfo)
  if #NormalizedKeyTipsInfo <= 0 then
    self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.Com_KeyTips:UpdateKeyInfo(NormalizedKeyTipsInfo)
  self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:ApplyDefaultFocus()
  if UIUtils.IsGamepadInput() then
    self:InitDefaultGamepadFocus(true)
    return
  end
  if self.SetFocus then
    self:SetFocus()
  end
end

function M:QueueApplyDefaultFocus(Delay)
  local RealDelay = type(Delay) == "number" and Delay or 0
  self:AddTimer(RealDelay, self.ApplyDefaultFocus, false, 0, GAMEPAD_INIT_FOCUS_TIMER, true)
end

function M:InitDefaultGamepadFocus(bForceApply)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.GamepadFocusArea then
    if true == bForceApply then
      if self.GamepadFocusArea == GAMEPAD_FOCUS_SUB_TASK then
        return self:SetGamepadFocusSubTask(self.GamepadFocusTaskTypeIndex or 1, self.GamepadFocusSubTaskIndex or 1)
      end
      return self:SetGamepadFocusTaskType(self.GamepadFocusTaskTypeIndex or 1)
    end
    self:RefreshBottomKeyTips()
    return
  end
  return self:SetGamepadFocusTaskType(1)
end

function M:SetGamepadFocusTaskType(Index, RetryCount, bSkipScroll, bKeepCurrentState)
  if not UIUtils.IsGamepadInput() then
    return false
  end
  local TaskTypeCount = self:GetTaskTypeCount()
  if TaskTypeCount <= 0 then
    return false
  end
  local TargetIndex = math.clamp(Index or 1, 1, TaskTypeCount)
  self.GamepadFocusArea = GAMEPAD_FOCUS_TASK_TYPE
  self.GamepadFocusTaskTypeIndex = TargetIndex
  self.GamepadFocusSubTaskIndex = nil
  local TaskTypeItem = self:GetTaskTypeEntryByIndex(TargetIndex)
  if not IsValid(TaskTypeItem) then
    if not bSkipScroll then
      self:ScrollTaskTypeIntoView(TargetIndex)
    end
    self:QueueApplyGamepadFocus(GAMEPAD_FOCUS_TASK_TYPE, TargetIndex, nil, RetryCount)
    self:RefreshBottomKeyTips()
    return false
  end
  local FocusWidget = self:GetTaskTypeFocusWidget(TaskTypeItem)
  self:ClearFocusedSubTaskItem()
  if self.FocusedTaskTypeItem ~= TaskTypeItem then
    self:ClearFocusedTaskTypeItem()
  end
  self.FocusedTaskTypeItem = TaskTypeItem
  if TaskTypeItem.SetGamepadFocused then
    TaskTypeItem:SetGamepadFocused(true, bKeepCurrentState)
  end
  if not bSkipScroll then
    self:ScrollTaskTypeIntoView(TargetIndex, FocusWidget or TaskTypeItem)
  end
  self.bApplyingGamepadFocus = true
  if FocusWidget and FocusWidget.SetFocus then
    FocusWidget:SetFocus()
  elseif TaskTypeItem.SetFocus then
    TaskTypeItem:SetFocus()
  end
  self.bApplyingGamepadFocus = false
  self:RefreshBottomKeyTips()
  return true
end

function M:SetGamepadFocusSubTask(TaskTypeIndex, SubTaskIndex, RetryCount, bSkipScroll)
  if not UIUtils.IsGamepadInput() then
    return false
  end
  local TargetTaskTypeIndex = math.clamp(TaskTypeIndex or 1, 1, math.max(self:GetTaskTypeCount(), 1))
  if not self:IsTaskTypeIndexExpanded(TargetTaskTypeIndex) or not self:TaskTypeHasSubTask(TargetTaskTypeIndex) then
    return self:SetGamepadFocusTaskType(TargetTaskTypeIndex, RetryCount)
  end
  local TargetSubTaskIndex = math.max(SubTaskIndex or 1, 1)
  local TaskTypeItem = self:GetTaskTypeEntryByIndex(TargetTaskTypeIndex)
  if not IsValid(TaskTypeItem) then
    if not bSkipScroll then
      self:ScrollTaskTypeIntoView(TargetTaskTypeIndex)
    end
    self:QueueApplyGamepadFocus(GAMEPAD_FOCUS_SUB_TASK, TargetTaskTypeIndex, TargetSubTaskIndex, RetryCount)
    self:RefreshBottomKeyTips()
    return false
  end
  local SubTaskCount = TaskTypeItem.GetSubTaskCount and TaskTypeItem:GetSubTaskCount() or 0
  if SubTaskCount <= 0 then
    return self:SetGamepadFocusTaskType(TargetTaskTypeIndex, RetryCount)
  end
  TargetSubTaskIndex = math.clamp(TargetSubTaskIndex, 1, SubTaskCount)
  if not bSkipScroll and TaskTypeItem.ScrollSubTaskIntoView then
    TaskTypeItem:ScrollSubTaskIntoView(TargetSubTaskIndex)
  end
  if not bSkipScroll then
    self:ScrollTaskTypeIntoView(TargetTaskTypeIndex, TaskTypeItem)
  end
  self.GamepadFocusArea = GAMEPAD_FOCUS_SUB_TASK
  self.GamepadFocusTaskTypeIndex = TargetTaskTypeIndex
  self.GamepadFocusSubTaskIndex = TargetSubTaskIndex
  self:ClearFocusedTaskTypeItem()
  self:ClearFocusedSubTaskItem()
  local bFocusSubTaskListSuccess, FocusedSubTaskItem = false
  if TaskTypeItem.FocusSubTaskList then
    self.bApplyingGamepadFocus = true
    bFocusSubTaskListSuccess, FocusedSubTaskItem = TaskTypeItem:FocusSubTaskList(TargetSubTaskIndex, bSkipScroll)
    self.bApplyingGamepadFocus = false
  end
  if not bFocusSubTaskListSuccess then
    if not bSkipScroll then
      self:ScrollTaskTypeIntoView(TargetTaskTypeIndex, TaskTypeItem)
    end
    self:QueueApplyGamepadFocus(GAMEPAD_FOCUS_SUB_TASK, TargetTaskTypeIndex, TargetSubTaskIndex, RetryCount)
    self:RefreshBottomKeyTips()
    return false
  end
  if IsValid(FocusedSubTaskItem) then
    self:OnSubTaskItemGamepadFocusReceived(FocusedSubTaskItem)
  end
  self:RefreshBottomKeyTips()
  return true
end

function M:OnTaskTypeItemGamepadFocusReceived(TaskTypeItem)
  if self.bApplyingGamepadFocus or not UIUtils.IsGamepadInput() then
    return
  end
  if self:IsSuppressingNativeTaskTypeFocusSync() then
    return
  end
  local Index = TaskTypeItem and TaskTypeItem.Content and TaskTypeItem.Content.TaskTypeIndex
  if Index then
    if self.GamepadFocusArea == GAMEPAD_FOCUS_TASK_TYPE and self.GamepadFocusTaskTypeIndex == Index and self.FocusedTaskTypeItem == TaskTypeItem then
      return
    end
    self.LastExternalGamepadFocusTime = GetGamepadAnalogTime(self)
    self:SetGamepadFocusTaskType(Index)
  end
end

function M:OnSubTaskItemGamepadFocusReceived(SubTaskItem)
  if self.bApplyingGamepadFocus or not UIUtils.IsGamepadInput() then
    return
  end
  local Content = SubTaskItem and SubTaskItem.Content
  if Content and Content.OwnerTaskTypeIndex and Content.SubTaskIndex then
    self.LastExternalGamepadFocusTime = GetGamepadAnalogTime(self)
    self.GamepadFocusArea = GAMEPAD_FOCUS_SUB_TASK
    self.GamepadFocusTaskTypeIndex = Content.OwnerTaskTypeIndex
    self.GamepadFocusSubTaskIndex = Content.SubTaskIndex
    self:ClearFocusedTaskTypeItem()
    if self.FocusedSubTaskItem ~= SubTaskItem then
      self:ClearFocusedSubTaskItem()
    end
    self.FocusedSubTaskItem = SubTaskItem
    if SubTaskItem.SetGamepadFocused then
      SubTaskItem:SetGamepadFocused(true)
    end
    self:RefreshBottomKeyTips()
  end
end

function M:GetCurrentSubTaskItem()
  if self.FocusedSubTaskItem and IsValid(self.FocusedSubTaskItem) then
    return self.FocusedSubTaskItem
  end
  local TaskTypeItem = self:GetTaskTypeEntryByIndex(self.GamepadFocusTaskTypeIndex or 1)
  if TaskTypeItem and TaskTypeItem.GetSubTaskEntryByIndex then
    return TaskTypeItem:GetSubTaskEntryByIndex(self.GamepadFocusSubTaskIndex or 1)
  end
  return nil
end

function M:MoveGamepadHorizontal(Direction)
  self:InitDefaultGamepadFocus()
  local TaskTypeCount = self:GetTaskTypeCount()
  if TaskTypeCount <= 0 then
    return false
  end
  local CurrentIndex = self.GamepadFocusTaskTypeIndex or 1
  if self.GamepadFocusArea == GAMEPAD_FOCUS_SUB_TASK then
    if Direction > 0 then
      if TaskTypeCount <= CurrentIndex then
        return false
      end
      return self:SetGamepadFocusTaskType(CurrentIndex + 1)
    end
    return self:SetGamepadFocusTaskType(CurrentIndex)
  end
  if Direction > 0 then
    if self:IsTaskTypeIndexExpanded(CurrentIndex) and self:TaskTypeHasSubTask(CurrentIndex) then
      return self:SetGamepadFocusSubTask(CurrentIndex, 1)
    end
    if TaskTypeCount <= CurrentIndex then
      return false
    end
    return self:SetGamepadFocusTaskType(CurrentIndex + 1)
  end
  if CurrentIndex <= 1 then
    return false
  end
  local PrevIndex = CurrentIndex - 1
  if self:IsTaskTypeIndexExpanded(PrevIndex) and self:TaskTypeHasSubTask(PrevIndex) then
    return self:SetGamepadFocusSubTask(PrevIndex, 1)
  end
  return self:SetGamepadFocusTaskType(PrevIndex)
end

function M:MoveGamepadVertical(Direction)
  if self.GamepadFocusArea ~= GAMEPAD_FOCUS_SUB_TASK then
    return false
  end
  local TaskTypeItem = self:GetTaskTypeEntryByIndex(self.GamepadFocusTaskTypeIndex or 1)
  local SubTaskCount = TaskTypeItem and TaskTypeItem.GetSubTaskCount and TaskTypeItem:GetSubTaskCount() or 0
  if SubTaskCount <= 0 then
    return false
  end
  local TargetSubTaskIndex = math.clamp((self.GamepadFocusSubTaskIndex or 1) + Direction, 1, SubTaskCount)
  if TargetSubTaskIndex == self.GamepadFocusSubTaskIndex then
    return false
  end
  return self:SetGamepadFocusSubTask(self.GamepadFocusTaskTypeIndex, TargetSubTaskIndex)
end

function M:MoveByGamepadAnalogAxis(AxisName, Direction)
  if "X" == AxisName then
    return self:MoveGamepadHorizontal(Direction)
  end
  return self:MoveGamepadVertical(Direction > 0 and -1 or 1)
end

function M:GetGamepadAnalogMoveIntent()
  local AnalogVector = self.GamepadAnalogVector or {}
  local AnalogX = AnalogVector.X or 0
  local AnalogY = AnalogVector.Y or 0
  local AbsX = math.abs(AnalogX)
  local AbsY = math.abs(AnalogY)
  local DirectionX = GetAnalogDirection(AnalogX)
  local DirectionY = GetAnalogDirection(AnalogY)
  if 0 == DirectionX and 0 == DirectionY then
    return nil, 0, 0
  end
  if self.GamepadFocusArea == GAMEPAD_FOCUS_SUB_TASK then
    if 0 ~= DirectionY and AbsX <= AbsY + GAMEPAD_ANALOG_AXIS_DOMINANCE_MARGIN then
      return "Y", DirectionY, AbsY
    end
    if 0 ~= DirectionX then
      return "X", DirectionX, AbsX
    end
    return "Y", DirectionY, AbsY
  end
  if 0 ~= DirectionX then
    return "X", DirectionX, AbsX
  end
  return nil, 0, 0
end

function M:OnGamepadConfirm()
  return self:HandleGamepadConfirm()
end

function M:HandleGamepadConfirm()
  if self.GamepadFocusArea == GAMEPAD_FOCUS_SUB_TASK then
    local SubTaskItem = self:GetCurrentSubTaskItem()
    if SubTaskItem and SubTaskItem.OnGamepadConfirm then
      return SubTaskItem:OnGamepadConfirm()
    end
    return false
  end
  local TaskTypeItem = self:GetTaskTypeEntryByIndex(self.GamepadFocusTaskTypeIndex or 1)
  if TaskTypeItem then
    self:OnTaskTypeItemClicked(TaskTypeItem)
    return true
  end
  return false
end

function M:HandleGamepadQa()
  local SubTaskItem = self:GetCurrentSubTaskItem()
  if SubTaskItem and SubTaskItem.ToggleQaTips then
    return SubTaskItem:ToggleQaTips()
  end
  return false
end

function M:HandleGamepadItemTips()
  if self.GamepadFocusArea ~= GAMEPAD_FOCUS_SUB_TASK then
    return false
  end
  local SubTaskItem = self:GetCurrentSubTaskItem()
  if SubTaskItem and SubTaskItem.OpenItemTipsOrPreview then
    return SubTaskItem:OpenItemTipsOrPreview()
  end
  if SubTaskItem and SubTaskItem.OpenItemTips then
    return SubTaskItem:OpenItemTips()
  end
  return false
end

function M:CloseCurrentSubTaskQaTips()
  local SubTaskItem = self:GetCurrentSubTaskItem()
  if SubTaskItem and SubTaskItem.CloseQaTips then
    return SubTaskItem:CloseQaTips()
  end
  return false
end

function M:HandleGamepadKeyDown(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self:CloseCurrentSubTaskQaTips() then
      return true
    end
    self:Close()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:HandleGamepadConfirm()
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    self:MoveGamepadHorizontal(1)
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadLeft then
    self:MoveGamepadHorizontal(-1)
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadDown then
    self:MoveGamepadVertical(1)
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadUp then
    self:MoveGamepadVertical(-1)
    return true
  elseif IsLeftStickDigitalKey(InKeyName) then
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    self:HandleGamepadItemTips()
    return true
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self:HandleGamepadQa()
    return true
  end
  return false
end

function M:HandleGamepadAnalogAxis(AxisName, AnalogValue)
  self.GamepadAnalogVector = self.GamepadAnalogVector or {}
  self.GamepadAnalogVector[AxisName] = AnalogValue or 0
  self.GamepadAnalogState = self.GamepadAnalogState or {}
  local AxisState = self.GamepadAnalogState
  local MoveAxisName, Direction, AxisAbs = self:GetGamepadAnalogMoveIntent()
  local NowTime = GetGamepadAnalogTime(self)
  if not MoveAxisName or 0 == Direction then
    AxisState.AxisName = nil
    AxisState.Direction = nil
    AxisState.NextRepeatTime = nil
    AxisState.SuppressTaskTypeFocusSyncUntil = nil
    return true
  end
  if "X" == MoveAxisName then
    AxisState.SuppressTaskTypeFocusSyncUntil = NowTime + GAMEPAD_ANALOG_NATIVE_FOCUS_SUPPRESS_DELAY
  end
  if AxisName ~= MoveAxisName then
    return true
  end
  local bInDeadZone = AxisAbs < GAMEPAD_ANALOG_DEAD_ZONE
  if AxisState.AxisName ~= MoveAxisName or AxisState.Direction ~= Direction then
    AxisState.AxisName = MoveAxisName
    AxisState.Direction = Direction
    if bInDeadZone then
    end
    AxisState.NextRepeatTime = NowTime + GAMEPAD_ANALOG_REPEAT_TIME
    AxisState.LastMoveTime = NowTime
    self:MoveByGamepadAnalogAxis(MoveAxisName, Direction)
    return true
  end
  if bInDeadZone then
    AxisState.NextRepeatTime = nil
    return true
  end
  AxisState.NextRepeatTime = AxisState.NextRepeatTime or NowTime + GAMEPAD_ANALOG_REPEAT_TIME
  if AxisState.NextRepeatTime and NowTime >= AxisState.NextRepeatTime then
    AxisState.NextRepeatTime = NowTime + GAMEPAD_ANALOG_REPEAT_TIME
    AxisState.LastMoveTime = NowTime
    self:MoveByGamepadAnalogAxis(MoveAxisName, Direction)
  end
  return true
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if IsDPadKey(InKeyName) then
    self:HandleGamepadKeyDown(InKeyName)
    return UIUtils.Handled
  end
  if IsLeftStickDigitalKey(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName then
    self:Close()
    return UIUtils.Handled
  end
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleGamepadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.LeftAnalogX then
    local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    self:HandleGamepadAnalogAxis("X", AnalogValue)
    return UIUtils.Handled
  elseif InKeyName == UIConst.GamePadKey.LeftAnalogY then
    local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    self:HandleGamepadAnalogAxis("Y", AnalogValue)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:BindTaskTypeScrollEvent()
  self:UnBindTaskTypeScrollEvent()
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  if not PopupItemList then
    return
  end
  self.TaskTypeScrollWidgets = {}
  self.TaskTypeEntryLifecycleWidgets = {}
  
  local function BindScrollWidget(Widget)
    if not CanBindUserScrolled(Widget) then
      return
    end
    Widget.OnUserScrolled:Remove(self, self.OnTaskTypeListScrolled)
    Widget.OnUserScrolled:Add(self, self.OnTaskTypeListScrolled)
    table.insert(self.TaskTypeScrollWidgets, Widget)
  end
  
  local function BindEntryLifecycle(Widget)
    if not CanBindEntryLifecycle(Widget) then
      return
    end
    Widget.BP_OnEntryGenerated:Remove(self, self.OnTaskTypeListEntryGenerated)
    Widget.BP_OnEntryGenerated:Add(self, self.OnTaskTypeListEntryGenerated)
    Widget.BP_OnEntryReleased:Remove(self, self.OnTaskTypeListEntryReleased)
    Widget.BP_OnEntryReleased:Add(self, self.OnTaskTypeListEntryReleased)
    table.insert(self.TaskTypeEntryLifecycleWidgets, Widget)
  end
  
  local ScrollPopItem = GetTaskTypeArrowScrollWidget(PopupItemList)
  local ListPopItem = PopupItemList.List_PopItem
  BindScrollWidget(ScrollPopItem)
  if not ScrollPopItem then
    BindScrollWidget(ListPopItem)
  end
  BindEntryLifecycle(ListPopItem)
end

function M:UnBindTaskTypeScrollEvent()
  if self.TaskTypeScrollWidgets then
    for _, Widget in ipairs(self.TaskTypeScrollWidgets) do
      if CanBindUserScrolled(Widget) then
        Widget.OnUserScrolled:Remove(self, self.OnTaskTypeListScrolled)
      end
    end
    self.TaskTypeScrollWidgets = nil
  end
  if self.TaskTypeEntryLifecycleWidgets then
    for _, Widget in ipairs(self.TaskTypeEntryLifecycleWidgets) do
      if CanBindEntryLifecycle(Widget) then
        Widget.BP_OnEntryGenerated:Remove(self, self.OnTaskTypeListEntryGenerated)
        Widget.BP_OnEntryReleased:Remove(self, self.OnTaskTypeListEntryReleased)
      end
    end
    self.TaskTypeEntryLifecycleWidgets = nil
  end
end

function M:QueueUpdateTaskTypeScrollArrow(Delay, RetryCount)
  local RealDelay = Delay
  if type(RealDelay) ~= "number" then
    RealDelay = TASK_TYPE_SCROLL_ARROW_DELAY
  end
  self.TaskTypeScrollArrowRetryCount = RetryCount or 0
  self:AddTimer(RealDelay, self.UpdateTaskTypeScrollArrow, false, 0, TASK_TYPE_SCROLL_ARROW_TIMER, true)
end

function M:UpdateTaskTypeScrollArrow()
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  local ArrowScrollWidget = GetTaskTypeArrowScrollWidget(PopupItemList)
  if ArrowScrollWidget then
    local CurrentOffset = ArrowScrollWidget:GetScrollOffset()
    local EndOffset = ArrowScrollWidget:GetScrollOffsetOfEnd()
    if type(CurrentOffset) ~= "number" or type(EndOffset) ~= "number" or EndOffset <= TASK_TYPE_SCROLL_OFFSET_EPSILON then
      SetWidgetScrollOffset(ArrowScrollWidget, 0)
      SetArrowVisible(self.List_ArrowTop, false)
      SetArrowVisible(self.List_ArrowBottom, false)
      return
    end
    if CurrentOffset > EndOffset then
      SetWidgetScrollOffset(ArrowScrollWidget, EndOffset)
      CurrentOffset = EndOffset
    elseif CurrentOffset <= TASK_TYPE_SCROLL_OFFSET_EPSILON then
      SetWidgetScrollOffset(ArrowScrollWidget, 0)
      CurrentOffset = 0
    end
    SetArrowVisible(self.List_ArrowTop, CurrentOffset > TASK_TYPE_SCROLL_OFFSET_EPSILON)
    SetArrowVisible(self.List_ArrowBottom, EndOffset - CurrentOffset > TASK_TYPE_SCROLL_OFFSET_EPSILON)
    return
  end
  local ListPopItem = PopupItemList and PopupItemList.List_PopItem
  if not ListPopItem then
    SetArrowVisible(self.List_ArrowTop, false)
    SetArrowVisible(self.List_ArrowBottom, false)
    return
  end
  local ListItemCount = ListPopItem.GetListItems and GetWidgetCount(ListPopItem:GetListItems()) or 0
  local DisplayedWidgetCount = ListPopItem.GetDisplayedEntryWidgets and GetWidgetCount(ListPopItem:GetDisplayedEntryWidgets()) or 0
  if ListItemCount > 0 and 0 == DisplayedWidgetCount then
    local RetryCount = self.TaskTypeScrollArrowRetryCount or 0
    if RetryCount < TASK_TYPE_SCROLL_ARROW_RETRY_MAX then
      self:QueueUpdateTaskTypeScrollArrow(TASK_TYPE_SCROLL_ARROW_DELAY, RetryCount + 1)
      return
    end
  end
  self.TaskTypeScrollArrowRetryCount = 0
  UIUtils.UpdateListArrow(ListPopItem, self.List_ArrowTop, self.List_ArrowBottom)
end

function M:OnTaskTypeListScrolled()
  self:UpdateTaskTypeScrollArrow()
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  local _, CurrentOffset, EndOffset = GetTaskTypeScrollOffsetInfo(PopupItemList)
  if type(CurrentOffset) == "number" then
    local LastOffset = self.LastTaskTypeScrollOffset
    self.LastTaskTypeScrollOffset = CurrentOffset
    if type(LastOffset) == "number" then
      local OffsetDelta = math.abs(CurrentOffset - LastOffset)
      if OffsetDelta <= TASK_TYPE_SCROLL_OFFSET_EPSILON then
        return
      end
      if CurrentOffset <= TASK_TYPE_SCROLL_OFFSET_EPSILON and LastOffset <= TASK_TYPE_SCROLL_OFFSET_EPSILON then
        return
      end
      if type(EndOffset) == "number" and CurrentOffset >= EndOffset - TASK_TYPE_SCROLL_OFFSET_EPSILON and LastOffset >= EndOffset - TASK_TYPE_SCROLL_OFFSET_EPSILON then
        return
      end
    end
  end
  self:QueueUpdateTaskTypeVisibleEnterAnimation(true, TASK_TYPE_VISIBLE_ENTER_DELAY)
end

function M:OnTaskTypeListEntryGenerated(TaskTypeItem)
  self:QueueUpdateTaskTypeVisibleEnterAnimation(false, 0)
  self:QueueUpdateTaskTypeScrollArrow()
end

function M:OnTaskTypeListEntryReleased()
  self:QueueUpdateTaskTypeVisibleEnterAnimation(false, 0)
  self:QueueUpdateTaskTypeScrollArrow()
end

function M:RefreshTaskTypeList(EventId, bSkipDefaultGamepadFocus)
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  if not PopupItemList or not PopupItemList.List_PopItem then
    return
  end
  local DisplayTaskTypeList = SkinCollectTaskPopupModel.GetTaskTypeListByEventId(EventId)
  self.CurrentExpandedTaskTypeItem = nil
  self.bTaskTypeVisibleStateInitialized = false
  self.TaskTypeVisibleStateMap = {}
  self.bPendingTaskTypeVisibleEnterAnimation = false
  self.bTaskTypeVisibleEnterTimerPending = false
  self.LastTaskTypeScrollOffset = nil
  self:BeginTaskTypeEnterBatch(#DisplayTaskTypeList)
  PopupItemList.List_PopItem:SetVisibility(UE4.ESlateVisibility.Visible)
  self:StopNativeUINavigation()
  ClearTaskTypeContainer(PopupItemList.List_PopItem)
  for TaskTypeIndex, TaskTypeInfo in ipairs(DisplayTaskTypeList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    ApplyTaskTypeInfoToContent(Content, TaskTypeInfo, TaskTypeIndex, self)
    AddTaskTypeItem(self, PopupItemList.List_PopItem, Content)
  end
  ResetTaskTypeScrollOffset(PopupItemList)
  self:UpdateTaskTypeScrollArrow()
  self:QueueUpdateTaskTypeScrollArrow(0.3)
  self:ClearGamepadFocus()
  if not bSkipDefaultGamepadFocus then
    self:InitDefaultGamepadFocus()
  end
end

function M:TickRefreshTaskTypeList(EventId)
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  local ListPopItem = PopupItemList and PopupItemList.List_PopItem
  if not ListPopItem or not ListPopItem.GetListItems then
    return false
  end
  local DisplayTaskTypeList = SkinCollectTaskPopupModel.GetTaskTypeListByEventId(EventId)
  local ContentList = GetWidgetArrayTable(ListPopItem:GetListItems())
  if #ContentList ~= #DisplayTaskTypeList then
    return false
  end
  for TaskTypeIndex, TaskTypeInfo in ipairs(DisplayTaskTypeList) do
    local ContentStableId = GetTaskTypeStableId(ContentList[TaskTypeIndex])
    local DisplayStableId = GetTaskTypeStableId(TaskTypeInfo)
    if nil == ContentStableId or nil == DisplayStableId or tostring(ContentStableId) ~= tostring(DisplayStableId) then
      return false
    end
  end
  local TaskTypeInfoMap = {}
  for _, TaskTypeInfo in ipairs(DisplayTaskTypeList) do
    local StableId = GetTaskTypeStableId(TaskTypeInfo)
    if nil ~= StableId then
      TaskTypeInfoMap[tostring(StableId)] = TaskTypeInfo
    end
  end
  for TaskTypeIndex, Content in ipairs(ContentList) do
    local StableId = GetTaskTypeStableId(Content)
    local TaskTypeInfo = nil ~= StableId and TaskTypeInfoMap[tostring(StableId)] or nil
    if not TaskTypeInfo then
      return false
    end
    ApplyTaskTypeInfoToContent(Content, TaskTypeInfo, TaskTypeIndex, self)
  end
  for _, TaskTypeItem in ipairs(self:GetDisplayedTaskTypeItems()) do
    if IsValid(TaskTypeItem) then
      if TaskTypeItem.RefreshViewKeepState then
        TaskTypeItem:RefreshViewKeepState()
      elseif TaskTypeItem.RefreshView then
        TaskTypeItem:RefreshView()
      end
    end
  end
  self:UpdateTaskTypeScrollArrow()
  self:QueueUpdateTaskTypeScrollArrow(0.3)
  self:QueueUpdateTaskTypeVisibleEnterAnimation(false, 0)
  return true
end

function M:ReleaseTaskTypeList()
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  if not PopupItemList or not PopupItemList.List_PopItem then
    return
  end
  self:ClearGamepadFocus()
  ClearTaskTypeContainer(PopupItemList.List_PopItem)
  self.CurrentExpandedTaskTypeItem = nil
  self.bTaskTypeVisibleStateInitialized = false
  self.TaskTypeVisibleStateMap = {}
  self.LastTaskTypeScrollOffset = nil
  self:RemoveTimer(TASK_TYPE_VISIBLE_ENTER_TIMER)
  self.bPendingTaskTypeVisibleEnterAnimation = false
  self.bTaskTypeVisibleEnterTimerPending = false
  self:UpdateTaskTypeScrollArrow()
end

function M:OnTaskTypeItemClicked(TaskTypeItem)
  if not TaskTypeItem then
    return
  end
  if self.CurrentExpandedTaskTypeItem == TaskTypeItem then
    local ShouldExpand = not TaskTypeItem.IsDetailExpanded
    TaskTypeItem:SetDetailExpanded(ShouldExpand)
    if not ShouldExpand then
      self.CurrentExpandedTaskTypeItem = nil
    end
    if UIUtils.IsGamepadInput() and TaskTypeItem.Content and TaskTypeItem.Content.TaskTypeIndex then
      self:SetGamepadFocusTaskType(TaskTypeItem.Content.TaskTypeIndex)
    end
    self:QueueUpdateTaskTypeScrollArrow()
    self:QueueUpdateTaskTypeVisibleEnterAnimation(true, TASK_TYPE_VISIBLE_ENTER_DELAY)
    return
  end
  if self.CurrentExpandedTaskTypeItem and IsValid(self.CurrentExpandedTaskTypeItem) then
    self.CurrentExpandedTaskTypeItem:SetDetailExpanded(false)
  end
  self.CurrentExpandedTaskTypeItem = TaskTypeItem
  TaskTypeItem:SetDetailExpanded(true)
  if UIUtils.IsGamepadInput() and TaskTypeItem.Content and TaskTypeItem.Content.TaskTypeIndex then
    self:SetGamepadFocusTaskType(TaskTypeItem.Content.TaskTypeIndex)
  end
  self:QueueUpdateTaskTypeScrollArrow()
  self:QueueUpdateTaskTypeVisibleEnterAnimation(true, TASK_TYPE_VISIBLE_ENTER_DELAY)
end

function M:OnTaskTypeItemLayoutChanged()
  self:UpdateTaskTypeScrollArrow()
  self:QueueUpdateTaskTypeScrollArrow(TASK_TYPE_SCROLL_ARROW_DELAY)
  self:QueueUpdateTaskTypeVisibleEnterAnimation(true, 0)
end

function M:OnTaskTypeEntryReleased(TaskTypeItem)
  if self.CurrentExpandedTaskTypeItem == TaskTypeItem then
    self.CurrentExpandedTaskTypeItem = nil
  end
  if self.FocusedTaskTypeItem == TaskTypeItem then
    self.FocusedTaskTypeItem = nil
  end
  self:QueueUpdateTaskTypeScrollArrow()
end

function M:BeginTaskTypeEnterBatch(TaskTypeCount)
  self:RemoveTimer(TASK_TYPE_ENTER_BATCH_TIMER)
  self.TaskTypeEnterOrder = 0
  self.bTaskTypeEnterBatchActive = true
  local DisplayCount = type(TaskTypeCount) == "number" and TaskTypeCount or 0
  local BatchDuration = math.min(DisplayCount, 8) * TASK_TYPE_ENTER_STEP_DELAY + 0.2
  self:AddTimer(BatchDuration, self.EndTaskTypeEnterBatch, false, 0, TASK_TYPE_ENTER_BATCH_TIMER, true)
end

function M:EndTaskTypeEnterBatch()
  self:RemoveTimer(TASK_TYPE_ENTER_BATCH_TIMER)
  self.bTaskTypeEnterBatchActive = false
  self.TaskTypeEnterOrder = 0
  self:QueueUpdateTaskTypeVisibleEnterAnimation(false, 0)
end

function M:RequestTaskTypeItemEnterAnimation(TaskTypeItem)
  if not TaskTypeItem or not TaskTypeItem.RequestEnterAnimation then
    return
  end
  local Delay = TASK_TYPE_SCROLL_ENTER_DELAY
  if self.bTaskTypeEnterBatchActive then
    Delay = TASK_TYPE_ENTER_INITIAL_DELAY + (self.TaskTypeEnterOrder or 0) * TASK_TYPE_ENTER_STEP_DELAY
    self.TaskTypeEnterOrder = (self.TaskTypeEnterOrder or 0) + 1
  end
  TaskTypeItem:RequestEnterAnimation(Delay)
end

function M:GetDisplayedTaskTypeItems()
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  local ListPopItem = PopupItemList and PopupItemList.List_PopItem
  if not ListPopItem or not ListPopItem.GetDisplayedEntryWidgets then
    return {}
  end
  return GetWidgetArrayTable(ListPopItem:GetDisplayedEntryWidgets())
end

function M:GetTaskTypeItemVisibilityKey(TaskTypeItem)
  local Content = TaskTypeItem and TaskTypeItem.Content
  local Key = Content and (Content.Id or Content.TaskId or Content.Title)
  if nil == Key then
    return tostring(TaskTypeItem)
  end
  return tostring(Key)
end

function M:IsTaskTypeItemVisible(TaskTypeItem)
  local PopupItemList = self.WBP_Activity_SkinCollect_Task_PopupItemList
  local ViewportWidget = PopupItemList and PopupItemList.ScrollPopItem
  local ViewportRect = GetWidgetAbsoluteRect(ViewportWidget)
  local ItemRect = GetWidgetAbsoluteRect(TaskTypeItem)
  return IsHorizontalRectIntersected(ViewportRect, ItemRect)
end

function M:QueueUpdateTaskTypeVisibleEnterAnimation(ShouldPlayEnterAnimation, Delay)
  self.bPendingTaskTypeVisibleEnterAnimation = self.bPendingTaskTypeVisibleEnterAnimation == true or true == ShouldPlayEnterAnimation
  if self.bTaskTypeVisibleEnterTimerPending then
    return
  end
  local RealDelay = type(Delay) == "number" and Delay or 0
  self.bTaskTypeVisibleEnterTimerPending = true
  self:AddTimer(RealDelay, self.FlushTaskTypeVisibleEnterAnimation, false, 0, TASK_TYPE_VISIBLE_ENTER_TIMER, true)
end

function M:FlushTaskTypeVisibleEnterAnimation()
  self:RemoveTimer(TASK_TYPE_VISIBLE_ENTER_TIMER)
  self.bTaskTypeVisibleEnterTimerPending = false
  local ShouldPlayEnterAnimation = self.bPendingTaskTypeVisibleEnterAnimation == true
  self.bPendingTaskTypeVisibleEnterAnimation = false
  self:UpdateTaskTypeVisibleEnterAnimation(ShouldPlayEnterAnimation)
end

function M:UpdateTaskTypeVisibleEnterAnimation(ShouldPlayEnterAnimation)
  if self.bTaskTypeEnterBatchActive then
    return
  end
  local TaskTypeItems = self:GetDisplayedTaskTypeItems()
  local NewVisibleStateMap = {}
  local TaskTypeVisibleList = {}
  local VisibleItemCount = 0
  for _, TaskTypeItem in ipairs(TaskTypeItems) do
    if IsValid(TaskTypeItem) then
      local VisibilityKey = self:GetTaskTypeItemVisibilityKey(TaskTypeItem)
      local bIsVisible = self:IsTaskTypeItemVisible(TaskTypeItem)
      NewVisibleStateMap[VisibilityKey] = bIsVisible
      table.insert(TaskTypeVisibleList, {
        TaskTypeItem = TaskTypeItem,
        VisibilityKey = VisibilityKey,
        bIsVisible = bIsVisible
      })
      if bIsVisible then
        VisibleItemCount = VisibleItemCount + 1
      end
    end
  end
  if #TaskTypeItems > 0 and VisibleItemCount <= 0 then
    return
  end
  for _, VisibleInfo in ipairs(TaskTypeVisibleList) do
    local TaskTypeItem = VisibleInfo.TaskTypeItem
    if IsValid(TaskTypeItem) then
      if not VisibleInfo.bIsVisible and TaskTypeItem.PrepareEnterAnimation then
        TaskTypeItem:PrepareEnterAnimation()
      elseif VisibleInfo.bIsVisible then
        local bShouldPlayEnterAnimation = self.bTaskTypeVisibleStateInitialized and ShouldPlayEnterAnimation and not self.TaskTypeVisibleStateMap[VisibleInfo.VisibilityKey]
        if bShouldPlayEnterAnimation then
          if TaskTypeItem.PrepareEnterAnimation then
            TaskTypeItem:PrepareEnterAnimation()
          end
          TaskTypeItem:RequestEnterAnimation(TASK_TYPE_SCROLL_ENTER_DELAY)
        elseif TaskTypeItem.EnsureEnterAnimationVisible then
          TaskTypeItem:EnsureEnterAnimationVisible()
        elseif TaskTypeItem.SetRenderOpacity then
          TaskTypeItem:SetRenderOpacity(1)
        end
      end
    end
  end
  self.TaskTypeVisibleStateMap = NewVisibleStateMap
  self.bTaskTypeVisibleStateInitialized = true
end

return M
