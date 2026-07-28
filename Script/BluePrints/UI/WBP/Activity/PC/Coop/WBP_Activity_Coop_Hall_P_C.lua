require("UnLua")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local View = Class({
  "BluePrints.UI.BP_UIState_C"
})
local CoopModel = require("BluePrints.UI.WBP.Activity.PC.Coop.Model.CoopModel")
local EMCache = require("EMCache.EMCache")

function View:Initialize(Initializer)
  self.RedDotNum = 0
  self.NewNum = 0
  self.bIsFocusable = true
  self.SelectedSubTabIdx = nil
  self.CurFirstTabIdx = nil
  self.IsFiltered = false
  self.bInMobile = false
  self.IsRefreshLock = false
  self.IsInitGamepadBtn = false
  self.CreateRoomLimit = false
  self.GamepadEntrust = nil
  self.CurContent = nil
  self.RoomList = {}
  self.ShowList = {}
  self.ShowRoomNum = 0
  self.IsSelected = false
  self.NextRoomUid = 0
  self.HasMore = false
  self.bOpenSquad = true
  self.SelectedItems = {}
  self.TimerKey = "AsyncCombat_Hall_Refresh"
  self.EventId = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  self.MaxDurationSeconds = DataMgr.AsyncCombatEventConstant.AsyncCombat_RoomDuration.ConstantValue * 60
  self.ReddotNodeName = "AsyncCombatReward"
  self.NewNodeName = "AsyncCombatNew"
end

function View:InitUIInfo(Name, IsInUIMode, EventList, ...)
  local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
  self.IsChat = SystemUIConfig.IsChat
  self.TextWeek:SetText(GText("UI_AsyncCombat_WeeklyRemain"))
  self.BtnCreate.TextCreate:SetText(GText("UI_AsyncCombat_CreateRoom"))
  self.BtnRoom.TextName:SetText(GText("UI_AsyncCombat_FilterRooms"))
  self.CreateReward.TextCreate:SetText(GText("UI_AsyncCombat_ClaimAll"))
  self.EmptyBg.Text_Empty:SetText(GText("UI_AsyncCombat_NoMatchingRooms"))
  self.Text_Preview:SetText(GText("UI_AsyncComcast_Filtered"))
  self.TabItem01:SetShowText(GText("UI_AsyncCombat_All"))
  self.TabItem01:SetIconPath("/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_All.T_Coop_All")
  self.TabItem02:SetShowText(GText("UI_AsyncCombat_Friends"))
  self.TabItem02:SetIconPath("/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_Friend.T_Coop_Friend")
  self.TabItem03:SetShowText(GText("UI_AsyncCombat_Guild"))
  self.TabItem03:SetIconPath("/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_Guild.T_Coop_Guild")
  CoopModel:Init()
  self:InitTable()
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
end

function View:OnLoaded()
  if self.In then
    self:PlayAnimation(self.In)
  end
  self:SetInputUIOnly(true)
  self:InitPlatform()
  self:InitListenEvent()
  self:BindEvents()
  self:AddReddotListen()
  self:RefreshPlayerInfo()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "AsyncCombatHall", nil)
end

function View:IsMobile()
  return CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE
end

function View:InitListenEvent()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function View:InitPlatform()
  local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
  self.bInMobile = "Mobile" == Platform
  self:SetKeyImgShow(false)
end

function View:InitTable(TabId)
  for i = 1, 3 do
    self["TabItem0" .. i]:Update(i, {})
    self["TabItem0" .. i]:SetSwitchOn(false)
  end
  self.WBP_Com_Tab:Init({
    TitleName = GText("UI_AsyncCombat_CombatRoom"),
    Tabs = {
      {
        Text = GText("UI_AsyncCombat_Hall"),
        TabId = 1,
        IconPath = "/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_Lobby.T_Coop_Lobby"
      },
      {
        Text = GText("UI_AsyncCombat_MyRoom"),
        TabId = 2,
        IconPath = "/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_Room.T_Coop_Room",
        ShowRedDotNum = self.RedDotNum
      }
    },
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails")
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
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    PopupInfoHotKey = "SpecialLeft",
    InfoCallback = self.OnClickInfoCallBack,
    StyleName = "TextImage",
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    GetReplyOnBack = function()
      self:SetFocusTargetDelay()
    end
  })
  if not self:IsMobile() then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:InitGamePadTip({
      KeyInfo = {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Menu"}
        },
        Desc = GText("UI_GACHA_DESDETAIL"),
        bAllowForbid = true
      },
      ClickFuncObj = self,
      ClickFunc = self.OnClickInfoCallBack,
      bNeedLongPressInfo = true
    })
  end
  self.WBP_Com_Tab:BindEventOnTabSelected(self, function(_, TabWidget)
    if self.CurFirstTabIdx == TabWidget.Idx then
      return
    end
    self.CurContent = nil
    self.CurFirstTabIdx = TabWidget.Idx
    self:RefreshSiftMain(false)
    self:RefreshSubTabs()
  end)
  self.WBP_Com_Tab:SelectTab(TabId or 1)
end

function View:CloseSelf()
  AudioManager(self):SetEventSoundParam(self, "AsyncCombatHall", {ToEnd = 1})
  CoopModel:Destory()
  EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
  EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  self:Close()
end

function View:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if self:IsMobile() then
    return
  end
  local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.UsingGamepad = false
    self:SetKeyImgShow(false)
  else
    self.UsingGamepad = true
    self:SetKeyImgShow(true)
    self:RefreshMainTabKeyInfo()
  end
  if self.WBP_Com_Tab and self.WBP_Com_Tab.Group_Chat then
    local Chat = self.WBP_Com_Tab.Group_Chat:GetChildAt(0)
    Chat:HideWSKey(self.UsingGamepad)
  end
  self:InitHintGamepadBtn()
  if UIUtils.HasAnyFocus(self) then
    self:SetFocusTargetDelay()
  end
end

function View:SetKeyImgShow(IsShow)
  if IsShow then
    self.BtnRoom.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Visible)
    self.BtnRe.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Visible)
    self.BtnCreate.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Visible)
    self.CreateReward.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.BtnRoom.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BtnRe.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BtnCreate.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.CreateReward.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
  if self:IsMobile() then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    if not UIManager(self):GetUIObj("CommonDialog") then
      IsEventHandled = true
      self:CloseSelf()
    end
  elseif InKeyName == UE4.EKeys.A.KeyName then
    IsEventHandled = true
    self:TabToLeft()
  elseif InKeyName == UE4.EKeys.D.KeyName then
    IsEventHandled = true
    self:TabToRight()
  elseif "SpaceBar" == InKeyName then
    if 2 == self.CurFirstTabIdx and 1 == self.SelectedSubTabIdx then
      IsEventHandled = true
      self:OnBtnRewardClicked()
    end
  elseif "Gamepad_Special_Right" == InKeyName then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:OnGamePadTipPressed()
    IsEventHandled = true
  else
    IsEventHandled = self.WBP_Com_Tab:Handle_KeyEventOnPC(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function View:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if self.IsOpenTips then
    return IsEventHandled
  end
  if "Gamepad_LeftTrigger" == InKeyName then
    IsEventHandled = true
    self:TabToLeft()
  elseif "Gamepad_RightTrigger" == InKeyName then
    IsEventHandled = true
    self:TabToRight()
  elseif "Gamepad_RightThumbstick" == InKeyName then
    IsEventHandled = true
    self:OnBtnReClicked()
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    IsEventHandled = true
    self:OnBtnCreateClicked()
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    IsEventHandled = true
    self:OnBtnRewardClicked()
  elseif "Gamepad_FaceButton_Bottom" == InKeyName then
    if self.CurContent and self.CurContent.Widget and not self.CurContent.IsEmpty then
      IsEventHandled = true
      self.CurContent.Widget:OnFaceButtonBottomClick()
    else
      IsEventHandled = false
    end
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    if self.CurContent and self.CurContent.Widget and not self.CurContent.IsEmpty then
      IsEventHandled = true
      self.CurContent.Widget.Icon.WBP_Com_ItemIcon:OnMouseButtonUp()
    else
      IsEventHandled = false
    end
  elseif "Gamepad_Special_Right" == InKeyName then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:OnGamePadTipPressed()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
  else
    IsEventHandled = self.WBP_Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
  end
  return IsEventHandled
end

function View:OnKeyUp(MyGeometry, InKeyEvent)
  if self:IsMobile() then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadUp(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function View:OnGamePadUp(InKeyName)
  local IsEventHandled = false
  if self.IsOpenTips then
    EventManager:FireEvent(EventID.InterruptChatView)
    return true
  end
  if InKeyName == Const.GamepadSpecialLeft then
    if self.IsChat then
      EventManager:FireEvent(EventID.InterruptChatView)
    end
    self:OnRoomFilterClicked()
    IsEventHandled = true
  elseif InKeyName == Const.GamepadSpecialRight then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:OnGamePadTipReleased()
    if self.bOpenSquad then
      IsEventHandled = true
      self.bOpenSquad = false
    elseif self.bRecoverHandleUp then
      self.bOpenSquad = true
      self.bRecoverHandleUp = false
    end
  end
  return IsEventHandled
end

function View:MenuOpenChanged(bIsOpen)
  self.IsOpenTips = bIsOpen
  self:SetKeyImgShow(not self.IsOpenTips)
  if self.UsingGamepad then
    self.WBP_Com_Tab:SetBottomKeyInfoVisible(not self.IsOpenTips)
    self.WBP_Com_Tab:UpdateUIStyleInPlatform(not self.IsOpenTips)
    local Visibility = self.IsOpenTips and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(Visibility)
    if self.WBP_Com_Tab and self.WBP_Com_Tab.Group_Chat then
      local Chat = self.WBP_Com_Tab.Group_Chat:GetChildAt(0)
      Chat:HideWSKey(not self.IsOpenTips)
    end
  end
end

function View:OnFocusReceived(MyGeometry, InFocusEvent)
  local Create = UIManager(self):GetUIObj("CoopCreate")
  if Create then
    Create:SetFocus()
    return UIUtils.Handled
  end
  if not self:IsMobile() then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:OnGamePadTipReleased()
  end
  if self.IsChat then
    EventManager:FireEvent(EventID.InterruptChatView)
  end
  self.bRecoverHandleUp = true
  self:SetFocusTarget()
  return UIUtils.Handled
end

function View:SetFocusTargetDelay()
  if not self.UsingGamepad then
    self.CurContent = nil
    return
  end
  self:AddTimer(0.1, function()
    local CoopCreate = UIManager(self):GetUIObj("CoopCreate")
    if not CoopCreate then
      self:SetFocusFirstListItem()
    end
  end, nil, nil, "AsyncCombatDelaySetFocusTarget", true)
end

function View:SetFocusFirstListItem()
  if self.UsingGamepad then
    if self.Dialog and IsValid(self.Dialog) then
      self.Dialog:SetFocus()
      return
    end
    local Content = self.ListRoom:GetItemAt(0)
    if Content and IsValid(self.GameInputModeSubsystem) then
      DebugPrint("HALLPAGE :SetFocusTarget()")
      self.CurContent = Content
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(Content.Widget)
      self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
  end
end

function View:SetFocusTarget()
  if self.UsingGamepad then
    if self.Dialog and IsValid(self.Dialog) then
      self.Dialog:SetFocus()
      return
    end
    if IsValid(self.CurContent) and IsValid(self.GameInputModeSubsystem) then
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.CurContent.Widget)
      self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
      return
    end
    local Content = self.ListRoom:GetItemAt(0)
    if Content and IsValid(self.GameInputModeSubsystem) then
      DebugPrint("HALLPAGE :SetFocusTarget()")
      self.CurContent = Content
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(Content.Widget)
      self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
  end
end

function View:ReceiveEnterState(StackAction)
  View.Super.ReceiveEnterState(self, StackAction)
end

function View:OnItemHoveredChanged(Content, IsHover)
  if not IsValid(Content) then
    return
  end
  if Content.IsEmpty then
    return
  end
  if IsHover then
    if IsValid(self.CurContent) and self.CurContent.Widget and self.CurContent ~= Content then
      self.CurContent.Widget:SetUsingGamepad(false)
    end
    self.CurContent = Content
  end
  if IsValid(Content.Widget) then
    Content.Widget:SetUsingGamepad(self.UsingGamepad and IsHover)
  end
end

function View:InitKeyInfo()
  if self.IsInitGamepadBtn then
    return
  end
  if self:IsMobile() then
    return
  end
  self.BtnCreate.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.CreateReward.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.BtnRe.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RS"}
    },
    bAllowForbid = true
  })
  self.BtnRoom.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    },
    bAllowForbid = true
  })
  self.KeyLeftText:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = UE4.EKeys.A.KeyName
      }
    },
    bAllowForbid = true
  })
  self.KeyRIghtText:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = UE4.EKeys.D.KeyName
      }
    },
    bAllowForbid = true
  })
  self.KeyLeftImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LT"}
    },
    bAllowForbid = true
  })
  self.KeyRIghtImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RT"}
    },
    bAllowForbid = true
  })
  self.IsInitGamepadBtn = true
end

function View:InitHintGamepadBtn()
  if self:IsMobile() then
    return
  end
  self:InitKeyInfo()
  if self.UsingGamepad == false then
    self.Ws_LeftKey:SetActiveWidgetIndex(1)
    self.Ws_RightKey:SetActiveWidgetIndex(1)
  else
    self.Ws_LeftKey:SetActiveWidgetIndex(0)
    self.Ws_RightKey:SetActiveWidgetIndex(0)
  end
end

function View:TabToLeft()
  if self.SelectedSubTabIdx and self.SelectedSubTabIdx - 1 >= 1 then
    self:SelectListChange(self.SelectedSubTabIdx - 1)
  end
end

function View:TabToRight()
  local maxNum = 1 == self.CurFirstTabIdx and 3 or 2
  if self.SelectedSubTabIdx and maxNum >= self.SelectedSubTabIdx + 1 then
    self:SelectListChange(self.SelectedSubTabIdx + 1)
  end
end

function View:Destruct()
  ActivityReddotHelper.RemoveReddotListenByEventId(self.EventId, self)
  EventManager:RemoveEvent("AsyncCombatRoomEnd", self)
  EventManager:RemoveEvent(EventID.OnWeeklyRefresh, self)
  self.ListRoom.OnListViewScrolled:Clear()
end

function View:BindEvents()
  self.BtnRe.Btn.OnClicked:Add(self, self.OnBtnReClicked)
  for i = 1, 3 do
    local index = i
    self["TabItem0" .. i].Btn_Click.OnClicked:Add(self, function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
      self:SelectListChange(index)
    end)
  end
  self.BtnRoom.Btn.OnClicked:Add(self, self.OnRoomFilterClicked)
  self.BtnCreate.Btn.OnClicked:Add(self, self.OnBtnCreateClicked)
  self.CreateReward.Btn.OnClicked:Add(self, self.OnBtnRewardClicked)
  self.ListRoom.BP_OnItemIsHoveredChanged:Add(self, self.OnItemHoveredChanged)
  EventManager:AddEvent(EventID.OnWeeklyRefresh, self, self.RefreshWeekly)
  EventManager:AddEvent("AsyncCombatRoomEnd", self, self.RefreshRoomEnd)
  self.ListRoom.OnListViewScrolled:Add(self, self._OnListItemScrolled)
  self.ListRoom.OnCreateEmptyContent:Bind(self, function()
    return self:CreateEmptyItem()
  end)
end

function View:CreateEmptyItem()
  local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
  EmptyContent.IsEmpty = true
  return EmptyContent
end

function View:OnClickInfoCallBack()
  local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
  UIManager(self):ShowCommonPopupUI(SystemUIConfig.PopupInfoId)
end

function View:OnBtnReClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_large_confirm_click", nil, nil)
  if self.IsRefreshLock == true then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_ClickTooFast"))
    return
  end
  self.NextRoomUid = 0
  self:AddTimer(1, function()
    self.IsRefreshLock = false
  end, false, 0, self.TimerKey)
  self.IsRefreshLock = true
  self.SelectedSubTabIdx = self.SelectedSubTabIdx or 1
  self:SelectListChange(self.SelectedSubTabIdx, true)
  self:RefreshPlayerInfo()
end

function View:OnBtnCreateClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_large_confirm_click", nil, nil)
  local NodeName = self.NewNodeName
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNode(NodeName)
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if CacheDetail and CacheDetail.New and CacheDetail.New >= 1 then
    ReddotManager.DecreaseLeafNodeCount(NodeName, 1, {CacheKey = "New"})
    EMCache:Set("AsyncCombatBtnTime", TimeUtils.NowTime(), true)
  end
  if self.CreateRoomLimit == true then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_HostLimitExceeded"))
    return
  end
  local UI = UIManager(self):LoadUINew("CoopCreate")
  if UI then
    UI:Init(self)
  end
end

local IconPathFiltered = "/Game/UI/UI_PNG_Static/Atlas/Common/Common_Filter02.Common_Filter02"
local IconPathUnFiltered = "/Game/UI/UI_PNG_Static/Atlas/Common/Common_Filter.Common_Filter"

function View:GetRoomFilterData()
  local RoomDatas = {}
  local RewardIdList = CoopModel:GetAsyncCombatRoomRewardIdList()
  local item1 = {}
  item1.Title = "UI_AsyncCombat_SelectReward"
  item1.HasSelectAll = true
  item1.SelectionDatas = {}
  item1.SelectionText = {}
  item1.IconPaths = {}
  item1.ShowItemIcon = true
  for _, RewardId in pairs(RewardIdList) do
    local RewardData = DataMgr.Resource[RewardId]
    table.insert(item1.SelectionDatas, RewardId)
    table.insert(item1.SelectionText, RewardData.ResourceName)
    table.insert(item1.IconPaths, RewardData.Icon)
  end
  table.insert(RoomDatas, item1)
  local LevelIdList = CoopModel:GetAsyncCombatRoomLevelList()
  local item2 = {}
  item2.Title = "UI_AsyncCombat_SelectDifficulty"
  item2.HasSelectAll = true
  item2.SelectionDatas = {}
  item2.SelectionText = {}
  for _, Level in pairs(LevelIdList) do
    table.insert(item2.SelectionDatas, Level)
    table.insert(item2.SelectionText, string.format("Lv.%d", Level))
  end
  table.insert(RoomDatas, item2)
  local TicketTable = CoopModel:GetAsyncCombatDifficultyList()
  local item3 = {}
  item3.Title = "UI_AsyncCombat_SelectRate"
  item3.HasSelectAll = true
  item3.SelectionDatas = {}
  item3.SelectionText = {}
  for _, value in pairs(TicketTable) do
    local RateResData = DataMgr.Resource[value]
    table.insert(item3.SelectionText, string.format("+%d%%", RateResData.UseParam / 100))
    table.insert(item3.SelectionDatas, value)
  end
  table.insert(RoomDatas, item3)
  return RoomDatas
end

function View:OnRoomFilterClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_common_click", nil, nil)
  local KeyInfoList = {
    [1] = {
      KeyInfoList = {
        {
          Type = "Img",
          ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("RS", self.CurGamepadName)
        }
      },
      Desc = GText("UI_Controller_CheckDetails")
    },
    [2] = {
      KeyInfoList = {
        {
          Type = "Img",
          ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("A", self.CurGamepadName)
        }
      },
      Desc = GText("UI_RougeLike_BlessingConfirm") .. "/" .. GText("UI_PATCH_CANCEL")
    },
    [3] = {
      KeyInfoList = {
        {
          Type = "Img",
          ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("B", self.CurGamepadName)
        }
      },
      Desc = GText("UI_Controller_Close")
    }
  }
  local Params = {
    ShowParamsKeyInfoList = KeyInfoList,
    ParentWidget = self,
    ItemDatas = self:GetRoomFilterData(),
    DontCloseWhenLeftBtnClicked = true,
    RightGamepadKey = EKeys.X.KeyName,
    RightGamepadImg = EKeys.X.KeyName,
    LeftGamepadKey = EKeys.Y.KeyName,
    LeftGamepadImg = EKeys.Y.KeyName,
    CloseBtnCallbackFunction = function()
      self.Dialog = nil
      self:SetFocusTarget()
    end,
    OnConfirmCallback = function(ItemUI, DialogObj, SelectedItems, ItemDatas)
      self.Dialog = nil
      self:OnSiftBoxConfirmed(ItemUI, SelectedItems, ItemDatas)
    end,
    ReselectionCallback = function(SiftBox)
      if self.IsSelected then
        local items = self.SelectedItems
        if items[1] and next(items[1]) then
          for key, id in pairs(items[1]) do
            items[1][key] = CoopModel:GetAsyncCombatRoomRewardIndex(id)
          end
        end
        SiftBox:Reselection(items)
      end
    end
  }
  self.Dialog = UIManager(self):ShowCommonPopupUI(100129, Params, self)
  self.Dialog:SetFocus()
end

function View:OnBtnRewardClicked(RoomUniqueId)
  if 2 ~= self.CurFirstTabIdx then
    return
  end
  if self.ShowList and 0 == #self.ShowList then
    return
  end
  local RewardRoomIDs = {}
  if nil ~= RoomUniqueId then
    table.insert(RewardRoomIDs, RoomUniqueId)
  else
    for _, roomData in ipairs(self.ShowList) do
      if roomData.IsPass and 1 == roomData.RewardState then
        table.insert(RewardRoomIDs, roomData.RoomUniqueId)
      end
    end
  end
  if 0 == #RewardRoomIDs then
    return
  end
  CoopModel:AsyncCombatClaimReward(RewardRoomIDs, function(Err, AllRewards)
    if Err == ErrorCode.RET_SUCCESS then
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, AllRewards, false, nil, self, false)
      self:RefreshList()
      self:RefreshPlayerInfo()
      ReddotManager.DecreaseLeafNodeCount(self.ReddotNodeName, #RewardRoomIDs, {
        CacheKey = "Red",
        EventId = self.EventId
      })
    end
  end)
end

function View:GoToRoomDetail(RoomUniId)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_small_click", nil, nil)
  self:BlockAllUIInput(true, "AsyncCombatGetRoomInfo")
  CoopModel:AsyncGetMemberRoomInfo(function(Err, RoomData)
    self:BlockAllUIInput(false, "AsyncCombatGetRoomInfo")
    if Err == ErrorCode.RET_SUCCESS then
      local Detail = UIManager(self):LoadUINew("CoopDetails", RoomData, false)
      if Detail then
        Detail:InitPageTab()
        Detail:Init(RoomData)
      end
    elseif Err == ErrorCode.RET_ASYNCCOMBAT_CANT_FIND_ROOM then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomEndedRefresh"))
    end
  end, RoomUniId)
end

function View:CheckRewardIsSelected(RoomCfgID)
  local SelectedItems = self.SelectedItems
  if SelectedItems and SelectedItems[1] then
    for _, id in ipairs(SelectedItems[1]) do
      if RoomCfgID == id then
        return true
      end
    end
    return false
  end
  return true
end

function View:CheckLevelIsSelected(RoomCfgLevel)
  local SelectedItems = self.SelectedItems
  local LevelIdList = CoopModel:GetAsyncCombatRoomLevelList()
  if SelectedItems and SelectedItems[2] then
    for _, idx in pairs(SelectedItems[2]) do
      if RoomCfgLevel == LevelIdList[idx] then
        return true
      end
    end
    return false
  end
  return true
end

function View:CheckDifficultyIsSelected(RoomCfgRatResId)
  local SelectedItems = self.SelectedItems
  local TicketTable = CoopModel:GetAsyncCombatDifficultyList()
  if SelectedItems and SelectedItems[3] then
    for _, idx in pairs(SelectedItems[3]) do
      if RoomCfgRatResId == TicketTable[idx] then
        return true
      end
    end
    return false
  end
  return true
end

function View:CheckRoomIsEnd(roomData)
  if roomData.IsPass and roomData.RewardState and 1 ~= roomData.RewardState then
    return true
  end
  local CreateTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(roomData.CreateTime or 0)
  local CurTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
  local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(CurTime, CreateTime)
  local elapsedSeconds = UKismetMathLibrary.GetTotalSeconds(RemainTime)
  if elapsedSeconds >= self.MaxDurationSeconds then
    return 1 ~= roomData.RewardState
  end
  return false
end

function View:SiftShowListByListData(RoomList)
  local SiftedRoomList = {}
  for _, roomData in ipairs(RoomList) do
    local flag = true
    if 2 == self.CurFirstTabIdx then
      if self:CheckRoomIsEnd(roomData) then
        if 1 == self.SelectedSubTabIdx then
          flag = false
        end
      elseif 2 == self.SelectedSubTabIdx then
        flag = false
      end
    end
    if flag then
      local RoomCfg = DataMgr.AsyncCombat[roomData.RoomConfId]
      if self:CheckRewardIsSelected(RoomCfg.ID) and self:CheckLevelIsSelected(RoomCfg.Level) and self:CheckDifficultyIsSelected(roomData.RateResId) then
        table.insert(SiftedRoomList, roomData)
      end
    end
  end
  return SiftedRoomList
end

function View:OnSiftBoxConfirmed(ItemUI, SelectedItems, ItemDatas)
  local RoomList = self.RoomList
  self.SelectedItems = SelectedItems
  if not SelectedItems or next(SelectedItems) == nil then
    self:RefreshSiftMain(false)
    self:SelectInSecondTab(RoomList)
    return
  end
  self:RefreshSiftMain(true)
  local SiftedRoomList = self:SiftShowListByListData(RoomList)
  self:RefreshShowList(SiftedRoomList)
end

function View:SelectInSecondTab(RoomList)
  if 2 ~= self.CurFirstTabIdx then
    self:RefreshShowList(RoomList)
    return
  end
  local retRoomList = {}
  for _, roomData in ipairs(RoomList) do
    local flag = true
    if 2 == self.CurFirstTabIdx then
      if self:CheckRoomIsEnd(roomData) then
        if 1 == self.SelectedSubTabIdx then
          flag = false
        end
      elseif 2 == self.SelectedSubTabIdx then
        flag = false
      end
    end
    if flag then
      table.insert(retRoomList, roomData)
    end
  end
  self:RefreshShowList(retRoomList)
end

function View:SelectListChange(selectIndex, isForce)
  if isForce then
    if self.SelectedSubTabIdx then
      self["TabItem0" .. self.SelectedSubTabIdx]:SetSwitchOn(false)
    end
    self.SelectedSubTabIdx = selectIndex
    self:RefreshMainTabKeyInfo()
    self["TabItem0" .. selectIndex]:SetSwitchOn(true)
    self:ResetRoomListData()
    self:RefreshList()
    return
  end
  if self.SelectedSubTabIdx == selectIndex then
    self["TabItem0" .. selectIndex]:SetSwitchOn(true)
    return
  end
  if self.SelectedSubTabIdx then
    self["TabItem0" .. self.SelectedSubTabIdx]:SetSwitchOn(false)
  end
  self.SelectedSubTabIdx = selectIndex
  self:RefreshMainTabKeyInfo()
  self["TabItem0" .. selectIndex]:SetSwitchOn(true)
  self:ResetRoomListData()
  self:RefreshList()
end

function View:RefreshSubTabs()
  self:ResetCurContent()
  self.TabItem01:SetVisibility(UE4.ESlateVisibility.Visible)
  self.TabItem02:SetVisibility(UE4.ESlateVisibility.Visible)
  self.TabItem03:SetVisibility(1 == self.CurFirstTabIdx and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
  if 1 == self.CurFirstTabIdx then
    self.TabItem01:SetShowText(GText("UI_AsyncCombat_All"))
    self.TabItem01:SetIconPath("/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_All.T_Coop_All")
    self.TabItem02:SetShowText(GText("UI_AsyncCombat_Friends"))
    self.TabItem02:SetIconPath("/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_Friend.T_Coop_Friend")
    self.TabItem03:SetShowText(GText("UI_AsyncCombat_Guild"))
    self.TabItem03:SetIconPath("/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_Guild.T_Coop_Guild")
  elseif 2 == self.CurFirstTabIdx then
    self:ResetRoomListData()
    self.TabItem01:SetShowText(GText("UI_AsyncCombat_InProgress"))
    self.TabItem01:SetIconPath("/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_In.T_Coop_In")
    self.TabItem02:SetShowText(GText("UI_AsyncCombat_Finished"))
    self.TabItem02:SetIconPath("/Game/UI/Texture/Dynamic/Atlas/Coop/T_Coop_End.T_Coop_End")
  end
  self:RefreshFirstTabRedDot(self.NewNum, self.RedDotNum)
  self:RefreshSubTabRedDot(self.NewNum, self.RedDotNum)
  self:SelectListChange(1, true)
end

function View:ResetCurContent()
  if IsValid(self.CurContent) and IsValid(self.CurContent.Widget) then
    self.CurContent.Widget:SetUsingGamepad(false)
  end
  self.CurContent = nil
end

function View:RefreshList()
  self.ListRoom:ClearListItems()
  self.CreateReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if 1 == self.CurFirstTabIdx then
    local permission = self.SelectedSubTabIdx or 1
    CoopModel:AsyncCombatGetRoomList(permission, self.NextRoomUid, function(Err, RoomList)
      if Err ~= ErrorCode.RET_SUCCESS then
        return
      end
      if 1 ~= self.CurFirstTabIdx then
        return
      end
      self.RoomList = RoomList.Rooms
      self.NextRoomUid = RoomList.NextRoomUid
      self.HasMore = RoomList.HasMore
      self:SiftShowList(self.RoomList)
    end)
  elseif 2 == self.CurFirstTabIdx then
    CoopModel:AsyncCombatGetOwnedRoom(function(Err, RoomList)
      if Err ~= ErrorCode.RET_SUCCESS then
        return
      end
      if 2 ~= self.CurFirstTabIdx then
        return
      end
      self.RoomList = RoomList
      local RewardCount = 0
      local ShowList = {}
      local MaxDurationSeconds = self.MaxDurationSeconds
      for _, roomData in ipairs(RoomList) do
        if roomData.IsPass == false then
          local CreateTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(roomData.CreateTime or 0)
          local CurTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
          local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(CurTime, CreateTime)
          local elapsedSeconds = UKismetMathLibrary.GetTotalSeconds(RemainTime)
          local IsRoomTimeDown = false
          if MaxDurationSeconds <= elapsedSeconds then
            IsRoomTimeDown = true
          end
          if 1 == self.SelectedSubTabIdx then
            if false == IsRoomTimeDown then
              table.insert(ShowList, roomData)
            elseif true == IsRoomTimeDown and 1 == roomData.RewardState then
              table.insert(ShowList, roomData)
              RewardCount = RewardCount + 1
            end
          elseif 2 == self.SelectedSubTabIdx and true == IsRoomTimeDown and 1 ~= roomData.RewardState then
            table.insert(ShowList, roomData)
          end
        elseif roomData.IsPass == true then
          if 1 == self.SelectedSubTabIdx then
            if 1 == roomData.RewardState then
              table.insert(ShowList, roomData)
              RewardCount = RewardCount + 1
            end
          elseif 2 == self.SelectedSubTabIdx and 1 ~= roomData.RewardState then
            table.insert(ShowList, roomData)
          end
        end
      end
      if RewardCount > 0 then
        if self.RedDotNum and 0 == self.RedDotNum then
          ReddotManager.ClearLeafNodeCount(self.ReddotNodeName, true, {CacheKey = "Red"})
          ReddotManager.IncreaseLeafNodeCount(self.ReddotNodeName, RewardCount, {CacheKey = "Red"})
        end
        self.CreateReward:SetVisibility(UE4.ESlateVisibility.Visible)
      else
        self.CreateReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
      self:SiftShowList(ShowList)
    end)
  end
end

function View:ResetRoomListData(NextRoomUid, HasMore)
  self.NextRoomUid = NextRoomUid or 0
  self.HasMore = HasMore or false
end

function View:_OnListItemScrolled(ItemOffset, DistanceRemaining)
  if not self.HasMore then
    return
  end
  if not self.CurFirstTabIdx then
    return
  end
  if 1 ~= self.CurFirstTabIdx then
    return
  end
  if self.HasMore == false then
    return
  end
  if self.IsSend then
    return
  end
  if DistanceRemaining <= 0.01 and self.HasMore == true then
    if not self.NextRoomUid then
      self.NextRoomUid = 0
    end
    self.IsSend = true
    local permission = self.SelectedSubTabIdx or 1
    CoopModel:AsyncCombatGetRoomList(permission, self.NextRoomUid, function(Err, RoomList)
      if Err ~= ErrorCode.RET_SUCCESS then
        return
      end
      self.IsSend = false
      if 1 ~= self.CurFirstTabIdx then
        return
      end
      self.NextRoomUid = RoomList.NextRoomUid
      self.HasMore = RoomList.HasMore
      self:AddRoomListToShowList(RoomList.Rooms)
    end)
  end
end

function View:AddRoomListToShowList(RoomList)
  for _, roomData in ipairs(RoomList) do
    table.insert(self.RoomList, roomData)
  end
  local SelectedItems = self.SelectedItems
  if not SelectedItems or next(SelectedItems) == nil then
    self:RefreshSiftMain(false)
    self:RefreshShowList(RoomList, true)
    return
  end
  local SiftedRoomList = self:SiftShowListByListData(RoomList)
  self:RefreshShowList(SiftedRoomList, true)
end

function View:SiftShowList(RoomList, IsAdd)
  if self.IsSelected == true then
    self:OnSiftBoxConfirmed(nil, self.SelectedItems, nil)
  else
    self:RefreshSiftMain(false)
    self:RefreshShowList(RoomList)
  end
end

function View:RefreshSiftMain(IsSelected)
  self.IsSelected = IsSelected
  if self.IsSelected then
    self.Main:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.Main:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function View:RefreshShowList(ShowList, IsAdd)
  IsAdd = IsAdd or false
  if false == IsAdd then
    self.ListRoom:ClearListItems()
    self.ShowList = ShowList
    if 0 == #ShowList then
      self.CreateReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Ws_Content:SetActiveWidgetIndex(1)
      self.CurContent = nil
      self:PlayAnimation(self.Change)
      if self.UsingGamepad and self.GameInputModeSubsystem then
        self:SetFocus()
      end
      return
    end
  end
  self.Ws_Content:SetActiveWidgetIndex(0)
  table.sort(ShowList, function(a, b)
    if a.RateResId ~= b.RateResId then
      return a.RateResId > b.RateResId
    end
    if a.Progress ~= b.Progress then
      return a.RateResId < b.RateResId
    end
    if a.Level ~= b.Level then
      return a.Level > b.Level
    end
    if a.MemberCount ~= b.MemberCount then
      return a.MemberCount < b.MemberCount
    end
    if a.CreateTime ~= b.CreateTime then
      return a.CreateTime > b.CreateTime
    end
    return a.RoomUniqueId > b.RoomUniqueId
  end)
  local RewardCount = 0
  for Index, roomData in ipairs(ShowList) do
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.Index = Index
    ItemContent.RoomData = roomData
    if 2 == self.CurFirstTabIdx and 1 == roomData.RewardState then
      RewardCount = RewardCount + 1
    end
    ItemContent.ParentWidget = self
    ItemContent.UsingGamepad = self.UsingGamepad
    ItemContent.CoopModel = CoopModel
    ItemContent.ReddotNodeName = self.ReddotNodeName
    
    function ItemContent.JoinRoomCallback(RoomUniId)
      self:GoToRoomDetail(RoomUniId)
    end
    
    self.ListRoom:AddItem(ItemContent)
  end
  if RewardCount > 0 then
    self.CreateReward:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.CreateReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:AddTimer(0.01, function()
    self.ListRoom:RequestFillEmptyContent()
  end, nil, nil, "ListRoomRequestFillEmptyContent", true)
  if false == IsAdd then
    self.ShowRoomNum = #ShowList
    self:PlayAnimation(self.Change)
  else
    self.ShowRoomNum = self.ShowRoomNum + #ShowList
  end
  self:ResetCurContent()
  self:SetFocusTargetDelay()
end

function View:RefreshWeekly()
  ActivityReddotHelper.RefreshReddotNode(self.EventId)
  self:RefreshPlayerInfo()
end

function View:RefreshRoomEnd(RoomUniId, IsPass, RewardState)
  local numItems = self.ListRoom:GetNumItems()
  for i = 0, numItems - 1 do
    local Content = self.ListRoom:GetItemAt(i)
    if IsValid(Content) and not Content.IsEmpty and Content.Widget then
      Content.Widget:RefreshRoomData(RoomUniId, IsPass, RewardState)
    end
  end
end

function View:RefreshPlayerInfo()
  local WeekLimit = DataMgr.AsyncCombatEventConstant.AsyncCombat_WeeklyLimit.ConstantValue
  local CurrentNum = WeekLimit - CoopModel:AsyncCombatGetPlayerInfo()
  if 0 == CurrentNum then
    self.CreateRoomLimit = true
    self.BtnCreate.Btn:SetForbidden(true)
    self.TextNum:SetText(string.format("<Highlight>%d</>/%d", CurrentNum, WeekLimit))
  else
    self.CreateRoomLimit = false
    self.BtnCreate.Btn:SetForbidden(false)
    self.TextNum:SetText(string.format("%d/%d", CurrentNum, WeekLimit))
  end
  local CurrentJoinRoomNum, LimitNum = CoopModel:AsyncCombatGetGoingRoomNum()
  local NumText = string.format("：%d/%d", CurrentJoinRoomNum, LimitNum)
  if CurrentJoinRoomNum == LimitNum then
    NumText = string.format(GText("：<Highlight>%d</>/%d"), CurrentJoinRoomNum, LimitNum)
  end
  if self:IsMobile() then
    local SubTitle = UIManager(self):_CreateWidgetNew("AsyncCoopSubTitle")
    SubTitle.TextSubtitle:SetText(GText("UI_AsyncCombat_JoinLimit") .. NumText)
    if self.WBP_Com_Tab.Pos_Subtitle then
      self.WBP_Com_Tab.Pos_Subtitle:ClearChildren()
      self.WBP_Com_Tab.Pos_Subtitle:AddChildToOverlay(SubTitle)
    end
  else
    self.WBP_Com_Tab.Text_Gift_Shop_TabTips:SetText(GText("UI_AsyncCombat_JoinLimit") .. NumText)
    self.WBP_Com_Tab.Text_Gift_Shop_TabTips:SetVisibility(ESlateVisibility.HitTestInvisible)
  end
end

function View:AddReddotListen()
  ActivityReddotHelper.AddReddotListenByTabId(self.EventId, {
    Obj = self,
    Func = function(self, Count, RdType, RdName)
      local RedDotCacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotNodeName) or {}
      local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.NewNodeName) or {}
      self:RefreshFirstTabRedDot(NewCacheDetail.New, RedDotCacheDetail.Red)
      self:RefreshSubTabRedDot(NewCacheDetail.New, RedDotCacheDetail.Red)
    end
  })
end

function View:RefreshFirstTabRedDot(NewNum, RedDotNum)
  if NewNum and NewNum >= 1 then
    self.BtnCreate.New:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.BtnCreate.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if RedDotNum and RedDotNum >= 1 then
    self.WBP_Com_Tab:ShowTabRedDotByTabId(2, false, true, false)
  else
    self.WBP_Com_Tab:ShowTabRedDotByTabId(2, false, false, false)
  end
end

function View:RefreshSubTabRedDot(NewNum, RedDotNum)
  RedDotNum = RedDotNum or 0
  NewNum = NewNum or 0
  self.RedDotNum = RedDotNum
  self.NewNum = NewNum
  if 2 == self.CurFirstTabIdx then
    if RedDotNum > 0 then
      self.TabItem01.Reddot:SetVisibility(UE4.ESlateVisibility.Visible)
      self.TabItem01.Reddot:SetReddotStyle(0)
      self.CreateReward:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.TabItem01.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.CreateReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  else
    self.TabItem01.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:RefreshMainTabKeyInfo()
end

function View:RefreshMainTabKeyInfo()
  if self:IsMobile() then
    return
  end
  if 1 == self.CurFirstTabIdx then
    self.WBP_Com_Tab:UpdateBottomKeyInfo({
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "LS",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails")
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
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    })
  else
    local KeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "LS",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails")
      }
    }
    if 1 == self.SelectedSubTabIdx and self.RedDotNum and self.RedDotNum > 0 then
      table.insert(KeyInfo, {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Space",
            ClickCallback = self.CloseSelf,
            Owner = self
          },
          Desc = GText("UI_AsyncCombat_ClaimAll")
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "Y",
            ClickCallback = self.OnBtnRewardClicked,
            Owner = self
          }
        },
        Desc = GText("UI_AsyncCombat_ClaimAll")
      })
    end
    table.insert(KeyInfo, {
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
          ClickCallback = self.CloseSelf,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    })
    self.WBP_Com_Tab:UpdateBottomKeyInfo(KeyInfo)
  end
end

return View
