require("UnLua")
local M = Class({
  "Blueprints.UI.BP_UIState_C"
})

function M:Construct()
end

function M:OnLoaded(...)
  local Params = (...)
  local ConfigData = Params.ConfigData
  self.TabConfigDatas = Params.TabConfigDatas
  self.ConfigData = ConfigData
  self.Owner = Params.Owner
  self.Type = ConfigData.Type
  self.CurrentTab = nil
  self.Type2Index = {}
  self.Datas = ConfigData.Datas
  self.Items = ConfigData.Items
  self.TabInfo = ConfigData.TabInfo
  self.HasTab = ConfigData.HasTab
  self.ReddotName = ConfigData.ReddotName
  if self.Text_Tip then
    self.Text_Tip:SetText(GText("UI_CommonQuestRefreshTitle"))
  end
  if self.ConfigData.IsPacking then
    self.Btn_DesignGet:SetDefaultGamePadImg("X")
    self.Key_Check:CreateGamepadKey("View")
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
    if not self.ConfigData.IsPacking then
      self:ScrollToSelectTab()
    end
  end
  if not self.HasTab then
    self:InitItem(ConfigData)
    self:Refresh(ConfigData)
  end
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self:AddInputMethodChangedListen()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:TryInitGamepadView()
    self.List_Item:SetFocus()
  else
    self:SetFocus()
  end
  if self.ConfigData.IsExpired then
    self.Com_Time:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Com_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Com_Time:SetTimeText(GText(self.ConfigData.TimeText or ""), self.ConfigData.RemainTimeDict or {})
  end
  if self.In then
    self:PlayAnimation(self.In)
  end
  self:InitPackingInfo(ConfigData.PackingInfo)
  EventManager:AddEvent(EventID.OnDailyRefresh, self, self.OnRefreshInNextDay)
  if ConfigData.InSoundPath then
    AudioManager(self):PlayUISound(nil, ConfigData.InSoundPath, "ActivityReward_InSound", nil)
  end
  if ConfigData.PackingInfo and ConfigData.PackingInfo.ReceiveBtnSoundPath and self.Btn_DesignGet then
    self.Btn_DesignGet.AudioEventPath = ConfigData.PackingInfo.ReceiveBtnSoundPath
  end
  if ConfigData.ReceiveBtnSoundPath and self.RewardContent_OneClick.Btn_OneClick then
    self.RewardContent_OneClick.Btn_OneClick.AudioEventPath = ConfigData.ReceiveBtnSoundPath
  end
  EventManager:AddEvent(EventID.RefreshAcvitityRewardPanel, self, self.RefreshAcvitityRewardPanel)
end

function M:RefreshAcvitityRewardPanel()
  if self.ConfigData.RefreshPanleCallBack then
    self.ConfigData.RefreshPanleCallBack(self)
  end
end

function M:AddReddotChangedListen()
  local ReddotName = self.ReddotName
  if not ReddotName then
    return
  end
  ReddotManager.AddListenerEx(ReddotName, self, function(self, Count, RdType, RdName)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
    for idx, Data in ipairs(self.ConfigData.TabInfo or {}) do
      if Data then
        local Type = Data.Type
        if CacheDetail and CacheDetail[Type] then
          self.Com_TabSub:ShowTabRedDotByTabId(idx, false, true, false)
        else
          self.Com_TabSub:ShowTabRedDotByTabId(idx, false, false, false)
        end
      end
    end
  end)
end

function M:InitPackingInfo(PackingInfo)
  if not PackingInfo then
    return
  end
  if PackingInfo.SmallItem then
    self.SmallItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.BigItem:SetVisibility(ESlateVisibility.Collapsed)
    if PackingInfo.IsHeadIcon then
      if PackingInfo.HeadFrameId then
        self.SmallItem.Com_ItemHead:SetHeadFrame(PackingInfo.HeadFrameId)
      else
        self.SmallItem.Com_ItemHead:SetHeadIcon(PackingInfo.SmallItemInfo.HeadIconId, PackingInfo.SmallItemInfo.bUsebigHead)
      end
      self.SmallItem.Com_ItemHead:SetHeadIcon(PackingInfo.SmallItemInfo.HeadIconId, PackingInfo.SmallItemInfo.Com_Item:Init(PackingInfo.ComItemInfo))
    else
      self.SmallItem.Com_Item:Init(PackingInfo.SmallItemInfo.ComItemInfo)
    end
  end
  if PackingInfo.BigItem then
    if self.SmallItem then
      self.SmallItem:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.BigItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if PackingInfo.BigItem and PackingInfo.BigItemInfo and PackingInfo.BigItemInfo.BGIconPath then
    local Img = LoadObject(PackingInfo.BigItemInfo.BGIconPath)
    if Img then
      self.BigItem.Image_RewardItem:SetBrushResourceObject(Img)
    end
  end
  if PackingInfo.BtnDetailTips then
    self.Text_BtnDetailTips:SetText(GText(PackingInfo.BtnDetailTips))
  end
  if PackingInfo.ReceveCallBack then
    self.WS_Btn:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_DesignGet:BindEventOnClicked(self, function()
      PackingInfo.ReceveParam.SelfWidget = self
      PackingInfo.ReceveCallBack(self, PackingInfo.ReceveParam)
    end)
    self.WS_Bottom:SetActiveWidgetIndex(0)
  else
    self.WS_Bottom:SetActiveWidgetIndex(1)
  end
  if PackingInfo.IsShowGotoBtn == false then
    self.WS_Btn:SetActiveWidgetIndex(1)
  else
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.Btn_Design:BindEventOnClicked(self, function()
      PackingInfo.GotoCallBackCallBack(self, PackingInfo.GotoParam)
    end)
  end
  if PackingInfo.CheckDetailCallBack then
    self.Btn_Check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Check.AudioEventPath = "event:/ui/common/click_btn_small"
    self.Btn_Check:BindEventOnClicked(self, function()
      PackingInfo.CheckDetailCallBack(self, PackingInfo.CheckDetailParam)
    end)
  else
    self.Btn_Check:SetVisibility(ESlateVisibility.Collapsed)
  end
  if PackingInfo.CanReceive then
    self.Btn_DesignGet:ForbidBtn(false)
    self.Btn_DesignGet:SetText(GText("UI_Achievement_GetReward"))
  else
    if PackingInfo.IsGot then
      self.Btn_DesignGet:SetText(GText("UI_Reward_Received"))
    else
      self.Btn_DesignGet:SetText(GText("UI_Archive_CollectionInProgress"))
    end
    self.Btn_DesignGet:ForbidBtn(true)
  end
  if PackingInfo.GetAllBtnText then
    self.Btn_DesignGet:SetText(GText(PackingInfo.GetAllBtnText))
  end
  if PackingInfo.RewardTitle then
    self.Text_RewardTitle:SetText(GText(PackingInfo.RewardTitle))
  end
  if PackingInfo.RewardDesc then
    self.Text_RewardDesc:SetText(GText(PackingInfo.RewardDesc))
  end
  if PackingInfo.BtnTips then
    self.Text_BtnTips:SetText(GText(PackingInfo.BtnTips))
  end
  self.WS_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if PackingInfo.HideReceiveBtnInfo then
    self.WS_Bottom:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:RefreshPackingGetBtn(CanReceive, IsGot)
  if CanReceive then
    self.Btn_DesignGet:ForbidBtn(false)
    self.Btn_DesignGet:SetText(GText("UI_Achievement_GetReward"))
  else
    if IsGot then
      self.Btn_DesignGet:SetText(GText("UI_Reward_Received"))
    else
      self.Btn_DesignGet:SetText(GText("UI_Archive_CollectionInProgress"))
    end
    self.Btn_DesignGet:ForbidBtn(true)
  end
end

function M:UpdateBottomKey(ShowGetAllButton)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if ShowGetAllButton then
    local BottomKeyInfo = {
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
    self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
  else
    local BottomKeyInfo = {
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
    self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
  end
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) or self:IsAnimationPlaying(self.Out) then
    return
  end
  local UIManager = UIManager(self)
  local PreviousUI = UIManager:GetUnderState()
  if PreviousUI then
    local PreviousUIName = PreviousUI:GetName()
    DebugPrint("JLY 上一个栈的UI是:", PreviousUIName)
    if "ActivityMain" == PreviousUIName then
      EventManager:FireEvent(EventID.OnReturnToActivityEntry)
      EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
    end
    if "AutoChessMain" == PreviousUIName then
      PreviousUI:PlayAnimationForward(PreviousUI.In)
      PreviousUI:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, false, UE4.ESlateVisibility.HitTestInvisible)
    end
  end
  if self.ConfigData.InSoundPath then
    AudioManager(self):SetEventSoundParam(nil, "ActivityReward_InSound", {ToEnd = 1})
  end
  if self.Out then
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, {
      self,
      self.Close
    })
    self:PlayAnimation(self.Out)
  end
end

function M:ScrollToSelectTab()
  local SelectIndex
  if self.Type then
    SelectIndex = self.Type2Index[self.Type]
  end
  SelectIndex = SelectIndex or 1
  self.List_Tab:ScrollIndexIntoView(SelectIndex - 1)
  self:AddTimer(0.1, function()
    self.List_Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local Item = self.List_Tab:GetItemAt(SelectIndex - 1)
    self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if Item then
      self.List_Tab:SetSelectedIndex(SelectIndex - 1)
      Item.Entry:OnCellClicked(true)
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(Item.Entry)
    end
  end, false, 0, "SelectRewardTab", true)
end

function M:InitItem(ConfigData)
  self.List_Item:ClearListItems()
  if 1 == ConfigData.SortType then
    self:SortItems()
  end
  local Count = 0
  for _, Item in pairs(ConfigData.Items) do
    local ClassPath = UIUtils.GetCommonItemContentClass()
    local MenuContent = NewObject(ClassPath)
    MenuContent.Owner = self
    MenuContent.ConfigData = Item
    MenuContent.Id = _ - 1
    if Item.CanReceive then
      Count = Count + 1
    end
    self.List_Item:AddItem(MenuContent)
  end
  if 2 == ConfigData.SortType then
    self:AddTimer(0.01, function()
      local AllItemCount = self.List_Item:GetNumItems()
      local IndexToScroll = 0
      for i = 0, AllItemCount - 1 do
        local Item = self.List_Item:GetItemAt(i)
        if Item.ConfigData.CanReceive then
          self.MaxRewardGot = i
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
  self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.IsEmpty = true
    return ItemContent
  end)
  self.List_Item:RequestFillEmptyContent()
end

function M:SortItems()
  if not self.Items then
    return
  end
  table.sort(self.Items, function(a, b)
    if a.CanReceive and not b.CanReceive then
      return true
    elseif not a.CanReceive and b.CanReceive then
      return false
    elseif a.RewardsGot and not b.RewardsGot then
      return false
    elseif not a.RewardsGot and b.RewardsGot then
      return true
    end
    if a.ItemId and b.ItemId then
      return a.ItemId < b.ItemId
    else
      return false
    end
  end)
end

function M:RefreshItems()
  if self.HasTab then
    self:Refresh(self.ConfigData.Datas[self.Type])
  else
    self:Refresh(self.ConfigData)
  end
end

function M:RefreshDaily()
  if self.HasTab then
    if self.ConfigData.Datas[self.Type].HasDailyQuest then
      self:Refresh(self.ConfigData.Datas[self.Type])
    end
  else
    self:Refresh(self.ConfigData)
  end
end

function M:RefreshBaseInfo()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:InitKeyBoardView()
  elseif CurInputDevice == ECommonInputType.Gamepad then
    self:TryInitGamepadView()
  end
end

function M:OnSelectItemChanged(SelectItem)
  if not SelectItem then
    return
  end
  if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
    self:ClickListItemWhenSelectItemChanged(SelectItem)
  end
end

function M:ClickListItemWhenSelectItemChanged(Content)
  if Content and Content.Entry then
    Content.Entry:OnCellClicked()
  end
end

function M:OnUINavigation(NavigationDirection)
  if NavigationDirection == EUINavigation.Left then
    if self.CurFocusedRewardItem then
      self.CurFocusedRewardItem:StopHover()
      self.CurFocusedRewardItem = nil
    end
    self:ShowGamepadViewBtn(false)
    return self.SelectedContent.Entry
  elseif NavigationDirection == EUINavigation.Right then
    self:ShowGamepadViewBtn(true)
    return self:NavigateToFirstDisplayedItem(self.List_Item)
  end
end

function M:InitListTabInfo()
  if self.ConfigData.IsPacking then
    local SubTabList = {}
    for Index, TabItem in ipairs(self.TabInfo) do
      table.insert(SubTabList, {
        Text = GText(TabItem.Title),
        TabId = Index,
        ShowRedDot = false
      })
    end
    self.Com_TabSub:Init({
      PlatformName = self.Platform,
      LeftKey = "A",
      RightKey = "D",
      Tabs = SubTabList,
      SoundFunc = function()
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_sort_tab", "TabClickSound", nil)
      end
    })
    self.Com_TabSub:BindEventOnTabSelected(self, self.OnTabSelected)
    self.Com_TabSub:SelectTab(1)
    self:AddReddotChangedListen()
    if #SubTabList <= 1 then
      self.Group_DetailTab:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.Group_DetailTab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  else
    self.List_Tab.BP_OnItemSelectionChanged:Add(self, self.OnSelectItemChanged)
    self.List_Tab:SetNavigationRuleCustom(EUINavigation.Right, {
      self,
      self.OnUINavigation
    })
    self.List_Tab:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.List_Item:SetNavigationRuleCustom(EUINavigation.Left, {
      self,
      self.OnUINavigation
    })
    self.List_Item:SetControlScrollbarInside(true)
    local ClassPath = "/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C"
    self.List_Tab:ClearListItems()
    for Index, TabItem in ipairs(self.TabInfo) do
      local Obj = NewObject(UE4.LoadClass(ClassPath))
      Obj.Root = self
      Obj.Index = Index
      Obj.Title = TabItem.Title
      Obj.Type = TabItem.Type
      Obj.ReddotName = TabItem.ReddotName
      Obj.IsShowIcon = TabItem.IsShowIcon
      Obj.IconPath = TabItem.IconPath
      self.List_Tab:AddItem(Obj)
      self.Type2Index[TabItem.Type] = Index
    end
  end
end

function M:RefreshListRewardInfo(Item, NotPlaySound)
  if self.SelectedContent then
    self.SelectedContent.Entry:UnSelected()
  end
  self.SelectedContent = Item.Content
  self.SelectedContent.Entry:Selected(NotPlaySound)
  self:RealRefreshListRewardInfo(self.SelectedContent.Type)
end

function M:RealRefreshListRewardInfo(TabType)
  local ConfigData = self.Datas[TabType]
  self.Type = TabType
  self:Refresh(ConfigData)
  self:RefreshBtnGetAll(ConfigData)
  self:PlayAnimation(self.Change)
  self:AddTimer(0.01, function()
    UIUtils.PlayListViewFramingInAnimation(self, self.List_Item, {
      AnimName = "In",
      Callback = function()
        self:NavigateToFirstDisplayedItem(self.List_Item)
      end
    })
  end, false, 0, nil, true)
end

function M:RefreshBtnGetAll(ConfigData)
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

function M:RefreshReddotInfo()
  local TabType = self.SelectedContent and self.SelectedContent.Type or self.Type
  if not TabType then
    DebugPrint("@@@ComDilaog Reward RefreshReddotInfo: no tab type to clear reddot", self.ReddotName)
    return
  end
  DebugPrint("@@@ComDilaog Reward Try Clear Reddot ReddotName:", self.ReddotName, " Type:", TabType)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotName)
  if CacheDetail[TabType] then
    local Num = 0
    for _, _ in pairs(CacheDetail[TabType]) do
      Num = Num + 1
    end
    CacheDetail[TabType] = nil
    DebugPrint("@@@ComDilaog Reward Clear Reddot ReddotName:", self.ReddotName, " Type:", TabType, " Num:", Num)
    ReddotManager.DecreaseLeafNodeCount(self.ReddotName, Num)
  end
end

function M:Destruct()
  self.Super.Destruct(self)
  ReddotManager.RemoveListener(self.ReddotName, self)
  EventManager:RemoveEvent(EventID.OnDailyRefresh, self)
  self:RemoveInputMethodChangedListen()
  if self.List_Tab then
    self.List_Tab:ClearListItems()
  end
  self.List_Item:ClearListItems()
end

function M:NavigateToFirstDisplayedItem(List)
  local ItemUIs = List:GetDisplayedEntryWidgets()
  if ItemUIs:Length() > 0 then
    local TargetWidget
    for i = 1, ItemUIs:Length() do
      local Widget = ItemUIs:GetRef(i)
      if Widget.Content then
        local Index = Widget.Content.Id
        if Index and (not TargetWidget or Index < TargetWidget.Content.Id) then
          TargetWidget = Widget
        end
      end
    end
    if TargetWidget then
      List:BP_NavigateToItem(TargetWidget.Content)
      return TargetWidget
    end
  end
  return List
end

function M:TryInitGamepadView()
  self:InitGamepadView()
end

function M:InitGamepadView()
  self:NavigateToFirstDisplayedItem(self.List_Item)
  self.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(true)
  if not self.RewardContent_OneClick.Btn_OneClick:IsBtnForbidden() then
    self.RewardContent_OneClick.Btn_OneClick:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.ConfigData.IsPacking then
    self.Btn_DesignGet:SetGamePadIconVisible(true)
    if not self.Btn_DesignGet:IsBtnForbidden() then
      self.Btn_DesignGet:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
  end
  if self.Key_Check then
    self.Key_Check:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self:ShowGamepadViewBtn(true)
end

function M:InitKeyBoardView()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  self.IsInViewMode = false
  self.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(false)
  if not self.RewardContent_OneClick.Btn_OneClick:IsBtnForbidden() then
    self.RewardContent_OneClick.Btn_OneClick:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if self.ConfigData.IsPacking then
    self.Btn_DesignGet:SetGamePadIconVisible(false)
    if not self.Btn_DesignGet:IsBtnForbidden() then
      self.Btn_DesignGet:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end
  if self.Key_Check then
    self.Key_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:ShowGamepadViewBtn(false)
  local ConfigData = self.Datas[self.Type]
  ConfigData = ConfigData or self.ConfigData
  self:RefreshBtnGetAll(ConfigData)
  self:PlayAnimation(self.Normal)
end

function M:ShowGamepadScrollBtn(bShow)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if bShow then
  else
  end
end

function M:ShowGamepadViewBtn(bShow)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if bShow then
    local IsScrollable = self:CheckDescScrollable()
    if IsScrollable then
      self.Com_Tab:UpdateBottomKeyInfo({
        {
          GamePadInfoList = {
            {
              Type = "Img",
              ImgShortPath = "RV",
              Owner = self
            }
          },
          Desc = GText("UI_Controller_Slide"),
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
    if self.ConfigData.IsPacking then
      self.Btn_DesignGet:SetGamePadIconVisible(true)
      self.Com_TabSub:UpdateUIStyleInPlatform(true)
    end
  else
    self.Com_Tab:UpdateBottomKeyInfo({
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
    if self.ConfigData.IsPacking then
      self.Btn_DesignGet:SetGamePadIconVisible(false)
      self.Com_TabSub:UpdateUIStyleInPlatform(false)
    end
  end
end

function M:ShowGamepadViewSingleBtn(bShow)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if bShow then
    self.Com_Tab:UpdateBottomKeyInfo({
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckReward"),
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
    self.Com_Tab:UpdateBottomKeyInfo({})
  end
end

function M:RefreshButton(CanReceiveAll)
  if not CanReceiveAll then
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
    self:UpdateBottomKey(false)
  else
    self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(false)
    self:UpdateBottomKey(true)
  end
end

function M:OnTabSelected(TabWidget)
  if self.ConfigData and self.ConfigData.TabInfo[TabWidget.Idx] then
    self:RealRefreshListRewardInfo(self.ConfigData.TabInfo[TabWidget.Idx].Type)
  end
end

function M:Refresh(ConfigData)
  self.Items = ConfigData.Items
  if ConfigData.NeedDailyRefresh then
    if self.Text_Tip then
      self.Text_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  elseif self.Text_Tip then
    self.Text_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.RewardContent_OneClick.Text_ProgressTitle:SetText(GText(ConfigData.Text_Total))
  self.RewardContent_OneClick.Count_Main:SetText(tostring(ConfigData.NowNum))
  self.RewardContent_OneClick.Max_Main:SetText(tostring(ConfigData.NumMax))
  self.RewardContent_OneClick.Progress_Main:SetPercent(ConfigData.NowNum / ConfigData.NumMax)
  self.RewardContent_OneClick.Btn_OneClick:SetText(GText(ConfigData.ReceiveButtonText))
  self.RewardContent_OneClick.Btn_OneClick:UnBindEventOnClickedByObj(self)
  self.RewardContent_OneClick.Btn_OneClick:BindEventOnClicked(self, function()
    ConfigData.ReceiveAllParam.SelfWidget = self
    ConfigData.ReceiveAllCallBack(self, ConfigData.ReceiveAllParam)
  end)
  self:InitItem(ConfigData)
end

function M:OnNavigateUp(Content)
  local Id = Content.Id - 1
  if Id >= 0 then
    local Item = self.List_Item:GetItemAt(Id)
    self.List_Item:NavigateToIndex(Id)
    return Item.SelfWidget:FocusToRewardItem()
  end
  return Content.SelfWidget:FocusToRewardItem()
end

function M:OnNavigateDown(Content)
  local Id = Content.Id + 1
  local AllItemCount = self.List_Item:GetNumItems() - 1
  if Id <= AllItemCount then
    local Item = self.List_Item:GetItemAt(Id)
    self.List_Item:NavigateToIndex(Id)
    return Item.SelfWidget:FocusToRewardItem()
  end
  return Content.SelfWidget:FocusToRewardItem()
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
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    if bIsOpen then
      self:UpdateUIStyle(false)
    else
      self:UpdateUIStyle(true)
    end
  end
end

function M:UpdateUIStyle(IsVisible)
  if IsVisible then
    self:ShowGamepadViewSingleBtn(true)
  else
    self:ShowGamepadViewSingleBtn(false)
  end
end

function M:OnRefreshInNextDay()
  if self.ConfigData.DailyRefreshFunc then
    local Params = {}
    local RefreshParam = {}
    RefreshParam.SelfWidget = self
    
    function Params.RightCallbackFunction()
      self.ConfigData.DailyRefreshFunc(self, RefreshParam)
    end
    
    UIManager(self):ShowCommonPopupUI(100310, Params)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonTop and not self.IsInViewMode then
      IsEventHandled = true
      self.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
    elseif self.ConfigData.IsPacking and not self.IsInViewMode then
      IsEventHandled = self.Com_TabSub:Handle_KeyEventOnGamePad(InKeyName)
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      IsEventHandled = true
      self:CloseSelf()
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.ConfigData.IsPacking then
      self.Btn_DesignGet:OnBtnClicked()
    end
    if InKeyName == UIConst.GamePadKey.SpecialLeft and self.ConfigData.IsPacking and self.ConfigData.PackingInfo.CheckDetailCallBack then
      self.ConfigData.PackingInfo.CheckDetailCallBack(self, self.ConfigData.PackingInfo.CheckDetailParam)
    end
  elseif "SpaceBar" == InKeyName then
    IsEventHandled = true
    self.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:CloseSelf()
  end
  if self.ConfigData.IsPacking and not IsEventHandled then
    IsEventHandled = self.Com_TabSub:Handle_KeyEventOnPC(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:CheckDescScrollable()
  if not self.EMScroll_Desc then
    return false
  end
  local ScrollOffsetMax = self.EMScroll_Desc:GetScrollOffsetOfEnd()
  return ScrollOffsetMax > 0
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
  local AxisValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if "Gamepad_RightY" == KeyName and self.EMScroll_Desc and self:CheckDescScrollable() and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    local CurrentOffset = self.EMScroll_Desc:GetScrollOffset()
    local ScrollSpeed = 10.0
    local NewOffset = CurrentOffset - AxisValue * ScrollSpeed
    local MaxOffset = self.EMScroll_Desc:GetScrollOffsetOfEnd()
    NewOffset = math.max(0, math.min(NewOffset, MaxOffset))
    self.EMScroll_Desc:SetScrollOffset(NewOffset)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
