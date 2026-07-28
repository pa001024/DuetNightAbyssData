require("UnLua")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildBossRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossRewardUtils")
local GuildBossPointRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossPointRewardUtils")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local EastSeasonQuestUtils = require("BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils")
local TimeUtils = require("Utils.TimeUtils")
local PageJumpUtils = require("Utils.PageJumpUtils")
local SimpleRewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local M = Class({
  "Blueprints.UI.BP_UIState_C"
})

local function EnsureWidgetFocusable(Widget)
  if not Widget then
    return
  end
  Widget.bIsFocusable = true
  if Widget.SetIsFocusable then
    Widget:SetIsFocusable(true)
  end
end

local function FocusWidgetIfValid(Widget)
  if IsValid(Widget) then
    if UWidgetBlueprintLibrary and UWidgetBlueprintLibrary.SetUserFocus then
      UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), Widget)
    end
    Widget:SetFocus()
  end
end

local FocusGuildRewardDefaultTabTimerKey = "FocusGuildRewardDefaultTab"
local FocusGuildRewardSelectedTabEntryTimerKey = "FocusGuildRewardSelectedTabEntry"
local RefreshFocusGuildRewardDefaultTabTimerKey = "RefreshFocusGuildRewardDefaultTab"
local GuildRewardPreviewCloseRestoreFocusTimerKey = "GuildRewardPreviewCloseRestoreFocus"

local function ClearPendingTabFocusTimers(Widget)
  if not Widget then
    return
  end
  Widget:RemoveTimer(FocusGuildRewardDefaultTabTimerKey)
  Widget:RemoveTimer(FocusGuildRewardSelectedTabEntryTimerKey)
  Widget:RemoveTimer(RefreshFocusGuildRewardDefaultTabTimerKey)
  Widget:RemoveTimer(GuildRewardPreviewCloseRestoreFocusTimerKey)
end

local function IsGuildBossMode(Widget)
  return Widget and Widget.ConfigData and Widget.ConfigData.Mode == "GuildBoss"
end

function M:Construct()
  M.Super.Construct(self)
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self:SetBaseName(Name)
  self:BindInOutAnimationWithConfigParam()
  self.IsInUIMode = IsInUIMode
  if self.IsInUIMode then
    self:SetInputUIOnly(true)
  end
  self:UIOnLoaded(...)
  if self.Auto_In ~= nil then
    self:PlayAnimationForward(self.Auto_In)
  end
  if nil ~= EventList then
    for i, v in ipairs(EventList) do
      if type(self[v]) == "function" then
        self:AddDispatcher(v, self, self[v])
      end
    end
  end
  self:AddDispatcher(EventID.OnNetDisconnect, self, self._ClearBlockUIInputTags)
  self:AddDispatcher(EventID.OnConnectSuccess, self, self._ClearBlockUIInputTags)
end

function M:OnLoaded(...)
  local Params = (...)
  Params = Params or self:MakeGuildQuestConfigData()
  if not Params then
    return
  end
  EnsureWidgetFocusable(self)
  local ConfigData = Params.ConfigData
  self.TabConfigDatas = Params.TabConfigDatas
  self.ConfigData = ConfigData
  self.Owner = Params.Owner
  self.Type = ConfigData.Type
  self.CurrentTab = nil
  self.NeedOpenMenuWhenResoureFocused = false
  self.bIsMenuOpen = false
  self.Type2Index = {}
  self.Datas = ConfigData.Datas
  self.Items = ConfigData.Items
  self.TabInfo = ConfigData.TabInfo
  self.HasTab = ConfigData.HasTab
  if self.Text_Tip then
    self.Text_Tip:SetText(GText("UI_ActivityFromMemo"))
  end
  self.RewardContent_OneClick.Btn_OneClick:SetText(GText(ConfigData.ReceiveButtonText))
  self.RewardContent_OneClick.Btn_OneClick:SetDefaultGamePadImg("Y")
  self.RewardContent_OneClick.Btn_OneClick:UnBindEventOnClickedByObj(self)
  self.RewardContent_OneClick.Btn_OneClick:BindEventOnClicked(self, function()
    if self.HasTab then
      ConfigData.Datas[self.Type].ReceiveAllParam.SelfWidget = self
      ConfigData.Datas[self.Type].ReceiveAllCallBack(self, ConfigData.Datas[self.Type].ReceiveAllParam)
    else
      ConfigData.ReceiveAllParam.SelfWidget = self
      ConfigData.ReceiveAllCallBack(self, ConfigData.ReceiveAllParam)
    end
  end)
  self.Com_Tab:Init({
    TitleName = GText(self.ConfigData.TopText or "PermanenEventReward"),
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "SpaceBar",
            Owner = self,
            ClickCallback = function(...)
              return self.RewardContent_OneClick.Btn_OneClick:OnBtnClicked(...)
            end
          }
        },
        Desc = GText("UI_Achievement_GetAllReward"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
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
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    },
    BackCallback = self.CloseSelf,
    OwnerPanel = self
  })
  if self.HasTab then
    self:InitListTabInfo()
    self:ScrollToSelectTab()
  end
  self.List_Item.BP_OnEntryGenerated:Add(self, function(self, Widget)
    if IsValid(Widget) then
      Widget:SetNavigationRuleCustom(EUINavigation.Up, {
        self,
        self.OnNavigateUp
      })
      Widget:SetNavigationRuleCustom(EUINavigation.Down, {
        self,
        self.OnNavigateDown
      })
    end
  end)
  if not self.HasTab then
    self:InitItem(ConfigData)
    self:Refresh(ConfigData)
  end
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self:AddInputMethodChangedListen()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:TryInitGamepadView()
    if not self.HasTab then
      self.List_Item:SetFocus()
    end
  else
    self:SetFocus()
  end
  self.Com_Time:SetTimeText(GText(self.ConfigData.TimeText or ""), self.ConfigData.RemainTimeDict or {})
  if M.WeeklyResetEndTime then
    self.CountDownTimer = self:AddTimer(1.0, function()
      M.UpdateWeeklyCountDown(self)
    end, true, 0, "GuildWeeklyCountDown", true)
  end
  EventManager:AddEvent(EventID.OnDailyRefresh, self, self.OnRefreshInNextDay)
  EventManager:AddEvent(EventID.RefreshAcvitityRewardPanel, self, self.RefreshAcvitityRewardPanel)
  if IsGuildBossMode(self) then
    self:InitGuildBossMode()
  else
    GuildController:RegisterEvent(self, function(self, EventId, ...)
      if EventId == GuildCommon.EventID.OnGuildActivityPointReward then
        self:OnRecvActivityPointReward(...)
      end
    end)
    self:InitActivityProgress()
    ReddotManager.AddListener("GuildWeekActivity", self, self.OnGuildWeekActivityReddotChange)
    ReddotManager.AddListener("GuildDailyTask", self, self.OnGuildTaskReddotChange)
    ReddotManager.AddListener("GuildWeekTask", self, self.OnGuildTaskReddotChange)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "GuildRewardNormalIn", nil)
end

function M:RefreshAcvitityRewardPanel()
  if self.ConfigData.RefreshPanleCallBack then
    self.ConfigData.RefreshPanleCallBack(self)
  end
  if not IsGuildBossMode(self) then
    self:RefreshActivityProgress()
  end
end

function M:InitGuildBossMode()
  self:InitGuildBossPointRewardArea()
  ReddotManager.AddListener("GuildBossPersonPointReward", self, self.OnGuildBossRewardReddotChange)
  ReddotManager.AddListener("GuildBossProgressReward", self, self.OnGuildBossRewardReddotChange)
  self:RefreshTabReddot()
end

function M:InitGuildBossPointRewardArea()
  GuildBossRewardUtils.RefreshPointRewardBottom(self)
end

function M:OnGuildBossPointRewardItemClicked(Item)
  if not Item then
    return
  end
  if Item.bCanGet then
    GuildBossRewardUtils.ClaimPointRewardSlot(self, Item.Idx)
    return
  end
  self:ShowGuildBossPointRewardPreview()
end

function M:ShowGuildBossPointRewardPreview()
  local Snapshot = GuildBossRewardUtils.GetPointRewardSnapshot()
  if not (Snapshot and Snapshot.RewardIds) or not Snapshot.EachGradePoints then
    return
  end
  local Groups = {}
  for Index = 1, math.min(GuildBossRewardUtils.POINT_REWARD_SLOT_COUNT, #Snapshot.RewardIds) do
    local GradePoints = Snapshot.EachGradePoints * Index
    table.insert(Groups, {
      Title = string.format("%s%d", GText("RougeMiniGamePointsReach"), GradePoints),
      RewardId = Snapshot.RewardIds[Index]
    })
  end
  if 0 == #Groups then
    return
  end
  ClearPendingTabFocusTimers(self)
  local Params = {
    Groups = Groups,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.OnActivityRewardPreviewClosed
  }
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(100364, Params, self)
end

function M:UpdateBottomKey(ShowGetAllButton)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if ShowGetAllButton then
    self.Com_Tab:UpdateBottomKeyInfo({
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "SpaceBar",
            Owner = self,
            ClickCallback = function(...)
              return self.RewardContent_OneClick.Btn_OneClick:OnBtnClicked(...)
            end
          }
        },
        Desc = GText("UI_Achievement_GetAllReward"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
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
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    })
  else
    self.Com_Tab:UpdateBottomKeyInfo({
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
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
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    })
  end
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.Auto_In) or self:IsAnimationPlaying(self.Auto_Out) then
    return
  end
  self:Close()
end

function M:Close()
  local UIManager = UIManager(self)
  local PreviousUI = UIManager:GetUnderState()
  if PreviousUI and PreviousUI:GetName() == "GuildMain" then
    EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  end
  AudioManager(self):SetEventSoundParam(self, "GuildRewardNormalIn", {ToEnd = 1})
  if self.Auto_Out then
    self:PlayAnimation(self.Auto_Out, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1)
  else
    self.Super.Close(self)
  end
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Auto_Out then
    self.Super.Close(self)
  end
end

function M:ScrollToSelectTab()
  local SelectIndex = self.Type2Index[self.Type] or 1
  self.List_Tab:ScrollIndexIntoView(SelectIndex - 1)
  self:AddTimer(0.1, function()
    self.List_Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local Item = self.List_Tab:GetItemAt(SelectIndex - 1)
    if Item then
      self.List_Tab:SetSelectedIndex(SelectIndex - 1)
      if Item.Entry then
        Item.Entry:OnCellClicked(true)
        if self.GameInputModeSubsystem then
          self.GameInputModeSubsystem:SetTargetUIFocusWidget(Item.Entry)
        end
      end
    end
    self:RefreshTabReddot()
    if self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
      self:AddTimer(0.05, function()
        self:FocusSelectedTabEntry()
      end, false, 0, FocusGuildRewardDefaultTabTimerKey, true)
    end
  end, false, 0, "SelectRewardTab", true)
end

function M:FocusSelectedTabEntry()
  if not self.HasTab or not self.List_Tab then
    return
  end
  ClearPendingTabFocusTimers(self)
  local Item = self.List_Tab:BP_GetSelectedItem()
  local SelectIndex = Item and self.List_Tab:GetIndexForItem(Item) or -1
  if not Item then
    SelectIndex = (self.Type2Index[self.Type] or 1) - 1
    Item = self.List_Tab:GetItemAt(SelectIndex)
  end
  if Item and Item.Entry then
    self.List_Tab:SetSelectedIndex(SelectIndex)
    if self.GameInputModeSubsystem then
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(Item.Entry)
    end
    if SelectIndex and SelectIndex >= 0 then
      self.List_Tab:ScrollIndexIntoView(SelectIndex)
    end
    self:AddTimer(0.01, function()
      FocusWidgetIfValid(Item.Entry)
      self.IsRewardItemFocused = false
      self:RefreshDetailItemFocusHint(nil)
    end, false, 0, FocusGuildRewardSelectedTabEntryTimerKey, true)
  end
end

function M:InitItem(ConfigData)
  self.List_Item:ClearListItems()
  if 1 == ConfigData.SortType then
    self:SortItems()
  end
  local Count = 0
  for _, Item in pairs(ConfigData.Items) do
    local MenuContent = NewObject(UIUtils.GetCommonItemContentClass())
    MenuContent.Owner = self
    MenuContent.ConfigData = Item
    MenuContent.Id = -1
    if Item.CanReceive then
      Count = Count + 1
    end
    self.List_Item:AddItem(MenuContent)
  end
  if 2 == ConfigData.SortType then
    self:AddTimer(0.01, function()
      local IndexToScroll = 0
      for i = 0, self.List_Item:GetNumItems() - 1 do
        local Item = self.List_Item:GetItemAt(i)
        if Item.ConfigData.CanReceive then
          self:AddTimer(0.1, function()
            self.List_Item:ScrollIndexIntoView(i)
          end)
          return
        elseif not Item.ConfigData.RewardsGot and 0 == IndexToScroll then
          IndexToScroll = i
        end
      end
      self.List_Item:ScrollIndexIntoView(IndexToScroll)
    end, false, 0, nil, true)
  end
  if Count > 0 then
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(false)
    self:UpdateBottomKey(true)
  else
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
    self:UpdateBottomKey(false)
  end
  if IsGuildBossMode(self) then
    if self.List_Item.SetEmptyGridItemCount then
      self.List_Item:SetEmptyGridItemCount(0)
    end
  else
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
      local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
      ItemContent.IsEmpty = true
      return ItemContent
    end)
    self.List_Item:RequestFillEmptyContent()
  end
end

function M:SortItems()
  if not self.Items then
    return
  end
  table.sort(self.Items, function(a, b)
    if a.CanReceive and not b.CanReceive then
      return true
    end
    if not a.CanReceive and b.CanReceive then
      return false
    end
    if a.RewardsGot and not b.RewardsGot then
      return false
    end
    if not a.RewardsGot and b.RewardsGot then
      return true
    end
    return (a.ItemId or 0) < (b.ItemId or 0)
  end)
end

function M:RefreshItems()
  self:Refresh(self.HasTab and self.ConfigData.Datas[self.Type] or self.ConfigData)
end

function M:RefreshDaily()
  if not self.HasTab or self.ConfigData.Datas[self.Type].HasDailyQuest then
    self:Refresh(self.HasTab and self.ConfigData.Datas[self.Type] or self.ConfigData)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice)
  if not self.IsInFocusPath then
    return
  end
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self:InitKeyBoardView()
  elseif CurInputDevice == ECommonInputType.Gamepad then
    self:TryInitGamepadView()
    if self.HasTab then
      self:AddTimer(0.01, function()
        self:FocusSelectedTabEntry()
      end, false, 0, RefreshFocusGuildRewardDefaultTabTimerKey, true)
    end
  end
end

function M:OnSelectItemChanged(SelectItem)
  ClearPendingTabFocusTimers(self)
  if SelectItem and SelectItem.Entry and self.GameInputModeSubsystem then
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(SelectItem.Entry)
  end
  if SelectItem and self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and SelectItem.Entry then
    SelectItem.Entry:OnCellClicked()
  end
end

function M:OnTabClickedWhenSelected()
  if not self.IsInViewMode and self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
    self:ShowGamepadViewBtn(true)
    self:FocusFirstRewardItem()
  end
end

function M:OnUINavigation(NavigationDirection)
  if NavigationDirection == EUINavigation.Left then
    if self.CurFocusedRewardItem then
      self.CurFocusedRewardItem:StopHover(true)
      self.CurFocusedRewardItem = nil
    end
    self.IsRewardItemFocused = false
    self:RefreshDetailItemFocusHint(nil)
    self:ShowGamepadViewBtn(false)
    return self.SelectedContent.Entry
  elseif NavigationDirection == EUINavigation.Right then
    self:ShowGamepadViewBtn(true)
    local TargetWidget = self:NavigateToFirstDisplayedItem(self.List_Item)
    if TargetWidget and TargetWidget.Content then
      self:RefreshDetailItemFocusHint(TargetWidget.Content)
    end
    return TargetWidget
  end
end

function M:InitListTabInfo()
  self.List_Tab.BP_OnItemSelectionChanged:Add(self, self.OnSelectItemChanged)
  self.List_Tab:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    self.OnUINavigation
  })
  self.List_Tab:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Tab:SetVisibility(ESlateVisibility.HitTestInvisible)
  self.List_Item:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    self.OnUINavigation
  })
  self.List_Item:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Item:SetControlScrollbarInside(true)
  local ClassPath = "/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C"
  self.List_Tab:ClearListItems()
  for Index, TabItem in ipairs(self.TabInfo) do
    local Obj = NewObject(UE4.LoadClass(ClassPath))
    Obj.Root = self
    Obj.Index = Index
    Obj.Title = GText(TabItem.Title)
    Obj.Type = TabItem.Type
    Obj.IsShowIcon = TabItem.IsShowIcon
    Obj.IconPath = TabItem.IconPath
    Obj.ReddotName = TabItem.ReddotName
    Obj.IsForbidden = TabItem.IsForbidden
    Obj.ForbiddenReasonText = TabItem.ForbiddenReasonText
    self.List_Tab:AddItem(Obj)
    self.Type2Index[TabItem.Type] = Index
  end
end

function M:RefreshListRewardInfo(Item, NotPlaySound)
  if self.SelectedContent then
    self.SelectedContent.Entry:UnSelected()
  end
  self.SelectedContent = Item.Content
  self.SelectedContent.Entry:Selected(NotPlaySound)
  self:RealRefreshListRewardInfo(self.SelectedContent.Type, NotPlaySound)
end

function M:RealRefreshListRewardInfo(TabType, NotPlaySound)
  local ConfigData = self.Datas[TabType]
  self.Type = TabType
  if not NotPlaySound then
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  end
  if IsGuildBossMode(self) then
    GuildBossRewardUtils.RefreshGuildBossRewardConfigData(self)
    ConfigData = self.Datas[TabType]
  else
    M.RefreshGuildQuestConfigData(self)
    ConfigData = self.Datas[TabType]
  end
  if not ConfigData then
    return
  end
  self.Items = ConfigData.Items
  self:Refresh(ConfigData)
  self:RefreshBtnGetAll(ConfigData)
  if self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
    self:ShowGamepadViewBtn(false)
  end
  self:PlayAnimation(self.Change)
  self:AddTimer(0.01, function()
    UIUtils.PlayListViewFramingInAnimation(self, self.List_Item, {
      AnimName = "In",
      Callback = function()
        if not self.GameInputModeSubsystem or self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then
          self:NavigateToFirstDisplayedItem(self.List_Item)
        end
        self:RefreshDetailItemFocusHint(nil)
      end
    })
  end, false, 0, nil, true)
end

function M:RefreshBtnGetAll(ConfigData)
  if ConfigData.HideReceiveButton then
    self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.Collapsed)
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
    self:UpdateBottomKey(false)
    return
  end
  local HasRewardToGet = false
  for _, Item in pairs(ConfigData.Items) do
    if Item.CanReceive and not Item.RewardsGot then
      HasRewardToGet = true
      break
    end
  end
  if HasRewardToGet then
    local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
    if CurInputDevice ~= ECommonInputType.Touch and CurInputDevice ~= ECommonInputType.MouseAndKeyboard then
      self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
      self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(false)
      self:UpdateBottomKey(true)
    end
  else
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
    self:UpdateBottomKey(false)
  end
end

function M:Destruct()
  self.Super.Destruct(self)
  EventManager:RemoveEvent(EventID.OnDailyRefresh, self)
  EventManager:RemoveEvent(EventID.RefreshAcvitityRewardPanel, self)
  if IsGuildBossMode(self) then
    ReddotManager.RemoveListener("GuildBossPersonPointReward", self)
    ReddotManager.RemoveListener("GuildBossProgressReward", self)
  else
    GuildController:UnRegisterEvent(self)
    ReddotManager.RemoveListener("GuildWeekActivity", self)
    ReddotManager.RemoveListener("GuildDailyTask", self)
    ReddotManager.RemoveListener("GuildWeekTask", self)
  end
  self:RemoveInputMethodChangedListen()
  if self.List_Tab then
    self.List_Tab:ClearListItems()
  end
  self.List_Item:ClearListItems()
  M.WeeklyResetEndTime = nil
end

function M:UpdateWeeklyCountDown()
  if not M.WeeklyResetEndTime or not IsValid(self.Com_Time) then
    return
  end
  local Now = math.tointeger(TimeUtils.NowTime())
  if Now >= M.WeeklyResetEndTime then
    M.WeeklyResetEndTime = nil
    self:RefreshAcvitityRewardPanel()
    return
  end
  local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(math.floor(M.WeeklyResetEndTime), math.floor(Now))
  self.Com_Time:SetTimeText(GText("UI_ResetRemaining"), RemainTimeDict)
end

function M:NavigateToFirstDisplayedItem(List)
  local ItemUIs = List:GetDisplayedEntryWidgets()
  if ItemUIs:Length() > 0 then
    local TargetWidget
    for i = 1, ItemUIs:Length() do
      local Widget = ItemUIs:GetRef(i)
      if Widget.Content and Widget.Content.Id and (not TargetWidget or Widget.Content.Id < TargetWidget.Content.Id) then
        TargetWidget = Widget
      end
    end
    if TargetWidget then
      List:BP_NavigateToItem(TargetWidget.Content)
      return TargetWidget
    end
  end
  return List
end

function M:HasItemAreaFocus()
  return self.List_Item and self.List_Item:HasAnyUserFocus()
end

function M:FocusFirstRewardItem()
  local TargetWidget = self:NavigateToFirstDisplayedItem(self.List_Item)
  if TargetWidget then
    if TargetWidget.Content and self.GameInputModeSubsystem then
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(TargetWidget)
    end
    self:AddTimer(0.01, function()
      FocusWidgetIfValid(TargetWidget)
    end, false, 0, "FocusFirstRewardItemTimer", true)
    if TargetWidget.Content then
      self:RefreshDetailItemFocusHint(TargetWidget.Content)
    else
      self:RefreshDetailItemFocusHint(nil)
    end
  else
    self:RefreshDetailItemFocusHint(nil)
  end
  return TargetWidget
end

function M:IsSelectableRewardItem(Item)
  return Item and not Item.IsEmpty
end

function M:GetAdjacentSelectableRewardItem(StartIndex, Step)
  if not self.List_Item then
    return nil
  end
  local ItemCount = self.List_Item:GetNumItems()
  local Index = StartIndex + Step
  while Index >= 0 and ItemCount > Index do
    local TargetItem = self.List_Item:GetItemAt(Index)
    if self:IsSelectableRewardItem(TargetItem) then
      return Index, TargetItem
    end
    Index = Index + Step
  end
  return nil
end

function M:TryInitGamepadView()
  self:InitGamepadView()
end

function M:InitGamepadView()
  local FirstWidget
  if not self.HasTab then
    FirstWidget = self:NavigateToFirstDisplayedItem(self.List_Item)
  end
  self.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(true)
  if not self.RewardContent_OneClick.Btn_OneClick:IsBtnForbidden() then
    self.RewardContent_OneClick.Btn_OneClick:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  self:ShowGamepadViewBtn(true)
  if self.Controller_Activity then
    self.Controller_Activity:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Controller_Activity:CreateGamepadKey("X")
  end
  if self.HasTab then
    self:FocusSelectedTabEntry()
  end
  if FirstWidget and FirstWidget.Content then
    self:RefreshDetailItemFocusHint(FirstWidget.Content)
  end
end

function M:InitDetailItemGamepadHints()
  if not self.List_Item then
    return
  end
  local ItemUIs = self.List_Item:GetDisplayedEntryWidgets()
  for i = 1, ItemUIs:Length() do
    local Widget = ItemUIs:GetRef(i)
    if Widget and Widget.Content and Widget.Content.SelfWidget then
      local DetailItem = Widget.Content.SelfWidget
      if DetailItem.RefreshGamepadHint then
        local bIsFocused = Widget:HasAnyUserFocus()
        DetailItem:RefreshGamepadHint(bIsFocused)
      end
    end
  end
end

function M:InitKeyBoardView()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if self.IsInViewMode then
    self:ExitViewMode()
  end
  self.IsInViewMode = false
  self.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(false)
  if not self.RewardContent_OneClick.Btn_OneClick:IsBtnForbidden() then
    self.RewardContent_OneClick.Btn_OneClick:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self:ShowGamepadViewBtn(false)
  if self.Controller_Activity then
    self.Controller_Activity:SetVisibility(ESlateVisibility.Collapsed)
  end
  local ConfigData = self.Datas[self.Type] or self.ConfigData
  self:RefreshBtnGetAll(ConfigData)
  self:PlayAnimation(self.Normal)
  self:RefreshDetailItemFocusHint(nil)
  self:InitDetailItemGamepadHints()
  self:AddTimer(0.01, function()
    if self.Com_Tab then
      FocusWidgetIfValid(self.Com_Tab)
    end
  end, false, 0, "ClearItemFocusTimer", true)
end

function M:ShowGamepadViewBtn(bShow)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  local KeyInfoList = {
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
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
          ClickCallback = self.CloseSelf,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
  local CurConfigData = self.HasTab and self.Datas and self.Datas[self.Type] or self.ConfigData
  if CurConfigData and CurConfigData.HasCanReceive and not CurConfigData.HideReceiveButton then
    table.insert(KeyInfoList, 1, {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "Y",
          Owner = self
        }
      },
      Desc = GText("UI_CTL_ClaimALL"),
      bLongPress = false
    })
  end
  self.Com_Tab:UpdateBottomKeyInfo(KeyInfoList)
end

function M:ShowGamepadViewSingleBtn(bShow)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" or not bShow then
    return
  end
  self.Com_Tab:UpdateBottomKeyInfo({
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
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
          ClickCallback = self.CloseSelf,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  })
end

function M:ShowGamepadViewSelectModeBtn(bInSelectMode)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if bInSelectMode then
    if self.Controller_Activity then
      self.Controller_Activity:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Com_Tab:UpdateBottomKeyInfo({
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.ExitViewMode,
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Close"),
        bLongPress = false
      }
    })
  else
    if self.Controller_Activity then
      self.Controller_Activity:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Controller_Activity:CreateGamepadKey("X")
    end
    self:ShowGamepadViewBtn(true)
  end
end

function M:RefreshButton(CanReceiveAll)
  if CanReceiveAll then
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(false)
    self:UpdateBottomKey(true)
  else
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
    self:UpdateBottomKey(false)
  end
end

function M:OnTabSelected(TabWidget)
  if self.TabConfigDatas and self.TabConfigDatas[TabWidget.Idx] then
    self:Refresh(self.TabConfigDatas[TabWidget.Idx])
    return
  end
  if self.ConfigData and self.ConfigData.TabInfo[TabWidget.Idx] then
    self:RealRefreshListRewardInfo(self.ConfigData.TabInfo[TabWidget.Idx].Type)
  end
end

function M:GetScoreTierCurrentScore()
  local Snapshot = GuildBossRewardUtils.GetPointRewardSnapshot()
  return Snapshot and Snapshot.CurrentScore or 0
end

function M:IsScoreTierRewardGot(Index)
  local AvatarBossData = GuildModel:GetAvatarGuildBossData()
  return GuildBossPointRewardUtils.IsPointRewardGot(AvatarBossData, Index)
end

function M:RequestClaimScoreTierReward(Index, Callback)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if nil == Index then
    if not Avatar.GuildBossClaimAllPointReward then
      return
    end
    Avatar:GuildBossClaimAllPointReward(function(RetCode, Info)
      if Callback then
        Callback(RetCode, Info and Info.Rewards)
      end
      if ErrorCode:Check(RetCode) then
        GuildBossRewardUtils.RefreshGuildBossRewardConfigData(self)
      end
    end)
    return
  end
  if not Avatar.GuildBossClaimPointReward then
    return
  end
  Avatar:GuildBossClaimPointReward(function(RetCode, Rewards)
    if Callback then
      Callback(RetCode, Rewards)
    end
    if ErrorCode:Check(RetCode) then
      GuildBossRewardUtils.RefreshGuildBossRewardConfigData(self)
    end
  end, Index)
end

function M:ScoreTierReward_OnClaimSuccess()
  GuildBossRewardUtils.RefreshGuildBossRewardConfigData(self)
end

function M:Refresh(ConfigData)
  self.Items = ConfigData.Items
  self.RewardContent_OneClick.Text_ProgressTitle:SetText(GText(ConfigData.Text_Total))
  self.RewardContent_OneClick.Count_Main:SetText(tostring(ConfigData.NowNum))
  self.RewardContent_OneClick.Max_Main:SetText(tostring(ConfigData.NumMax))
  local NumMax = tonumber(ConfigData.NumMax) or 0
  local NowNum = tonumber(ConfigData.NowNum) or 0
  self.RewardContent_OneClick.Progress_Main:SetPercent(NumMax > 0 and NowNum / NumMax or 0)
  if self.RewardContent_OneClick.Max_Main then
    self.RewardContent_OneClick.Max_Main:SetVisibility(ConfigData.OnlyShowNowProgress and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
  end
  if self.Text_Tip then
    if ConfigData.TipText then
      self.Text_Tip:SetText(GText(ConfigData.TipText))
      self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  if ConfigData.HideReceiveButton then
    self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.Collapsed)
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
  else
    self.RewardContent_OneClick.Btn_OneClick:SetText(GText(ConfigData.ReceiveButtonText))
    self.RewardContent_OneClick.Btn_OneClick:UnBindEventOnClickedByObj(self)
    self.RewardContent_OneClick.Btn_OneClick:BindEventOnClicked(self, function()
      ConfigData.ReceiveAllParam.SelfWidget = self
      ConfigData.ReceiveAllCallBack(self, ConfigData.ReceiveAllParam)
    end)
  end
  self:InitItem(ConfigData)
end

function M:OnNavigateUp(NavDirection)
  if self.IsInViewMode then
    return nil
  end
  if not self.CurrentSelectedItem then
    return self:NavigateToFirstDisplayedItem(self.List_Item, 2)
  end
  local CurIndex = self.List_Item:GetIndexForItem(self.CurrentSelectedItem)
  local Id, TargetItem = self:GetAdjacentSelectableRewardItem(CurIndex, -1)
  if nil ~= Id then
    self.List_Item:NavigateToIndex(Id)
    self:RefreshDetailItemFocusHint(TargetItem)
    return self:FindEntryWidgetByContent(TargetItem)
  end
  return self:FindEntryWidgetByContent(self.CurrentSelectedItem)
end

function M:OnNavigateDown(NavDirection)
  if self.IsInViewMode then
    return nil
  end
  if not self.CurrentSelectedItem then
    return self:NavigateToFirstDisplayedItem(self.List_Item, 2)
  end
  local CurIndex = self.List_Item:GetIndexForItem(self.CurrentSelectedItem)
  local Id, TargetItem = self:GetAdjacentSelectableRewardItem(CurIndex, 1)
  if nil ~= Id then
    self.List_Item:NavigateToIndex(Id)
    self:RefreshDetailItemFocusHint(TargetItem)
    return self:FindEntryWidgetByContent(TargetItem)
  end
  return self:FindEntryWidgetByContent(self.CurrentSelectedItem)
end

function M:FindEntryWidgetByContent(ContentObj)
  if not self.List_Item or not ContentObj then
    return nil
  end
  local ItemUIs = self.List_Item:GetDisplayedEntryWidgets()
  for i = 1, ItemUIs:Length() do
    local Widget = ItemUIs:GetRef(i)
    if Widget and Widget.Content == ContentObj then
      return Widget
    end
  end
  return nil
end

function M:RefreshDetailItemFocusHint(NewSelectedItem)
  if not self.List_Item then
    return
  end
  if NewSelectedItem and NewSelectedItem.IsEmpty then
    NewSelectedItem = nil
  end
  if self.CurFocusedRewardItem and (not NewSelectedItem or self.CurFocusedRewardItem ~= NewSelectedItem.SelfWidget) then
    if self.CurFocusedRewardItem.StopHover then
      self.CurFocusedRewardItem:StopHover(true)
    end
    self.CurFocusedRewardItem = nil
  end
  self.IsRewardItemFocused = nil ~= NewSelectedItem
  self.CurrentSelectedItem = NewSelectedItem
  if NewSelectedItem and NewSelectedItem.SelfWidget then
    self.CurFocusedRewardItem = NewSelectedItem.SelfWidget
  end
  local ItemUIs = self.List_Item:GetDisplayedEntryWidgets()
  for i = 1, ItemUIs:Length() do
    local Widget = ItemUIs:GetRef(i)
    if Widget and Widget.Content and Widget.Content.SelfWidget then
      local DetailItem = Widget.Content.SelfWidget
      local bIsFocused = Widget.Content == NewSelectedItem
      if not bIsFocused and DetailItem.StopHover then
        DetailItem:StopHover(true)
      end
      if DetailItem.RefreshGamepadHint then
        DetailItem:RefreshGamepadHint(bIsFocused)
      end
    end
  end
end

function M:AddInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RemoveInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:OnMenuOpenChanged(bIsOpen)
  self.bIsMenuOpen = bIsOpen
  local CurInputType = UIUtils.UtilsGetCurrentInputType()
  if CurInputType == ECommonInputType.Gamepad then
    if self.IsInViewMode then
      if bIsOpen then
        self.Com_Tab:UpdateBottomKeyInfo({})
      else
        self:ShowGamepadViewSelectModeBtn(true)
      end
    else
      self:ShowGamepadViewSingleBtn(not bIsOpen)
    end
    if not bIsOpen then
      ClearPendingTabFocusTimers(self)
      self:RemoveTimer("RestoreFocusAfterMenuClose")
      self:AddTimer(0.01, function()
        if not IsValid(self) then
          return
        end
        if self.IsInViewMode then
          local SelectItem = self.CurrentSelectedItem
          if SelectItem and SelectItem.SelfWidget and SelectItem.SelfWidget.UsedList then
            local ItemUIs = SelectItem.SelfWidget.UsedList:GetDisplayedEntryWidgets()
            if ItemUIs and ItemUIs:Length() > 0 then
              local Target = ItemUIs:GetRef((SelectItem.SelfWidget.SelectedIndex or 0) + 1)
              if Target then
                FocusWidgetIfValid(Target)
              end
            end
          end
        elseif self.IsRewardItemFocused and self.CurFocusedRewardItem then
          FocusWidgetIfValid(self.CurFocusedRewardItem)
        else
          self:FocusSelectedTabEntry()
        end
      end, false, 0, "RestoreFocusAfterMenuClose", true)
    end
  elseif CurInputType == ECommonInputType.MouseAndKeyboard and not bIsOpen then
    self:RemoveTimer("RestoreFocusAfterMenuClose_KM")
    self:AddTimer(0.01, function()
      if not IsValid(self) then
        return
      end
      self:SetFocus()
    end, false, 0, "RestoreFocusAfterMenuClose_KM", true)
  end
end

function M:OnRefreshInNextDay()
  if self.ConfigData.DailyRefreshFunc then
    local RefreshParam = {SelfWidget = self}
    UIManager(self):ShowCommonPopupUI(100310, {
      RightCallbackFunction = function()
        self.ConfigData.DailyRefreshFunc(self, RefreshParam)
      end
    })
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Bottom" == InKeyName and self.HasTab and not self.IsRewardItemFocused then
      IsEventHandled = true
      self:ShowGamepadViewBtn(true)
      self:FocusFirstRewardItem()
    end
    if self.IsInViewMode then
      if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        IsEventHandled = true
        self:ExitViewMode()
      end
    else
      if InKeyName == UIConst.GamePadKey.FaceButtonTop then
        IsEventHandled = true
        self.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
      end
      if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        IsEventHandled = true
        self:OnReturnKeyDown()
      end
      if "Gamepad_FaceButton_Bottom" == InKeyName and self.IsRewardItemFocused and not IsEventHandled then
        IsEventHandled = true
        self:OnConfirmAction()
      end
      if "Gamepad_FaceButton_Left" == InKeyName then
        IsEventHandled = true
        self:OnXButtonClicked()
      end
    end
  elseif "SpaceBar" == InKeyName then
    IsEventHandled = true
    self.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:CloseSelf()
  end
  return IsEventHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if self.IsInViewMode then
      if "Gamepad_FaceButton_Bottom" == InKeyName and not self.IsRewardItemFocused then
        return UE4.UWidgetBlueprintLibrary.Handled()
      end
    elseif "Gamepad_FaceButton_Bottom" == InKeyName and not self.IsRewardItemFocused and self.HasTab then
      self:ShowGamepadViewBtn(true)
      self:FocusFirstRewardItem()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  EnsureWidgetFocusable(self)
  if self.IsInUIMode then
    self:SetInputUIOnly(true)
  end
  self:SetFocus()
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:MakeGuildQuestConfigData()
  local EventId = GuildCommon.GuildDummyEventId
  local CommonQuestActivity = GuildController:GetModel():GetGuildQuests()
  local DailyType, WeeklyType = "Daily", "Weekly"
  local DailyItems, WeeklyItems = {}, {}
  local HasDailyQuest = false
  if CommonQuestActivity then
    for QuestId, QuestData in pairs(CommonQuestActivity) do
      local RealQuestId = tonumber(QuestId) or QuestId
      local Config = DataMgr.CommonQuestDetail[RealQuestId]
      if Config and Config.EventId == EventId then
        local Item = {
          ItemId = RealQuestId,
          Type = DailyType,
          CanReceive = false,
          RewardsGot = false,
          NotreachText = "UI_Archive_CollectionInProgress",
          Hint = Config.StarterQuestDes and GText(Config.StarterQuestDes) or "Task_" .. tostring(RealQuestId),
          ReceiveButtonText = "UI_Archive_CollectionClaim",
          Num = Config.Target,
          HideProgressAfterGot = true,
          ReceiveCallBack = M.OnGuildQuestGetReward,
          ReceiveParm = {QuestId = RealQuestId, EventId = EventId},
          LeftAligned = false
        }
        local JumpUIId = Config.JumpUIId
        if JumpUIId then
          Item.HasGoto = true
          Item.GotoButtonText = "UI_GameEvent_Goto"
          
          function Item:GotoCallBack(Content)
            PageJumpUtils:JumpToTargetPageByJumpId(JumpUIId)
          end
        end
        Item.CanReceive = QuestData.Progress >= QuestData.Target and not QuestData.RewardsGot
        Item.RewardsGot = QuestData.RewardsGot
        Item.TextProgress = QuestData.Progress .. "/" .. QuestData.Target
        local Rewards = {}
        for _, RewardItemId in ipairs(Config.QuestReward) do
          local RewardInfo = DataMgr.Reward[RewardItemId]
          if RewardInfo then
            local Ids, RewardCount, TableName = RewardInfo.Id or {}, RewardInfo.Count or {}, RewardInfo.Type or {}
            for i = 1, #Ids do
              table.insert(Rewards, {
                ItemType = TableName[i],
                ItemId = Ids[i],
                Count = RewardUtils:GetCount(RewardCount[i]),
                Rarity = ItemUtils.GetItemRarity(Ids[i], TableName[i]),
                bHasGot = Item.RewardsGot
              })
            end
          end
        end
        Item.Rewards = Rewards
        if 2 == Config.QuestType then
          HasDailyQuest = true
          Item.Type = DailyType
          table.insert(DailyItems, Item)
        elseif 3 == Config.QuestType then
          Item.Type = WeeklyType
          table.insert(WeeklyItems, Item)
        end
      end
    end
  end
  table.sort(DailyItems, function(a, b)
    return a.Num < b.Num
  end)
  table.sort(WeeklyItems, function(a, b)
    return a.Num < b.Num
  end)
  local GuildQuestPhaseId = EastSeasonQuestUtils:GetQuestPhaseIdByTabId(EventId, 1)
  local GuildNowNum, GuildNumMax = 0, 0
  if GuildQuestPhaseId then
    GuildNowNum, GuildNumMax = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId, GuildQuestPhaseId)
  end
  
  local function MakeData(Items, Type, HasDaily)
    local bHasCanReceive = false
    for _, Item in ipairs(Items) do
      if Item.CanReceive then
        bHasCanReceive = true
        break
      end
    end
    return {
      ShowIcon = false,
      NowNum = GuildNowNum,
      NumMax = GuildNumMax,
      ReceiveAllCallBack = M.OnGuildQuestGetAllRewards,
      ReceiveAllParam = {EventId = EventId, QuestPhaseId = GuildQuestPhaseId},
      Type = Type,
      SortType = 1,
      Text_Total = "Abyss_RewardList_Title",
      ReceiveButtonText = "UI_Archive_CollectionClaimAll",
      HasDailyQuest = HasDaily,
      Items = Items,
      HasCanReceive = bHasCanReceive,
      TipText = "UI_ActivityFromMemo"
    }
  end
  
  local Now = math.tointeger(TimeUtils.NowTime())
  local NextResetTimestamp = TimeUtils.NextWeeklyRefreshTime(Now)
  local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(math.floor(NextResetTimestamp), math.floor(Now))
  M.WeeklyResetEndTime = NextResetTimestamp
  local Params = {
    ConfigData = {
      TopText = "UI_GuildTaskTab",
      IsExpired = false,
      TimeText = "UI_ResetRemaining",
      RemainTimeDict = RemainTimeDict,
      HasTab = true,
      Type = DailyType,
      Items = {},
      RefreshPanleCallBack = function(Widget)
        if Widget then
          M.RefreshGuildQuestConfigData(Widget)
          Widget:RefreshItems()
        end
      end,
      TabInfo = {
        {
          Title = "UI_DailyTasks",
          Type = DailyType,
          IsShowIcon = true
        },
        {
          Title = "UI_WeeklyTasks",
          Type = WeeklyType,
          IsShowIcon = true
        }
      },
      Datas = {
        [DailyType] = MakeData(DailyItems, DailyType, true),
        [WeeklyType] = MakeData(WeeklyItems, WeeklyType, false)
      }
    }
  }
  local DailyAllDone = true
  for _, Item in ipairs(DailyItems) do
    if not Item.RewardsGot then
      DailyAllDone = false
      break
    end
  end
  if DailyAllDone and #WeeklyItems > 0 then
    Params.ConfigData.Type = WeeklyType
  end
  if HasDailyQuest then
    function Params.ConfigData.DailyRefreshFunc(Widget, RefreshParam)
      if Widget then
        M.RefreshGuildQuestConfigData(Widget)
        
        Widget:RefreshDaily()
      end
    end
  end
  return Params
end

function M.OnGuildQuestGetReward(Widget, Content)
  Content = Content or Widget
  if not (Content and Content.ConfigData) or not Content.ConfigData.ReceiveParm then
    return
  end
  local QuestId = Content.ConfigData.ReceiveParm.QuestId
  GuildController:SendGuildQuestGetReward(QuestId, function(ErrCode, Rewards)
    if not ErrorCode:Check(ErrCode) then
      return
    end
    local Owner = Content.Owner
    if not Owner or not Owner.List_Item then
      return
    end
    M.RefreshGuildQuestConfigData(Owner)
    Owner:RefreshActivityProgress()
    Owner:RefreshBtnGetAll(Owner.HasTab and Owner.ConfigData.Datas[Owner.Type] or Owner.ConfigData)
    if Content.SelfWidget then
      Content.SelfWidget:RefreshItems()
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      Owner.List_Item:SetFocus()
    end, Content.SelfWidget)
  end)
end

function M.OnGuildQuestGetAllRewards(Widget, ReceiveAllParm)
  ReceiveAllParm = ReceiveAllParm or Widget
  if not (ReceiveAllParm and ReceiveAllParm.EventId) or not ReceiveAllParm.SelfWidget then
    return
  end
  local SelfWidget = ReceiveAllParm.SelfWidget
  local ConfigData = SelfWidget.HasTab and SelfWidget.ConfigData.Datas[SelfWidget.Type] or SelfWidget.ConfigData
  if not ConfigData or not ConfigData.Items then
    return
  end
  local QuestIds = {}
  for _, Item in ipairs(ConfigData.Items) do
    local ReceiveParm = not Item.ReceiveParm and Item.ConfigData and Item.ConfigData.ReceiveParm
    if Item.CanReceive and not Item.RewardsGot and ReceiveParm and ReceiveParm.QuestId then
      table.insert(QuestIds, ReceiveParm.QuestId)
    end
  end
  if 0 == #QuestIds then
    return
  end
  
  local function MergeRewards(Rewards, NewRewards)
    if not Rewards then
      return NewRewards
    end
    if not NewRewards then
      return Rewards
    end
    for TypeName, TypeTable in pairs(NewRewards) do
      if Rewards[TypeName] then
        for RewardId, RewardTable in pairs(TypeTable) do
          if Rewards[TypeName][RewardId] then
            for Tag, Num in pairs(RewardTable) do
              Rewards[TypeName][RewardId][Tag] = (Rewards[TypeName][RewardId][Tag] or 0) + Num
            end
          else
            Rewards[TypeName][RewardId] = RewardTable
          end
        end
      else
        Rewards[TypeName] = TypeTable
      end
    end
    return Rewards
  end
  
  local TotalRewards
  
  local function RefreshAfterGet()
    M.RefreshGuildQuestConfigData(SelfWidget)
    SelfWidget:RefreshActivityProgress()
    SelfWidget:RefreshBtnGetAll(SelfWidget.HasTab and SelfWidget.ConfigData.Datas[SelfWidget.Type] or SelfWidget.ConfigData)
    SelfWidget:RefreshItems()
  end
  
  local GetNextReward
  
  function GetNextReward(Index)
    if Index > #QuestIds then
      RefreshAfterGet()
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, TotalRewards, false, function()
      end, SelfWidget)
      return
    end
    GuildController:SendGuildQuestGetReward(QuestIds[Index], function(Ret, Rewards)
      if not ErrorCode:Check(Ret) then
        RefreshAfterGet()
        if TotalRewards then
          UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, TotalRewards, false, function()
          end, SelfWidget)
        end
        return
      end
      TotalRewards = MergeRewards(TotalRewards, Rewards)
      GetNextReward(Index + 1)
    end)
  end
  
  GetNextReward(1)
end

function M.RefreshGuildQuestConfigData(Widget)
  if not Widget.ConfigData.Datas then
    return
  end
  local CommonQuestActivity = GuildController:GetModel():GetGuildQuests()
  if not CommonQuestActivity then
    return
  end
  for _, Data in pairs(Widget.ConfigData.Datas) do
    local bHasCanReceive = false
    for Index = #Data.Items, 1, -1 do
      local Item = Data.Items[Index]
      local QuestData = not Item.ItemId or CommonQuestActivity[Item.ItemId] or CommonQuestActivity[tostring(Item.ItemId)]
      if not QuestData then
        table.remove(Data.Items, Index)
      else
        Item.CanReceive = QuestData.Progress >= QuestData.Target and not QuestData.RewardsGot
        Item.RewardsGot = QuestData.RewardsGot
        Item.TextProgress = QuestData.Progress .. "/" .. QuestData.Target
        if Item.CanReceive then
          bHasCanReceive = true
        end
      end
    end
    Data.HasCanReceive = bHasCanReceive
    local QuestPhaseId = Data.ReceiveAllParam and Data.ReceiveAllParam.QuestPhaseId
    local EventId = Data.ReceiveAllParam and Data.ReceiveAllParam.EventId
    if EventId and QuestPhaseId then
      Data.NowNum, Data.NumMax = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId, QuestPhaseId)
    else
      Data.NowNum, Data.NumMax = 0, 0
    end
  end
  Widget:RefreshTabReddot()
end

function M:RefreshTabReddot()
  if not self.HasTab or not self.TabInfo then
    return
  end
  for Idx, TabItem in ipairs(self.TabInfo) do
    local ListItem = self.List_Tab and self.List_Tab:GetItemAt(Idx - 1)
    if ListItem and ListItem.Entry and ListItem.Entry.Reddot then
      local ReddotNodeName
      if IsGuildBossMode(self) then
        ReddotNodeName = TabItem.ReddotName
      else
        ReddotNodeName = TabItem.Type == "Daily" and DataMgr.ReddotNode.GuildDailyTask.Name or TabItem.Type == "Weekly" and DataMgr.ReddotNode.GuildWeekTask.Name
      end
      local Count = 0
      if ReddotNodeName then
        local Node = ReddotManager.GetTreeNode(ReddotNodeName)
        Count = Node and Node.Count or 0
      end
      if IsGuildBossMode(self) and TabItem.Type == GuildBossRewardUtils.GUILD_TAB_TYPE then
        Count = 0
      end
      ListItem.Entry.Reddot:SetVisibility(Count > 0 and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    end
  end
end

function M:OnGuildWeekActivityReddotChange(NodeName, Count)
  self:RefreshActivityProgress()
end

function M:OnGuildTaskReddotChange(Count, ReddotType, NodeName)
  if not self.HasTab or not self.TabInfo then
    return
  end
  for Idx, TabItem in ipairs(self.TabInfo) do
    local bThisTab = NodeName == DataMgr.ReddotNode.GuildDailyTask.Name and TabItem.Type == "Daily" or NodeName == DataMgr.ReddotNode.GuildWeekTask.Name and TabItem.Type == "Weekly"
    if bThisTab then
      local ListItem = self.List_Tab and self.List_Tab:GetItemAt(Idx - 1)
      if ListItem and ListItem.Entry and ListItem.Entry.Reddot then
        ListItem.Entry.Reddot:SetVisibility(Count > 0 and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
      end
      break
    end
  end
end

function M:OnGuildBossRewardReddotChange()
  if not IsGuildBossMode(self) then
    return
  end
  GuildBossRewardUtils.RefreshGuildBossRewardConfigData(self)
  self:RefreshTabReddot()
  local CurConfig = self.HasTab and self.ConfigData.Datas[self.Type] or self.ConfigData
  if CurConfig then
    self:RefreshBtnGetAll(CurConfig)
  end
end

function M:OnRecvActivityPointReward(RewardBox)
  self:RefreshActivityProgress()
  if RewardBox then
    ClearPendingTabFocusTimers(self)
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardBox, false, function()
      if not IsValid(self) then
        return
      end
      if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        ClearPendingTabFocusTimers(self)
        if self.HasTab then
          self:FocusSelectedTabEntry()
        else
          self:NavigateToFirstDisplayedItem(self.List_Item)
        end
      else
        self:SetFocus()
      end
    end, self)
  end
end

function M:InitActivityProgress()
  self.ActivityRewardItems = {
    self.Reward_01,
    self.Reward_02,
    self.Reward_03,
    self.Reward_04,
    self.Reward_05
  }
  local Config = self:GetGuildActivityRewardConfig()
  for Idx, Item in ipairs(self.ActivityRewardItems) do
    if not IsValid(Item) then
      break
    end
    if Config[Idx] then
      Item.Text_Num:SetText(tostring(Config[Idx].RequiredActiveness))
    end
  end
  if self.Text_ActivityDesc then
    self.Text_ActivityDesc:SetText(GText("UI_WeeklyPersonalActivity"))
  end
  self:RefreshActivityProgress()
end

function M:RefreshActivityProgress()
  local Model = GuildController:GetModel()
  local ActivityLevel = Model:GetGuildActivityLevel()
  local RewardRecord = Model:GetGuildActivityRewardRecord()
  local Config = self:GetGuildActivityRewardConfig()
  local ActivityMax = Config[#Config] and Config[#Config].RequiredActiveness or 0
  if self.Text_Now then
    self.Text_Now:SetText(tostring(ActivityLevel))
  end
  if self.Text_Total then
    self.Text_Total:SetText(tostring(ActivityMax))
  end
  self:UpdateActivityProgressBar(ActivityLevel, Config)
  local bHasUnclaimed = false
  for Idx, Cfg in ipairs(Config) do
    local Item = self.ActivityRewardItems[Idx]
    if not IsValid(Item) then
      break
    end
    Item.ParentUI = self
    Item:Setup(Idx, Cfg.RequiredActiveness, ActivityLevel, RewardRecord[Cfg.RequiredActiveness] ~= nil)
    if not bHasUnclaimed and ActivityLevel >= Cfg.RequiredActiveness and not RewardRecord[Cfg.RequiredActiveness] then
      bHasUnclaimed = true
    end
  end
end

function M:UpdateActivityProgressBar(ActivityLevel, Config)
  if not (IsValid(self.Bar_Progress) and Config) or 0 == #Config then
    if IsValid(self.Bar_Progress) then
      self.Bar_Progress:SetPercent(0)
    end
    return
  end
  local CurActivity = tonumber(ActivityLevel) or 0
  local FirstThreshold = tonumber(Config[1].RequiredActiveness) or 0
  local LastThreshold = tonumber(Config[#Config].RequiredActiveness) or 0
  if 1 == #Config then
    self.Bar_Progress:SetPercent(CurActivity >= FirstThreshold and 1.0 or 0)
    return
  end
  if CurActivity <= FirstThreshold or FirstThreshold >= LastThreshold then
    self.Bar_Progress:SetPercent(0)
    return
  end
  if CurActivity >= LastThreshold then
    self.Bar_Progress:SetPercent(1.0)
    return
  end
  for Idx = 1, #Config - 1 do
    local CurThreshold = tonumber(Config[Idx].RequiredActiveness) or 0
    local NextThreshold = tonumber(Config[Idx + 1].RequiredActiveness) or CurThreshold
    if CurActivity <= NextThreshold then
      local SegmentCapacity = NextThreshold - CurThreshold
      local SegmentPercent = SegmentCapacity > 0 and (CurActivity - CurThreshold) / SegmentCapacity or 0
      self.Bar_Progress:SetPercent((Idx - 1 + SegmentPercent) / (#Config - 1))
      return
    end
  end
  self.Bar_Progress:SetPercent(1.0)
end

function M:GetGuildActivityRewardConfig()
  local Ok, AllConfig = pcall(function()
    return DataMgr.GuildWeekReward
  end)
  if not Ok or not AllConfig then
    return {}
  end
  local PlayerLv = GuildController:GetModel():GetGuildActivityRewardLevel()
  local Result = {}
  for ReqAct, LevelData in pairs(AllConfig) do
    local Cfg = LevelData[PlayerLv] or LevelData[1]
    if Cfg then
      local Item = {}
      for K, V in pairs(Cfg) do
        Item[K] = V
      end
      Item.RequiredActiveness = ReqAct
      Result[#Result + 1] = Item
    end
  end
  table.sort(Result, function(A, B)
    return A.RequiredActiveness < B.RequiredActiveness
  end)
  return Result
end

function M:ShowAllActivityRewardPreview()
  local PlayerLv = GuildController:GetModel():GetGuildActivityRewardLevel()
  local Groups = {}
  local SortedReqActs = {}
  local Config = DataMgr.GuildWeekReward
  for ReqAct, LevelData in pairs(Config) do
    local RewardCfg = LevelData[PlayerLv] or LevelData[1]
    if RewardCfg and RewardCfg.ActivenessReward then
      table.insert(SortedReqActs, ReqAct)
    end
  end
  table.sort(SortedReqActs)
  for _, ReqAct in ipairs(SortedReqActs) do
    local RewardCfg = Config[ReqAct][PlayerLv] or Config[ReqAct][1]
    table.insert(Groups, {
      Title = string.format(GText("UI_GuildActivityTarget"), ReqAct),
      RewardId = RewardCfg.ActivenessReward
    })
  end
  ClearPendingTabFocusTimers(self)
  local Params = {
    Groups = Groups,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.OnActivityRewardPreviewClosed
  }
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(100364, Params, self)
end

function M:OnActivityRewardPreviewClosed()
  self:AddTimer(0.01, function()
    if not IsValid(self) then
      return
    end
    local CurInputType = UIUtils.UtilsGetCurrentInputType()
    if CurInputType == ECommonInputType.Gamepad then
      ClearPendingTabFocusTimers(self)
      if self.HasTab then
        self:FocusSelectedTabEntry()
      else
        self:NavigateToFirstDisplayedItem(self.List_Item)
      end
    else
      self:SetFocus()
    end
  end, false, 0, GuildRewardPreviewCloseRestoreFocusTimerKey, true)
end

function M:OnXButtonClicked()
  if IsGuildBossMode(self) then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm_positive", nil, nil)
    local AvatarBossData = GuildModel:GetAvatarGuildBossData()
    if GuildBossPointRewardUtils.GetCanClaimRewardCount(AvatarBossData) > 0 then
      local Avatar = GWorld:GetAvatar()
      if Avatar and Avatar.GuildBossClaimAllPointReward then
        Avatar:GuildBossClaimAllPointReward(function(RetCode, Info)
          if not ErrorCode:Check(RetCode) then
            return
          end
          GuildBossRewardUtils.RefreshGuildBossRewardConfigData(self)
          GuildBossRewardUtils.RefreshPointRewardBottom(self)
          if Info and Info.Rewards then
            local MergedRewards = {}
            for _, RewardEntry in ipairs(Info.Rewards) do
              if RewardEntry and RewardEntry.Items then
                MergedRewards = SimpleRewardBox.MergeDumpTables(MergedRewards, RewardEntry.Items)
              end
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, MergedRewards, false, nil, self)
          end
        end)
      end
    else
      self:ShowGuildBossPointRewardPreview()
    end
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm_positive", nil, nil)
  local Model = GuildController:GetModel()
  local ActivityLevel = Model:GetGuildActivityLevel()
  local RewardRecord = Model:GetGuildActivityRewardRecord()
  local Config = self:GetGuildActivityRewardConfig()
  local HasActivityRewardToGet = false
  for Idx, Cfg in ipairs(Config) do
    if ActivityLevel >= Cfg.RequiredActiveness and not RewardRecord[Cfg.RequiredActiveness] then
      HasActivityRewardToGet = true
      break
    end
  end
  if HasActivityRewardToGet and GuildController then
    GuildController:SendRpcGetGuildActivityPointReward(-1)
  else
    self:ShowAllActivityRewardPreview()
  end
end

function M:OnReturnKeyDown(...)
  if self.IsRewardItemFocused then
    self:FocusSelectedTabEntry()
  else
    self:CloseSelf()
  end
end

function M:OnConfirmAction()
  if not self.CurrentSelectedItem then
    return
  end
  local DetailItem = self.CurrentSelectedItem.SelfWidget
  if not DetailItem or DetailItem.IsEmpty then
    return
  end
  if DetailItem.CanReceive and DetailItem.Btn_Reward then
    DetailItem.Btn_Reward:OnBtnClicked()
  elseif DetailItem.HasGoto and DetailItem.Btn_Goto then
    DetailItem.Btn_Goto:OnBtnClicked()
  end
end

function M:EnterViewMode()
  if self.IsInViewMode then
    return
  end
  local SelectItem = self.CurrentSelectedItem
  if SelectItem and SelectItem.SelfWidget then
    local DetailItem = SelectItem.SelfWidget
    if DetailItem and not DetailItem.IsEmpty and DetailItem.EnterSelectMode then
      DetailItem:EnterSelectMode()
    end
  end
end

function M:ExitViewMode()
  if not self.IsInViewMode then
    return
  end
  local SelectItem = self.CurrentSelectedItem
  if SelectItem and SelectItem.SelfWidget then
    local DetailItem = SelectItem.SelfWidget
    if DetailItem and not DetailItem.IsEmpty and DetailItem.LeaveSelectMode then
      DetailItem:LeaveSelectMode()
    end
  end
end

return M
